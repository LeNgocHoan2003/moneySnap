import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/money_utils.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/entities/expense.dart';
import '../services/camera_service.dart';
import '../services/image_processing_service.dart';
import '../stores/expense_store.dart';
import '../widgets/capture/camera_error_widget.dart';
import '../widgets/capture/camera_preview_widget.dart';
import '../widgets/capture/capture_expense_bottom_controls.dart';
import '../widgets/capture/capture_expense_top_bar.dart';
import '../widgets/capture/capture_preview_widget.dart';
import '../widgets/dialogs/camera_permission_dialog.dart';

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
  final _cameraService = CameraService();
  final _imageProcessingService = ImageProcessingService();
  
  bool _isInitializing = true;
  bool _isCapturing = false;
  String? _errorMessageKey;
  String? _errorMessageCode;
  String? _capturedImagePath;
  final _amountController = TextEditingController();
  bool _saving = false;
  bool _isPositive = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      await _cameraService.initialize();
      if (_cameraService.cameras.isEmpty) {
        setState(() {
          _errorMessageKey = 'no_camera';
          _errorMessageCode = null;
          _isInitializing = false;
        });
        return;
      }
      setState(() {
        _errorMessageKey = null;
        _errorMessageCode = null;
        _isInitializing = false;
      });
    } on CameraException catch (e) {
      setState(() {
        _errorMessageKey = 'camera_error';
        _errorMessageCode = e.code;
        _isInitializing = false;
      });
      if (mounted) CameraPermissionDialog.show(context);
    } catch (_) {
      setState(() {
        _errorMessageKey = 'permission';
        _errorMessageCode = null;
        _isInitializing = false;
      });
      if (mounted) CameraPermissionDialog.show(context);
    }
  }

  Future<void> _switchCamera() async {
    try {
      await _cameraService.switchCamera();
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t.cameraCaptureFailed(error: e.toString()))),
        );
      }
    }
  }

  Future<void> _toggleFlash() async {
    await _cameraService.toggleFlash();
    setState(() {});
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile != null && mounted) {
      final croppedPath = await _imageProcessingService.cropToCenterSquare(xfile.path);
      if (!mounted) return;
      setState(() {
        _capturedImagePath = croppedPath ?? xfile.path;
        _amountController.clear();
        _isPositive = false;
      });
    }
  }

  Future<void> _takePicture() async {
    if (!_cameraService.isInitialized || _isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final xfile = await _cameraService.takePicture();
      if (!mounted) return;
      final controller = _cameraService.controller;
      final previewSize = controller?.value.previewSize;
      final croppedPath = await _imageProcessingService.cropToCenterSquare(
        xfile.path,
        previewWidth: previewSize != null ? previewSize.width : null,
        previewHeight: previewSize != null ? previewSize.height : null,
        flipHorizontal: _cameraService.isFrontCamera,
      );
      if (!mounted) return;
      setState(() {
        _capturedImagePath = croppedPath ?? xfile.path;
        _amountController.clear();
        _isPositive = false;
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

    if (!mounted) return;
    setState(() => _saving = true);
    
    try {
      final signedAmount = _isPositive ? amount : -amount;
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: _capturedImagePath!,
        date: widget.initialDate ?? DateTime.now(),
        amount: signedAmount,
        description: '',
      );
      await widget.store.addExpense(expense);
      
      if (!mounted) return;
      
      FocusScope.of(context).unfocus();
      await Future.microtask(() {});
      
      if (mounted) {
        widget.onSaved();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        setState(() => _saving = false);
      }
    }
  }

  void _backToCamera() {
    FocusScope.of(context).unfocus();
    setState(() {
      _capturedImagePath = null;
      _amountController.clear();
      _isPositive = false;
    });
  }

  @override
  void dispose() {
    // Note: dispose() is synchronous, but cameraService.dispose() is async.
    // In Flutter, we can't await in dispose(), so we use unawaited to avoid warnings.
    unawaited(_cameraService.dispose());
    _amountController.clear();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessageKey != null) {
      return CameraErrorWidget(
        errorKey: _errorMessageKey!,
        errorCode: _errorMessageCode,
        onRetry: () {
          setState(() {
            _errorMessageKey = null;
            _errorMessageCode = null;
            _isInitializing = true;
          });
          _initCamera();
        },
      );
    }

    final controller = _cameraService.controller;
    if (!_cameraService.isInitialized || controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.sizeOf(context);
    final squareSize = size.width * 0.8;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview or capture preview
          if (_capturedImagePath != null)
            CapturePreviewWidget(
              imagePath: _capturedImagePath!,
              squareSize: squareSize,
              amountController: _amountController,
              isPositive: _isPositive,
              onSignChanged: (isPositive) => setState(() => _isPositive = isPositive),
            )
          else
            CameraPreviewWidget(
              controller: controller,
              squareSize: squareSize,
            ),
          CaptureExpenseTopBar(
            onClose: _capturedImagePath != null
                ? _backToCamera
                : () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
            showFlash: _capturedImagePath == null,
            isFlashOn: _cameraService.isFlashOn,
            onToggleFlash: _toggleFlash,
          ),
          CaptureExpenseBottomControls(
            isPreviewMode: _capturedImagePath != null,
            saving: _saving,
            onRetry: _backToCamera,
            onSave: _saveExpense,
            onPickFromGallery: _pickFromGallery,
            onTakePicture: _takePicture,
            onSwitchCamera: _switchCamera,
            isCapturing: _isCapturing,
            canSwitchCamera: _cameraService.cameras.length >= 2,
          ),
        ],
      ),
    );
  }
}
