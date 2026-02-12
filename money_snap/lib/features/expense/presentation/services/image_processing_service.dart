import 'dart:io';

import 'package:image/image.dart' as img;

/// Service for processing images, specifically cropping to center square and compressing.
class ImageProcessingService {
  /// Maximum dimension for processed images (reduces memory usage and file size)
  static const int _maxDimension = 2048;
  
  /// JPEG quality (0-100), lower = smaller file size
  static const int _jpegQuality = 85;

  /// Crops image to center square, resizes if needed, compresses, and saves to a temp file.
  /// Returns path or null on failure.
  Future<String?> cropToCenterSquare(String sourcePath) async {
    try {
      final file = File(sourcePath);
      if (!await file.exists()) return null;
      
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return null;
      
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      // Crop to center square
      final size = image.width < image.height ? image.width : image.height;
      if (size <= 0) return null;

      var cropped = img.copyCrop(
        image,
        x: (image.width - size) ~/ 2,
        y: (image.height - size) ~/ 2,
        width: size,
        height: size,
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
