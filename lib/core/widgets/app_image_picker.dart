import 'dart:io';

import 'package:flutter/material.dart';

class AppImagePicker extends StatelessWidget {
  const AppImagePicker({
    super.key,
    this.image,
    required this.onTap,
  });

  final File? image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(16),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: image == null
            ? const Center(
          child: Icon(
            Icons.add_a_photo,
            size: 40,
          ),
        )
            : ClipRRect(
          borderRadius:
          BorderRadius.circular(16),
          child: Image.file(
            image!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}