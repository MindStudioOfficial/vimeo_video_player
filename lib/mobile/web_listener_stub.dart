import 'dart:async';

StreamSubscription<dynamic> setupWebListener(Function(dynamic) _) {
  // No-op for non-web platforms
  return StreamController<dynamic>().stream.listen((_) {});
}
