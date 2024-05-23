import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          var key = result.keys.elementAt(index);
          var value = result[key];
          return ListTile(
            title: Text(key),
            subtitle: Text(value.toString()),
          );
        },
      ),
    );
  }
}
