# Flutter Detect Edges

This is a Flutter Plugin to detect egdes of a document in an image using OpenCV

## Introduction

This project is an implementation of OpenCV's edge detection library in Flutter for image/document scanning and processing to detect edges.

## Plugin Limitations

This plugin uses large files/folders for processing the images. These files/folders are too large to be uploaded to Github, hence, we have to device other ways to get them to work for us.
We can either download the OpenCV v4.4.0 Android and iOS releases [here](https://opencv.org/releases/page/3/), then unzip both zipped files, then pick the necessary files/folders from them.
Or rather, we can download the two necessary folders from the drive [here](https://drive.google.com/drive/folders/1nQ5KGLwg0fEN-LJu37CwdrLv6p2MVymh?usp=sharing) and then follow the instructions that follows for Android and iOS.

**For Android**
- cd/ go to the Plugin i.e detect_edges -> android -> src -> main
- then copy the whole folder, jniLibs, into the main folder

**For iOS**
- cd/ go to the Plugin i.e detect_edges -> ios
- then copy the whole folder, opencv2.framework, into the ios folder

When this is done, we're good to go
### Setup Instructions

- run `git clone https://github.com/IdrisAdeyemi01/docu_edges.git` in your terminal
- navigate to the directory containing the cloned project (detect_edges)
- open in any code editor of your choice e.g Android studio, VSCode etc
- Complete setup as mentioned in the Plugin Limitation section
- connect your Android device
- cd into the example folder
- run `flutter run` to test in your connected device

Built with ❤️ in Flutter. Powered by OpenCV through Dart FFI.
