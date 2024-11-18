import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:detect_edges/detect_edges.dart';
import 'package:edge_detect_app/cropping_preview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'camera_view.dart';
import 'image_view.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  CameraController? controller;
  late List<CameraDescription> cameras;
  String? imagePath;
  String? croppedImagePath;
  EdgeDetectionResult? edgeDetectionResult;

  @override
  void initState() {
    super.initState();
    checkForCameras().then((value) {
      _initializeController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        setState(() {
          imagePath = null;
          edgeDetectionResult = null;
          croppedImagePath = null;
        });
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: _getMainWidget(),
            ),
            _getBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _getMainWidget() {
    if (imagePath == null && edgeDetectionResult == null) {
      return RefreshIndicator.adaptive(
        onRefresh: () async {
          setState(() {
            imagePath = null;
            edgeDetectionResult = null;
            croppedImagePath = null;
          });
          _initializeController();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: CameraView(controller: controller),
        ),
      );
    }

    if (croppedImagePath != null) {
      File croppedImageFile = File(croppedImagePath!);
      return ImageView(imagePath: croppedImageFile.path);
    }

    if (imagePath != null) {
      File imageFile = File(imagePath!);
      return ImagePreview(
        imagePath: imageFile.path,
        edgeDetectionResult: edgeDetectionResult ??
            EdgeDetectionResult(
              bottomLeft: Offset.zero,
              bottomRight: Offset.zero,
              topLeft: Offset.zero,
              topRight: Offset.zero,
            ),
      );
    }
    return const Center(
      child: Text("Image processing error"),
    );
  }

  Future<void> checkForCameras() async {
    cameras = await availableCameras();
  }

  void _initializeController() {
    checkForCameras();
    if (cameras.isEmpty) {
      log('No cameras detected');
      return;
    }

    controller = CameraController(cameras[0], ResolutionPreset.veryHigh,
        enableAudio: false);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  Widget _getButtonRow() {
    if (croppedImagePath != null) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FloatingActionButton(
          child: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              imagePath = null;
              edgeDetectionResult = null;
              croppedImagePath = null;
            });
          },
        ),
        const SizedBox(width: 16),
        FloatingActionButton(
          child: const Icon(Icons.download),
          onPressed: () async {
            await moveImageToPermanentFolder(croppedImagePath!).then((d) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Image downloaded successfully"),
                ),
              );
            });
          },
        ),
      ]);
    }
    if (imagePath != null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () {
            _processImage(imagePath!, edgeDetectionResult!);
            setState(() {});
            // setState(() {
            //   imagePath = null;
            //   edgeDetectionResult = null;
            //   croppedImagePath = null;
            // });
          },
        ),
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      FloatingActionButton(
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
        onPressed: onTakePictureButtonPressed,
        child: const Icon(Icons.camera_alt),
      ),
      const SizedBox(width: 16),
      FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: _onGalleryButtonPressed,
        child: const Icon(Icons.image),
      ),
    ]);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String?> takePicture() async {
    if (!controller!.value.isInitialized) {
      log('Error: select a camera first.');
      return null;
    }

    if (controller!.value.isTakingPicture) {
      return null;
    }

    try {
      XFile pictureFile = await controller!.takePicture();
      return pictureFile.path;
    } on CameraException catch (e) {
      log(e.toString());
      return null;
    }
    // return filePath;
  }

  Future _detectEdges(String filePath) async {
    // if (!mounted) {
    //   return;
    // }
    setState(() {
      imagePath = filePath;
    });

    EdgeDetectionResult result = await EdgeDetector().detectEdges(filePath);

    setState(() {
      edgeDetectionResult = result;
    });
  }

  Future _processImage(
      String filePath, EdgeDetectionResult edgeDetectionResult) async {
    if (!mounted) {
      return;
    }

    double rotation = 0;
    bool result = await EdgeDetector()
        .processImage(filePath, edgeDetectionResult, rotation);

    if (result == false) {
      return;
    }

    setState(() {
      imageCache.clearLiveImages();
      imageCache.clear();
      croppedImagePath = imagePath;
    });
  }

  void onTakePictureButtonPressed() async {
    String? filePath = await takePicture();

    log('Picture saved to $filePath');

    await _detectEdges(filePath!);
  }

  void _onGalleryButtonPressed() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final filePath = pickedFile!.path;

    log('Picture saved to $filePath');

    await _detectEdges(filePath);
    // await _processImage(filePath, edgeDetectionResult)
  }

  Padding _getBottomBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: _getButtonRow(),
      ),
    );
  }

  Future<void> moveImageToPermanentFolder(String tempImagePath) async {
    try {
      // Get the target directory (e.g., Documents directory)
      Directory targetDirectory;

      // For Android, use the Downloads directory
      if (Platform.isAndroid) {
        targetDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        targetDirectory = await getApplicationDocumentsDirectory();
      } else {
        // Fallback in case of other platforms
        targetDirectory = await getTemporaryDirectory();
      }

      // Create the new file path
      final fileName = tempImagePath.split('/').last;
      final newFilePath = '${targetDirectory.path}/$fileName';

      // Move the file to the new directory
      final tempFile = File(tempImagePath);
      final newFile = await tempFile.copy(newFilePath);

      print('Image moved to: ${newFile.path}');
    } catch (e) {
      print('Error moving image file: $e');
    }
  }
}
