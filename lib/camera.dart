import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mosaic_mind/textbox.dart';

class CameraApp extends StatefulWidget {
  final String documentID;
  final String ipAddress;

  CameraApp({Key? key, required this.documentID, required this.ipAddress})
      : super(key: key);

  File? image;

  Future<void> pickImageAndSave(
      BuildContext context, ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) {
        return;
      }

      final imageTemporary = File(image.path);
      this.image = imageTemporary;

      // Save image to gallery
      final bool? isSaved = await GallerySaver.saveImage(imageTemporary.path);
      if (isSaved == true) {
        print('Image saved to gallery');
      } else {
        print('Failed to save image to gallery');
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Textbox(
              imagePath: imageTemporary.path,
              docID: documentID,
              ipAdd: ipAddress),
        ),
      );
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF403948),
      appBar: AppBar(
        title: const Text('Image Upload'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    widget.pickImageAndSave(context, ImageSource.camera);
                  },
                  child: Column(
                    children: [
                      Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.white,
                          shape: CircleBorder(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.camera_alt_rounded,
                              size: 96, color: const Color(0xFF403948)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Pick Image from Camera',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.pickImageAndSave(context, ImageSource.gallery);
                  },
                  child: Column(
                    children: [
                      Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.white,
                          shape: CircleBorder(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.photo_library,
                              size: 96, color: const Color(0xFF403948)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Pick Image from Gallery',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.image != null) Image.file(widget.image!),
          ],
        ),
      ),
    );
  }
}
