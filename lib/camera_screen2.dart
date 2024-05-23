import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen2 extends StatefulWidget {
  const CameraScreen2({super.key});

  @override
  _CameraScreen2State createState() => _CameraScreen2State();
}

class _CameraScreen2State extends State<CameraScreen2> {
  late CameraController _cameraController;
  late Future<void> _cameraInitializer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final selectedCamera = cameras.first;

    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
    );

    _cameraInitializer = _cameraController.initialize();

    setState(() {});

    _cameraController.startImageStream((CameraImage image) {
      // Process the camera frame here
      processCameraFrame(image);
    });
  }

  void processCameraFrame(CameraImage image) {
    // Perform frame processing operations here
    // Access the image data using image.planes[i].bytes
    // You can process the frame data or convert it to an image using external libraries

    // Example: Print the width and height of the frame
    print('Frame width: ${image.width}, height: ${image.height}');
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: _cameraController.value.aspectRatio,
      child: FutureBuilder<void>(
        future: _cameraInitializer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_cameraController);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
