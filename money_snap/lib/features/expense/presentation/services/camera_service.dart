import 'package:camera/camera.dart';

/// Service for managing camera operations: initialization, switching, and flash control.
class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;
  bool _flashOn = false;

  /// Gets the current camera controller.
  CameraController? get controller => _controller;

  /// Gets the list of available cameras.
  List<CameraDescription> get cameras => _cameras;

  /// Gets the current camera index.
  int get currentCameraIndex => _currentCameraIndex;

  /// Checks if flash is currently on.
  bool get isFlashOn => _flashOn;

  /// Checks if camera is initialized.
  bool get isInitialized => _controller?.value.isInitialized ?? false;

  /// True when the current camera is front-facing (selfie). Used to mirror the captured image
  /// so it matches the preview.
  bool get isFrontCamera =>
      _cameras.isNotEmpty &&
      _currentCameraIndex < _cameras.length &&
      _cameras[_currentCameraIndex].lensDirection == CameraLensDirection.front;

  /// Initializes available cameras and sets up the first camera.
  Future<void> initialize() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      await _initController(_currentCameraIndex);
    }
  }

  /// Initializes a camera controller for the given camera index.
  Future<void> _initController(int index) async {
    if (_controller != null) {
      await _controller!.dispose();
    }
    if (index >= _cameras.length) return;
    final camera = _cameras[index];
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );
    try {
      await controller.initialize();
      _controller = controller;
    } catch (e) {
      await controller.dispose();
      rethrow;
    }
  }

  /// Switches to the next available camera.
  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;
    final previousIndex = _currentCameraIndex;
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    try {
      await _initController(_currentCameraIndex);
    } catch (_) {
      // Revert to previous camera if switch fails
      _currentCameraIndex = previousIndex;
      rethrow;
    }
  }

  /// Toggles flash mode on/off.
  Future<void> toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final previousFlashState = _flashOn;
    try {
      _flashOn = !_flashOn;
      await _controller!.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    } catch (_) {
      // Revert to previous state if toggle fails
      _flashOn = previousFlashState;
    }
  }

  /// Takes a picture using the current camera.
  Future<XFile> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw StateError('Camera not initialized');
    }
    return await _controller!.takePicture();
  }

  /// Disposes the camera controller and releases resources.
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}
