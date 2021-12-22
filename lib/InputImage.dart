import 'dart:typed_data';
import 'package:flutter/cupertino.dart';

class InputImage {
  InputImage._(
      {String? filePath,
        Uint8List? bytes,
        required String imageType,
        InputImageData? inputImageData})
      : filePath = filePath,
        bytes = bytes,
        imageType = imageType,
        inputImageData = inputImageData;

  /// Create InputImage from path of image stored in device.
  factory InputImage.fromFilePath(String path) {
    return InputImage._(filePath: path, imageType: 'file');
  }

  final String? filePath;
  final Uint8List? bytes;
  final String imageType;
  final InputImageData? inputImageData;

  Map<String, dynamic> getImageData() {
    var map = <String, dynamic>{
      'bytes': bytes,
      'type': imageType,
      'path': filePath,
      'metadata':
      inputImageData == null ? 'none' : inputImageData!.getMetaData()
    };
    return map;
  }
}

/// Data of image required when creating image from bytes.
class InputImageData {
  /// Size of image.
  final Size size;

  /// Image rotation degree.
  final InputImageRotation imageRotation;

  /// Format of the input image.
  final InputImageFormat inputImageFormat;

  /// The plane attributes to create the image buffer on iOS.
  ///
  /// Not used on Android.
  final List<InputImagePlaneMetadata>? planeData;

  InputImageData(
      {required this.size,
        required this.imageRotation,
        required this.inputImageFormat,
        required this.planeData});

  /// Function to get the metadata of image processing purposes
  Map<String, dynamic> getMetaData() {
    var map = <String, dynamic>{
      'width': size.width,
      'height': size.height,
      'rotation': imageRotation.rawValue,
      'imageFormat': inputImageFormat.rawValue,
      'planeData': planeData
          ?.map((InputImagePlaneMetadata plane) => plane._serialize())
          .toList(),
    };
    return map;
  }
}


// To indicate the format of image while creating input image from bytes
enum InputImageFormat { NV21, YV12, YUV_420_888, YUV420, BGRA8888 }

/// Plane attributes to create the image buffer on iOS.
///
/// When using iOS, [height], and [width] throw [AssertionError]
/// if `null`.
class InputImagePlaneMetadata {
  InputImagePlaneMetadata({
    required this.bytesPerRow,
    this.height,
    this.width,
  });

  /// The row stride for this color plane, in bytes.
  final int bytesPerRow;

  /// Height of the pixel buffer on iOS.
  final int? height;

  /// Width of the pixel buffer on iOS.
  final int? width;

  Map<String, dynamic> _serialize() => <String, dynamic>{
    'bytesPerRow': bytesPerRow,
    'height': height,
    'width': width,
  };
}

extension InputImageFormatMethods on InputImageFormat {
  // source: https://developers.google.com/android/reference/com/google/mlkit/vision/common/InputImage#constants
  static Map<InputImageFormat, int> get _values => {
    InputImageFormat.NV21: 17,
    InputImageFormat.YV12: 842094169,
    InputImageFormat.YUV_420_888: 35,
    InputImageFormat.YUV420: 875704438,
    InputImageFormat.BGRA8888: 1111970369,
  };

  int get rawValue => _values[this] ?? 17;

  static InputImageFormat? fromRawValue(int rawValue) {
    return InputImageFormatMethods._values
        .map((k, v) => MapEntry(v, k))[rawValue];
  }
}


// The camera rotation angle to be specified
enum InputImageRotation {
  Rotation_0deg,
  Rotation_90deg,
  Rotation_180deg,
  Rotation_270deg
}

extension InputImageRotationMethods on InputImageRotation {
  static Map<InputImageRotation, int> get _values => {
    InputImageRotation.Rotation_0deg: 0,
    InputImageRotation.Rotation_90deg: 90,
    InputImageRotation.Rotation_180deg: 180,
    InputImageRotation.Rotation_270deg: 270,
  };

  int get rawValue => _values[this] ?? 0;

  static InputImageRotation? fromRawValue(int rawValue) {
    return InputImageRotationMethods._values
        .map((k, v) => MapEntry(v, k))[rawValue];
  }
}