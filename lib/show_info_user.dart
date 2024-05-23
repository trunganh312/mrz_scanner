// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowInfoUser extends StatefulWidget {
  const ShowInfoUser({
    super.key,
    required this.name,
    required this.cccd,
    required this.dateExp,
  });

  final String name;
  final String cccd;
  final String dateExp;

  @override
  State<ShowInfoUser> createState() => _ShowInfoUserState();
}

class _ShowInfoUserState extends State<ShowInfoUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("Infomation user"),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Name:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.name),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "CCCD:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.cccd,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Ngày hết hạn:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.dateExp.toString()),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: OutlinedButton(
                      onPressed: () {}, child: const Text("Quét NFC")),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
