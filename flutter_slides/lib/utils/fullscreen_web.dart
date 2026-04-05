import 'dart:js_interop';
import 'package:web/web.dart' as web;

bool get isFullscreen => web.document.fullscreenElement != null;

Future<void> enterFullscreen() async {
  try {
    await web.document.documentElement!.requestFullscreen().toDart;
  } catch (_) {}
}

Future<void> exitFullscreen() async {
  try {
    await web.document.exitFullscreen().toDart;
  } catch (_) {}
}

Future<void> toggleFullscreen() async {
  if (isFullscreen) {
    await exitFullscreen();
  } else {
    await enterFullscreen();
  }
}

void onFullscreenChange(void Function(bool) callback) {
  web.document.addEventListener(
    'fullscreenchange',
    ((web.Event _) => callback(isFullscreen)).toJS,
  );
}
