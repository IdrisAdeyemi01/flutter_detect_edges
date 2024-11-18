// import 'package:flutter_test/flutter_test.dart';
// import 'package:detect_edges/detect_edges.dart';
// import 'package:detect_edges/detect_edges_platform_interface.dart';
// import 'package:detect_edges/detect_edges_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockDetectEdgesPlatform
//     with MockPlatformInterfaceMixin
//     implements DetectEdgesPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final DetectEdgesPlatform initialPlatform = DetectEdgesPlatform.instance;

//   test('$MethodChannelDetectEdges is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelDetectEdges>());
//   });

//   test('getPlatformVersion', () async {
//     DetectEdges detectEdgesPlugin = DetectEdges();
//     MockDetectEdgesPlatform fakePlatform = MockDetectEdgesPlatform();
//     DetectEdgesPlatform.instance = fakePlatform;

//     expect(await detectEdgesPlugin.getPlatformVersion(), '42');
//   });
// }
