import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/preview_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController
      _cameraController; //Đối tượng này được sử dụng để kiểm soát camera. Nó được khởi tạo trong phương thức initState().
  late List<CameraDescription>
      _cameras; // Danh sách các camera có sẵn trên thiết bị. Thông tin về các camera này sẽ được lấy trong phương thức initState()
  late int
      selectedCameraIndex; // Chỉ số của camera được chọn từ danh sách _cameras
  late String
      imgPath; // Đường dẫn tới ảnh chụp từ camera. Đây là một biến để lưu trữ ảnh sau khi chụp.

  Future _initCameraController(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    _cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (_cameraController.value.hasError) {
        print('Camera error ${_cameraController.value.errorDescription}');
      }
    });

    try {
      await _cameraController.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  // Display camera preview
  Widget _cameraPreview() {
    if (!_cameraController.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return AspectRatio(
      aspectRatio: _cameraController.value.aspectRatio,
      child: CameraPreview(_cameraController),
    );
  }

  // Display button control bar to take pictures
  Widget _cameraControllerButton(context) {
    return Expanded(
        child: Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          FloatingActionButton(
            onPressed: () {
              _onCapturePressed(context);
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.camera,
              color: Colors.black,
            ),
          )
        ],
      ),
    ));
  }

  // Display button control bar to switch camera
  Widget _cameraSwitchButton() {
    if (_cameras.isEmpty) {
      return const Spacer();
    }
    CameraDescription selectedCamera = _cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;
    return Expanded(
        child: Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          FloatingActionButton(
            onPressed: () {
              _onCameraSwitchPressed();
            },
            backgroundColor: Colors.white,
            child: Icon(
              _getCameraLensIcon(lensDirection),
              color: Colors.black,
            ),
          )
        ],
      ),
    ));
  }

  @override
  void initState() {
    availableCameras().then((value) {
      _cameras = value;
      if (_cameras.isNotEmpty) {
        setState(() {
          selectedCameraIndex = 0;
        });
        _initCameraController(_cameras[0]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((error) {
      print(error.code);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _cameraPreview(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // _cameraSwitchButton(),
                      _cameraControllerButton(context),
                      const Spacer()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showCameraException(e) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(
        content: Text(e.description ?? "Unknown error"),
      ),
    );
  }

  void _onCapturePressed(context) async {
    try {
      final path =
          join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
      XFile picture = await _cameraController.takePicture();
      await picture.saveTo(path);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PreviewScreen(
                  imgPath: path,
                )),
      );
    } catch (e) {
      _showCameraException(e);
    }
  }

  void _onCameraSwitchPressed() {
    selectedCameraIndex =
        selectedCameraIndex < _cameras.length - 1 ? selectedCameraIndex : 0;
    CameraDescription selectedCamera = _cameras[selectedCameraIndex];
    _initCameraController(selectedCamera);
  }

  IconData? _getCameraLensIcon(CameraLensDirection lensDirection) {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return Icons.switch_camera;
      case CameraLensDirection.front:
        return Icons.switch_camera_outlined;
      case CameraLensDirection.external:
        return Icons.photo_camera;
      default:
        return Icons.device_unknown;
    }
  }
}
