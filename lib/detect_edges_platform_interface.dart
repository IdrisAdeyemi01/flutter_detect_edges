import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'detect_edges_method_channel.dart';

abstract class DetectEdgesPlatform extends PlatformInterface {
  /// Constructs a DetectEdgesPlatform.
  DetectEdgesPlatform() : super(token: _token);

  static final Object _token = Object();

  static DetectEdgesPlatform _instance = MethodChannelDetectEdges();

  /// The default instance of [DetectEdgesPlatform] to use.
  ///
  /// Defaults to [MethodChannelDetectEdges].
  static DetectEdgesPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DetectEdgesPlatform] when
  /// they register themselves.
  static set instance(DetectEdgesPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
