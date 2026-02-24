import 'dart:io';

import 'package:image/image.dart' as img;

/// Service for processing images, specifically cropping to center square and compressing.
class ImageProcessingService {
  /// Maximum dimension for processed images (reduces memory usage and file size)
  static const int _maxDimension = 2048;
  
  /// JPEG quality (0-100), lower = smaller file size
  static const int _jpegQuality = 85;

  /// Crops image to center square, resizes if needed, compresses, and saves to a temp file.
  /// When [previewWidth] and [previewHeight] are provided (from camera preview), the crop
  /// is computed so the saved square matches what was inside the preview's center square,
  /// avoiding "wider" saved image than what the user framed.
  /// When [flipHorizontal] is true (e.g. front camera), the image is mirrored so the saved
  /// result matches what the user saw in the preview.
  /// Returns path or null on failure.
  Future<String?> cropToCenterSquare(
    String sourcePath, {
    double? previewWidth,
    double? previewHeight,
    bool flipHorizontal = false,
  }) async {
    try {
      final file = File(sourcePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return null;

      var image = img.decodeImage(bytes);
      if (image == null) return null;

      // Front camera captures are often not mirrored; flip so saved image matches preview.
      if (flipHorizontal) {
        image = img.flipHorizontal(image);
      }

      final captureW = image.width;
      final captureH = image.height;
      if (captureW <= 0 || captureH <= 0) return null;

      int cropX;
      int cropY;
      int cropSize;

      if (previewWidth != null &&
          previewHeight != null &&
          previewWidth > 0 &&
          previewHeight > 0) {
        // Map preview center square to capture image coords so saved crop matches what user saw.
        final scaleW = captureW / previewWidth;
        final scaleH = captureH / previewHeight;
        final scaleUsed = scaleW < scaleH ? scaleW : scaleH;

        final previewInCaptureW = (previewWidth * scaleUsed).round();
        final previewInCaptureH = (previewHeight * scaleUsed).round();
        final left = ((captureW - previewInCaptureW) / 2).round();
        final top = ((captureH - previewInCaptureH) / 2).round();

        final previewSquareSide = previewWidth < previewHeight ? previewWidth : previewHeight;
        int squareInCaptureSize = (previewSquareSide * scaleUsed).round();
        squareInCaptureSize = squareInCaptureSize.clamp(1, captureW).clamp(1, captureH);

        cropX = left + ((previewInCaptureW - squareInCaptureSize) ~/ 2);
        cropY = top + ((previewInCaptureH - squareInCaptureSize) ~/ 2);
        cropX = cropX.clamp(0, captureW - squareInCaptureSize);
        cropY = cropY.clamp(0, captureH - squareInCaptureSize);
        cropSize = squareInCaptureSize;
      } else {
        // No preview info (e.g. from gallery): use center square of image.
        cropSize = captureW < captureH ? captureW : captureH;
        if (cropSize <= 0) return null;
        cropX = (captureW - cropSize) ~/ 2;
        cropY = (captureH - cropSize) ~/ 2;
      }

      var cropped = img.copyCrop(
        image,
        x: cropX,
        y: cropY,
        width: cropSize,
        height: cropSize,
      );

      // Resize if image is too large (reduces memory usage and file size)
      if (cropped.width > _maxDimension || cropped.height > _maxDimension) {
        final scale = _maxDimension / (cropped.width > cropped.height ? cropped.width : cropped.height);
        cropped = img.copyResize(
          cropped,
          width: (cropped.width * scale).round(),
          height: (cropped.height * scale).round(),
          interpolation: img.Interpolation.linear,
        );
      }

      // Handle different file extensions
      final lastDotIndex = sourcePath.lastIndexOf('.');
      final basePath = lastDotIndex >= 0 
          ? sourcePath.substring(0, lastDotIndex)
          : sourcePath;
      final newPath = '${basePath}_crop.jpg';
      final newFile = File(newPath);
      
      // Compress and save as JPEG
      await newFile.writeAsBytes(
        img.encodeJpg(cropped, quality: _jpegQuality),
      );

      return newFile.path;
    } catch (_) {
      return null;
    }
  }
}
