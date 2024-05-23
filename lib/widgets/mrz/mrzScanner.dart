import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mrz_scanner/flutter_mrz_scanner.dart';
// import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:learn_flutter/show_info_user.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool isParsed = false;
  MRZController? controller;
  bool flashEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          MRZScanner(
            withOverlay: true,
            onControllerCreated: onControllerCreated,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      // Hành động khi nhấn nút flash
                      setState(() {
                        flashEnabled = !flashEnabled;
                        if (flashEnabled) {
                          controller?.flashlightOn();
                        } else {
                          controller?.flashlightOff();
                        }
                      });
                    },
                    child:
                        Icon(flashEnabled ? Icons.flash_on : Icons.flash_off),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    onPressed: () {
                      // processImageSelection1();
                    },
                    child: const Icon(Icons.image),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<File?> pickImageFromGallery1() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      print(pickedImage.path);
      return File(pickedImage.path);
    }
    return null;
  }

  Future<String> readMrzFromImage1(File imageFile) async {
    // final ocrResult = await FlutterTesseractOcr.extractText(imageFile.path);
    const ocrResult = "";
    // Xử lý kết quả OCR để lấy mã MRZ
    final lines = ocrResult.split('\n'); // Tách chuỗi thành các dòng

    String mrzCode = '';

    // Tìm và trích xuất dòng chứa thông tin MRZ
    for (final line in lines) {
      if (line.contains('P<')) {
        final startIndex = line.indexOf('P<') + 2;
        final endIndex = line.indexOf('<<');
        if (startIndex >= 0 && endIndex >= 0 && endIndex > startIndex) {
          mrzCode = line.substring(startIndex, endIndex);
          break;
        }
      }
    }

    return mrzCode;
  }

  void processImageSelection1() async {
    controller?.stopPreview();
    final imageFile = await pickImageFromGallery1();
    if (imageFile != null) {
      final mrzCode = await readMrzFromImage1(imageFile);
      // Chuyển sang màn hình ShowInfoUser
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowInfoUser(
            name: mrzCode,
            dateExp: "01/01/2020",
            cccd: "123456789",
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.stopPreview();
    super.dispose();
  }

  void onControllerCreated(MRZController controller) {
    this.controller = controller;
    controller.onParsed = (result) async {
      if (isParsed) {
        return;
      }
      isParsed = true;

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ShowInfoUser(
            name: "${result.surnames} ${result.givenNames}",
            dateExp: DateFormat('dd/MM/yyyy').format(result.expiryDate),
            cccd: result.personalNumber,
          ),
        ),
      ).then((value) {
        controller.stopPreview();
      });
    };
    controller.onError = (error) => debugPrint(error);

    controller.startPreview();
  }
}
