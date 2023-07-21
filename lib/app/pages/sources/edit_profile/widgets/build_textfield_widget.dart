import 'package:flutter/material.dart';

class BuildTextFieldWidget extends StatelessWidget {
  const BuildTextFieldWidget(
      {super.key,
      required this.labelText,
      required this.placeHolder,
      required this.isReadOnly});

  final String labelText;
  final String placeHolder;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: TextField(
        readOnly: isReadOnly,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: labelText,
            labelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }
}
