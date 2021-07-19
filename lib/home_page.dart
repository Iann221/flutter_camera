import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  int imgnum = 0;

  getImageFile() async {

    //Clicking or Picking from Gallery
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    // var image = await ImagePicker().pickImage(source: source);
    File imagefile = File(image!.path); // kalau dari kamera bukan bentuk file
    imgnum++;
    final dir = await path_provider.getTemporaryDirectory();
    final targetpath = dir.absolute.path + '/' + imgnum.toString() + '.jpg';
    print('image:');
    print(imagefile);
    print(imagefile.lengthSync());
    print(targetpath);

    // Compress the image
    if (image != null){
      print(imagefile.path);
      print(targetpath);
      print('mengambil result');
      var result = await FlutterImageCompress.compressAndGetFile(
        imagefile.path,
        targetpath,
        quality: 50,
      );
      print(imagefile.lengthSync());
      print('result:');
      print(result);
      setState(() {
        _image = result;
      });
    } else {
      print('imagenya null');
    }

    // setState(() {
    //   _image = imagefile;
    // });

  }

  @override
  Widget build(BuildContext context) {
    print('size setelah build:');
    print(_image?.lengthSync());
    return Scaffold(
      appBar: AppBar(
        title: Text("Compress"),
      ),
      body: Center(
        child: Container(
          height: 350,
          width: 350,
          color: Colors.grey,
          child: (_image == null)
              ? Text("Image")
              : Image.file(
            _image!,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            label: Text("Camera"),
            onPressed: () => getImageFile(),
            heroTag: UniqueKey()
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton.extended(
            label: Text('Upload'),
            onPressed: () => print(_image),
            heroTag: UniqueKey(),
          )
        ],
      ),
    );
  }
}