import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:video_player/video_player.dart';

class CamaraView extends StatefulWidget {
  @override
  _CamaraViewState createState() => _CamaraViewState();
}

class _CamaraViewState extends State<CamaraView> {
  File _image;
  File _imageFile;
  File _videoFile;
  File _videoFileCamera;
  double textSize = 20;
  String firstButtonText = 'Tomar Foto';
  String secondButtonText = 'Grabar video';
  VideoPlayerController _controller;

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

  void _pickVideo() async {
    var video = await ImagePicker().getVideo(source: ImageSource.gallery);
    _videoFile = File(video.path);
    _controller = VideoPlayerController.file(_videoFile)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
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
                    child: Text('Escoger una foto'),
                    color: Colors.black26,
                  ),
                ),
                Align(
                  child: MaterialButton(
                    onPressed: (_pickVideo),
                    child: Text('Escoger un Video'),
                    color: Colors.orange,
                  ),
                ),
                if (_videoFile != null)
                  _controller.value.initialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container()
                else
                  Text("Escoge un Video"),
                Align(
                  child: MaterialButton(
                    onPressed: (_takePhoto),
                    child: Text(firstButtonText),
                    color: Colors.blue,
                  ),
                ),
                Align(
                  child: MaterialButton(
                    onPressed: (_recordVideo),
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
    var picture = await ImagePicker().getImage(source: ImageSource.camera);
    if (picture != null && picture.path != null) {
      GallerySaver.saveImage(picture.path);
    }
    setState(() {
      _imageFile = File(picture.path);
    });
  }

  void _recordVideo() async {
    var video = await ImagePicker().getVideo(source: ImageSource.camera);
    if (video != null && video.path != null) {
      GallerySaver.saveVideo(video.path);
    }
    setState(() {
      _videoFileCamera = File(video.path);
    });
  }
}
