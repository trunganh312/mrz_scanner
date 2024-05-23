import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:learn_flutter/widgets/ocr/result_ocr.dart';

class CaptureImageScreen extends StatefulWidget {
  const CaptureImageScreen({super.key});

  @override
  _CaptureImageScreenState createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {
  List<File> images = [];
  bool showSpinner = false;

  final ImagePicker _picker = ImagePicker();
  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });

      if (images.length == 2) {
        _uploadImages();
      }
    }
  }

  Future<void> _chooseImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });

      if (images.length == 2) {
        _uploadImages();
      }
    }
  }

  Future<void> _uploadImages() async {
    setState(() {
      showSpinner = true;
    });
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.vmgtech.vn/ekyc/api/verify-ocrid'),
      );

      request.headers.addAll({
        "code": "VMGMEDIADEMO",
        'Content-Type': 'multipart/form-data',
        "os-type": "mobile",
        "x-api-key": "lU6mjAZIVY447Ah0Vt7wFTuIB4M834fE"
      });

      request.files
          .add(await http.MultipartFile.fromPath('img1', images[0].path));
      request.files
          .add(await http.MultipartFile.fromPath('img2', images[1].path));

      var response = await request.send();

      if (response.statusCode == 200) {
        String result = await response.stream.bytesToString();
        var jsonResponse = json.decode(result);
        var data = jsonResponse['data'];
        if (data) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultPage(
                      result: data,
                    )),
          );
        }
      } else {
        // Handle error response
        print('Upload failed');
      }
    } catch (e) {
      print('Error uploading images: $e');
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Images'),
      ),
      body: Center(
        child: showSpinner
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _chooseImage,
                    child: const Text('Choose Image'),
                  ),
                  ElevatedButton(
                    onPressed: _captureImage,
                    child: const Text('Capture Image'),
                  ),
                  if (images.isNotEmpty)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 150, // Điều chỉnh kích thước ảnh
                              child:
                                  Image.file(images[index], fit: BoxFit.cover),
                            );
                          },
                          itemCount: images.length,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
