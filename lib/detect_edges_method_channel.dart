import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'detect_edges_platform_interface.dart';

/// An implementation of [DetectEdgesPlatform] that uses method channels.
class MethodChannelDetectEdges extends DetectEdgesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('detect_edges');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
