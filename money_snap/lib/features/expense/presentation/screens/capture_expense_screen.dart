import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/money_utils.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/entities/expense.dart';
import '../stores/expense_store.dart';
import '../widgets/amount_suggestion_bar.dart';

/// Fullscreen camera capture screen for receipt photos (per take_picture.md).
/// Stack: CameraPreview, overlay, square frame, top bar, hint, bottom controls.
class CaptureExpenseScreen extends StatefulWidget {
  const CaptureExpenseScreen({
    super.key,
    required this.store,
    required this.onSaved,
    this.initialDate,
  });

  final ExpenseStore store;
  final VoidCallback onSaved;
  /// Optional date to use for the saved expense (e.g. tapped day on calendar).
  final DateTime? initialDate;

  @override
  State<CaptureExpenseScreen> createState() => _CaptureExpenseScreenState();
}

class _CaptureExpenseScreenState extends State<CaptureExpenseScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;
  bool _flashOn = false;
  bool _isCapturing = false;
  bool _showFlashOverlay = false;
  /// Error key for display (looked up in build with t). Nullable code for cameraError.
  String? _errorMessageKey;
  String? _errorMessageCode;
  /// After taking a picture, show image + amount (no popup).
  String? _capturedImagePath;
  final _amountController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      // Camera plugin triggers system permission dialog on first use.
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _errorMessageKey = 'no_camera';
          _errorMessageCode = null;
        });
        return;
      }
      await _initController(_currentCameraIndex);
    } on CameraException catch (e) {
      setState(() {
        _errorMessageKey = 'camera_error';
        _errorMessageCode = e.code;
      });
      if (mounted) _showPermissionDialog();
    } catch (e) {
      setState(() {
        _errorMessageKey = 'permission';
        _errorMessageCode = null;
      });
      if (mounted) _showPermissionDialog();
    }
  }

  /// Shows a system-style popup so the user can open Settings to enable camera.
  void _showPermissionDialog() {
    final t = context.t;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.cameraAccessNeeded),
        content: Text(t.cameraPermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await AppSettings.openAppSettings();
            },
            child: Text(t.commonOpenSettings),
          ),
        ],
      ),
    );
  }

  Future<void> _initController(int index) async {
    if (_controller != null) {
      await _controller!.dispose();
    }
    final camera = _cameras[index];
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );
    await controller.initialize();
    if (!mounted) return;
    setState(() {
      _controller = controller;
      _errorMessageKey = null;
      _errorMessageCode = null;
    });
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    await _initController(_currentCameraIndex);
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      setState(() => _flashOn = !_flashOn);
      await _controller!.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    } catch (_) {
      setState(() => _flashOn = false);
    }
  }

  /// Crops image to center square and saves to a temp file. Returns path or null on failure.
  Future<String?> _cropToCenterSquare(String sourcePath) async {
    try {
      final bytes = await File(sourcePath).readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return null;
      final w = decoded.width;
      final h = decoded.height;
      final side = w < h ? w : h;
      final left = (w - side) ~/ 2;
      final top = (h - side) ~/ 2;
      final cropped = img.copyCrop(decoded, x: left, y: top, width: side, height: side);
      final jpg = img.encodeJpg(cropped, quality: 90);
      final dir = await getTemporaryDirectory();
      final outFile = File('${dir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await outFile.writeAsBytes(jpg);
      return outFile.path;
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile != null && mounted) {
      final croppedPath = await _cropToCenterSquare(xfile.path);
      if (!mounted) return;
      setState(() {
        _capturedImagePath = croppedPath ?? xfile.path;
        _amountController.clear();
      });
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final xfile = await _controller!.takePicture();
      if (!mounted) return;
      setState(() => _showFlashOverlay = true);
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      final croppedPath = await _cropToCenterSquare(xfile.path);
      if (!mounted) return;
      setState(() {
        _showFlashOverlay = false;
        _capturedImagePath = croppedPath ?? xfile.path;
        _amountController.clear();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t.cameraCaptureFailed(error: e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  Future<void> _saveExpense() async {
    if (_capturedImagePath == null) return;
    final amount = MoneyUtils.parseAmount(_amountController.text);
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.expenseEnterDescription)),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: _capturedImagePath!,
        date: widget.initialDate ?? DateTime.now(),
        amount: amount,
        description: '',
      );
      await widget.store.addExpense(expense);
      if (mounted) widget.onSaved();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _backToCamera() {
    setState(() {
      _capturedImagePath = null;
      _amountController.clear();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if (_errorMessageKey != null) {
      final t = context.t;
      final message = switch (_errorMessageKey!) {
        'no_camera' => t.errorsNoCamera,
        'permission' => t.errorsCameraPermission,
        'camera_error' => t.cameraError(code: _errorMessageCode ?? ''),
        _ => _errorMessageKey!,
      };
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton.icon(
                  onPressed: () async {
                    await AppSettings.openAppSettings();
                  },
                  icon: const Icon(Icons.settings),
                  label: Text(t.commonOpenSettings),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _errorMessageKey = null;
                      _errorMessageCode = null;
                    });
                    _initCamera();
                  },
                  child: Text(t.commonRetry),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(t.commonClose),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final squareSize = size.width * 0.8;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // When captured: dark background. Otherwise: camera preview.
          if (_capturedImagePath != null)
            Positioned.fill(
              child: Container(color: AppColors.overlayStrong),
            )
          else ...[
            Positioned.fill(child: CameraPreview(_controller!)),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: size.height * 0.25,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.overlayStrong, AppColors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: size.height * 0.35,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.overlayStrong, AppColors.transparent],
                  ),
                ),
              ),
            ),
          ],
          // Center square: empty frame when capturing, cropped image when captured
          Center(
            child: Container(
              width: squareSize,
              height: squareSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.textLightMuted, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.overlayDark,
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: _capturedImagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.file(
                        File(_capturedImagePath!),
                        fit: BoxFit.cover,
                        width: squareSize,
                        height: squareSize,
                      ),
                    )
                  : null,
            ),
          ),
          // Below square: AMOUNT SPENT label + large amount field when captured
          if (_capturedImagePath != null) ...[
            Positioned(
              left: 0,
              right: 0,
              bottom: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.t.expenseAmountSpent.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                      decoration: InputDecoration(
                        hintText: '0 đ',
                        hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.lg,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          borderSide: BorderSide(color: AppColors.border, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          borderSide: BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
            ),
            // Suggestion bar fixed above keyboard (visible only when keyboard open)
            // if (MediaQuery.of(context).viewInsets.bottom > 0)
            //   Positioned(
            //     left: 0,
            //     right: 0,
            //     bottom: MediaQuery.of(context).viewInsets.bottom,
            //     child: ValueListenableBuilder<TextEditingValue>(
            //       valueListenable: _amountController,
            //       builder: (context, value, _) => AmountSuggestionBar(
            //         currentRawValue: value.text,
            //         onTapAmount: (rawAmount) {
            //           _amountController.text = rawAmount.toString();
            //           _amountController.selection = TextSelection.collapsed(
            //             offset: _amountController.text.length,
            //           );
            //         },
            //       ),
            //     ),
            //   ),
          ],
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleButton(
                    icon: Icons.close,
                    onPressed: _capturedImagePath != null
                        ? _backToCamera
                        : () => Navigator.of(context).pop(),
                  ),
                  if (_capturedImagePath == null)
                    _CircleButton(
                      icon: _flashOn ? Icons.flash_on : Icons.flash_off,
                      onPressed: _toggleFlash,
                    )
                  else
                    const SizedBox(width: 48, height: 48),
                ],
              ),
            ),
          ),
          // Bottom: when captured = Retake + Save; otherwise = Gallery | Shutter | Switch
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
            child: _capturedImagePath != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _CircleButton(
                          icon: Icons.refresh,
                          onPressed: _backToCamera,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: FilledButton(
                            onPressed: _saving ? null : _saveExpense,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF7C7FEA),
                              foregroundColor: AppColors.textLight,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              ),
                              elevation: 0,
                            ),
                            child: _saving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.textLight,
                                    ),
                                  )
                                : Text(
                                    context.t.expenseSaveExpense,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CircleButton(
                        icon: Icons.photo_library_outlined,
                        onPressed: _pickFromGallery,
                      ),
                      _CaptureButton(
                        onPressed: _isCapturing ? null : _takePicture,
                        isCapturing: _isCapturing,
                      ),
                      _CircleButton(
                        icon: Icons.cameraswitch,
                        onPressed: _cameras.length < 2 ? null : _switchCamera,
                      ),
                    ],
                  ),
          ),
          if (_showFlashOverlay)
            Positioned.fill(
              child: Container(color: AppColors.textLight),
            ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.overlayMedium,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(child: Icon(icon, color: AppColors.textLight)),
        ),
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.onPressed, required this.isCapturing});

  final VoidCallback? onPressed;
  final bool isCapturing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedScale(
        scale: isCapturing ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.textLight, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.overlayDark,
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
