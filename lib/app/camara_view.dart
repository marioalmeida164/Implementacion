import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class CamaraView extends StatefulWidget {
  @override
  _CamaraViewState createState() => _CamaraViewState();
}

class _CamaraViewState extends State<CamaraView> {
  File _image;
  double textSize = 20;
  String firstButtonText = 'Take photo';
  String secondButtonText = 'Record video';

  Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camara y Galeria'),
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  child: MaterialButton(
                    onPressed: () {
                      getImage(ImgSource.Gallery);
                    },
                    child: Text('Abrir Galeria'),
                    color: Colors.black26,
                  ),
                ),
                Align(
                  child: MaterialButton(
                    onPressed: _takePhoto,
                    child: Text(firstButtonText),
                    color: Colors.blue,
                  ),
                ),
                Align(
                  child: MaterialButton(
                    onPressed: _recordVideo,
                    child: Text(secondButtonText),
                    color: Colors.green,
                  ),
                ),
                _image == null
                    ? Container()
                    : Container(
                        child: Image.file(_image),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _takePhoto() async {
    ImagePicker.pickImage(source: ImageSource.camera)
        .then((File recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        setState(() {
          firstButtonText = 'saving in progress...';
        });
        GallerySaver.saveImage(recordedImage.path).then((bool success) {
          setState(() {
            firstButtonText = 'image saved!';
          });
        });
      }
    });
  }

  void _recordVideo() async {
    try {
      ImagePicker.pickVideo(source: ImageSource.camera)
          .then((File recordedVideo) {
        if (recordedVideo != null && recordedVideo.path != null) {
          setState(() {
            secondButtonText = 'saving in progress...';
          });
          GallerySaver.saveVideo(recordedVideo.path).then((bool success) {
            setState(() {
              secondButtonText = 'video saved!';
            });
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
