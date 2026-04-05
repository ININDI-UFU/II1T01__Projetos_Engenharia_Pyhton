bool get isFullscreen => false;
Future<void> enterFullscreen() async {}
Future<void> exitFullscreen() async {}
Future<void> toggleFullscreen() async {}
void onFullscreenChange(void Function(bool) callback) {}
