import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/camera_screen.dart';
import 'package:learn_flutter/camera_screen2.dart';
import 'package:learn_flutter/check_open_camera.dart';
import 'package:learn_flutter/detail_page.dart';
import 'package:learn_flutter/widgets/ocr/ocr_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('VMG TECH'),
          ),
          backgroundColor: Colors.grey.shade600,
          foregroundColor: Colors.white,
          titleTextStyle:
              const TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
        ),
        body: Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                ButonControl(
                    icon: Icons.qr_code_2,
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CaptureImageScreen(),
                        ),
                      );
                    },
                    text: "Quét OCR"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButonControl(
                      icon: Icons.account_balance_wallet_outlined,
                      text: "CCCD",
                      function: () {
                        Navigator.of(context).push(
                          _createRoute(
                            img: "assets/images/cccd.png",
                            title: "Xác thực CCCD gắn chip",
                            desc:
                                "Xác minh thông tin thật giả của CCCD gắn chip, thích hợp với dịch vụ xác thực của C06.",
                            function: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CheckOpenCamera(),
                                ),
                              );
                            },
                            intruct:
                                "Bước 1: Xác minh toàn vẹn dữ liệu CA/PA/AA.\nBước 2: Xác thực với C06.\nBước 3: Hiển thị thông tin chủ thẻ.",
                          ),
                        );
                      },
                    ),
                    ButonControl(
                      icon: Icons.account_box_outlined,
                      text: "EKYC",
                      function: () {
                        Navigator.of(context).push(
                          _createRoute(
                            img: "assets/images/ekyc.png",
                            title: "Xác thực eKYC",
                            desc:
                                "Xác minh thông tin thật giả của CCCD gắn chip, eKYC và thích hợp với dịch vụ xác thực của C06.",
                            function: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CameraScreen2(),
                                ),
                              );
                            },
                            intruct:
                                "Bước 1: Xác minh toàn vẹn dữ liệu CA/PA/AA.\nBước 2: Xác minh thực thể sống.\nBước 3: Xác thực với C06.\nBước 4: Hiển thị thông tin chủ thẻ và khuôn mặt.",
                          ),
                        );
                      },
                    ),
                    ButonControl(
                      icon: Icons.add_card_rounded,
                      text: "2345",
                      function: () {
                        Navigator.of(context).push(
                          _createRoute(
                            img: "assets/images/2345.png",
                            title: "Xác thực eKYC",
                            desc:
                                "Xác minh thông tin thật giả của CCCD gắn chip, eKYC và thích hợp với dịch vụ xác thực của C06.",
                            function: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CameraScreen(),
                                ),
                              );
                            },
                            intruct:
                                "Bước 1: Xác minh toàn vẹn dữ liệu CA/PA/AA.\nBước 2: Xác minh thực thể sống.\nBước 3: Xác thực với C06.\nBước 4: Hiển thị thông tin chủ thẻ và khuôn mặt.",
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            )));
  }
}

Route _createRoute({
  required String img,
  required String title,
  required String desc,
  required void Function()? function,
  required String intruct,
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DetailPage(
      desc: desc,
      img: img,
      title: title,
      intruct: intruct,
      function: function,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class ButonControl extends StatefulWidget {
  const ButonControl({
    super.key,
    required this.icon,
    this.colorBg,
    this.colorTxt,
    this.colorIcon,
    required this.function,
    required this.text,
  });

  final IconData icon;
  final Color? colorBg;
  final Color? colorTxt;
  final Color? colorIcon;
  final void Function()? function;
  final String text;

  @override
  State<ButonControl> createState() => _ButonControlState();
}

class _ButonControlState extends State<ButonControl> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.only(top: 20, bottom: 20, right: 30, left: 30),
      color: widget.colorBg ?? Colors.white,
      onPressed: widget.function,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.icon,
            color: widget.colorBg ?? Colors.amber,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(widget.text,
              style: TextStyle(
                color: widget.colorTxt ?? Colors.black,
              )),
        ],
      ),
    );
  }
}
