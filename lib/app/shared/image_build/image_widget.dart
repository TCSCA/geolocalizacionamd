import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  Uint8List? imagePath;
  final VoidCallback onClicked;
  final bool isEdit;
  final Color color;

  ImageWidget(
      {super.key,
      this.imagePath,
      required this.onClicked,
      this.isEdit = false,
      required this.color});

  final List _bytesImageEmpty = [];

  @override
  Widget build(BuildContext context) {
    imagePath = imagePath ?? Uint8List.fromList(_bytesImageEmpty.cast<int>());

    return Center(
      child: Stack(
        children: [
          _ImageBuildWidget(
            context: context,
            isEdit: isEdit,
            imagePath: imagePath,
          ),
          if (isEdit)
            Positioned(
                bottom: 10,
                right: 10,
                child: _IconEditorWidget(
                  color: color,
                  isEdit: isEdit,
                  onClicked: onClicked,
                ))
        ],
      ),
    );
  }
}

class _ImageBuildWidget extends StatelessWidget {
  final BuildContext context;
  final Uint8List? imagePath;
  final bool isEdit;

  const _ImageBuildWidget(
      {super.key, required this.context, this.imagePath, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: imagePath!.isEmpty
            ? Image.asset(
                'assets/images/profile_default.png',
                fit: BoxFit.cover,
                width: isEdit
                    ? 180
                    : 170,
                height: isEdit
                    ? 180
                    : 170,
              )
            : Image.memory(
                imagePath!,
                fit: BoxFit.cover,
                width: isEdit ? 150 : 130,
                height: isEdit ? 150 : 130,
              ),
      ),
    );
  }
}

class _IconEditorWidget extends StatelessWidget {
  const _IconEditorWidget(
      {super.key,
      required this.color,
      required this.isEdit,
      required this.onClicked});

  final Color color;
  final bool isEdit;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return _CircleEdit(
      color: Colors.white,
      paddingAll: 3.0,
      child: InkWell(
        onTap: onClicked,
        child: isEdit
            ? _CircleEdit(
                paddingAll: 8,
                color: color,
                child: Icon(
                  Icons.add_a_photo,
                  size: MediaQuery.of(context).size.width < 321 ? 8 : 20,
                  color: Colors.white,
                ),
              )
            : Container(),
      ),
    );
  }
}

class _CircleEdit extends StatelessWidget {
  const _CircleEdit(
      {super.key,
      required this.child,
      required this.color,
      required this.paddingAll});

  final Widget child;
  final double paddingAll;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(paddingAll),
        color: color,
        child: child,
      ),
    );
  }
}
