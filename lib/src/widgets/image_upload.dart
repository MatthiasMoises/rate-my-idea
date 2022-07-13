import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../models/idea.dart';
import '../providers/ideas.dart';

class ImageUpload extends StatefulWidget {
  final Idea? idea;

  ImageUpload({this.idea, Key? key}) : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final ImagePicker _picker = new ImagePicker();
  XFile? _image;

  void _getImageFromCamera(BuildContext context) async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    setState(() {
      _image = image;
    });

    if (_image != null) {
      Provider.of<Ideas>(context, listen: false).setUploadedImageInformation(
        File(_image!.path),
        _image!.name,
      );
    }
  }

  void _getImageFromGallery(BuildContext context) async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(() {
      _image = image;
    });

    if (_image != null) {
      Provider.of<Ideas>(context, listen: false).setUploadedImageInformation(
        File(_image!.path),
        _image!.name,
      );
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _getImageFromGallery(context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getImageFromCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _showPlaceholder(String? imageUrl) {
    if (imageUrl == '' || imageUrl == null) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(50)),
        width: 100,
        height: 100,
        child: Icon(
          Icons.camera_alt,
          color: Colors.grey[800],
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          '$publicBucketUrl/$imageUrl',
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: CircleAvatar(
          radius: 55,
          backgroundColor: Color(0xffFDCF09),
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    File(_image!.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                )
              : _showPlaceholder(widget.idea?.imageName),
        ),
      ),
    );
  }
}
