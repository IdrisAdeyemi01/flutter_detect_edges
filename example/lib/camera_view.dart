import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatelessWidget {
  const CameraView({
    super.key,
    this.controller,
  });

  final CameraController? controller;

  @override
  Widget build(BuildContext context) {
    return _getCameraPreview();
  }

  Widget _getCameraPreview() {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    return Center(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(30, 40, 30, 50),
      child: CameraPreview(controller!),
    ));
  }
}
