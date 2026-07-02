import 'dart:async';

import 'package:web/web.dart' as web;
import 'dart:js_interop';

StreamSubscription<dynamic> setupWebListener(Function(dynamic) onEvent) {
  return web.window.onMessage.listen((event) {
    final data = event.data;

    if (data is JSAny) {
      final dartData = data.dartify();
      if (dartData is Map && dartData['vimeoEvent'] != null) {
        onEvent(dartData['vimeoEvent']);
      }
    }
  });
}

void sendVimeoCommand({
  required String command,
  double? seconds,
}) {
  final element = web.document.querySelector(
    'iframe[id^="flutter_inappwebview-"]',
  );

  if (element == null || !element.isA<web.HTMLIFrameElement>()) {
    web.console.warn('Vimeo InAppWebView iframe not found'.toJS);
    return;
  }

  final iframe = element as web.HTMLIFrameElement;

  iframe.contentWindow?.postMessage(
    {
      'type': 'vimeoCommand',
      'command': command,
      if (seconds != null) 'seconds': seconds,
    }.jsify(),
    '*'.toJS,
  );
}
