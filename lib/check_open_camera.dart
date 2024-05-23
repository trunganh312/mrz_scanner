import 'package:flutter/material.dart';
import 'package:learn_flutter/widgets/mrz/mrzScanner.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckOpenCamera extends StatelessWidget {
  const CheckOpenCamera({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<PermissionStatus>(
        future: Permission.camera.request(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == PermissionStatus.granted) {
            return const CameraPage();
          }
          if (snapshot.data == PermissionStatus.permanentlyDenied) {
            openAppSettings();
          }
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Awaiting for permissions'),
                  ),
                  Text('Current status: ${snapshot.data?.toString()}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
