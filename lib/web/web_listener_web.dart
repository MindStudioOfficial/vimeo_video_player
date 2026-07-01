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
  final element = web.document.getElementById('flutter_inappwebview-0');

  if (element is! web.HTMLIFrameElement) {
    web.console.warn('Vimeo iframe not found'.toJS);
    return;
  }

  element.contentWindow?.postMessage(
    {
      'type': 'vimeoCommand',
      'command': command,
      if (seconds != null) 'seconds': seconds,
    }.jsify(),
    '*'.toJS,
  );
}
