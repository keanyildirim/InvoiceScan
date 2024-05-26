import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class FotoSecCekDugmeleri extends StatelessWidget {
  XFile? image;
  List<XFile> imageList = [];

  Future<void> _incrementCounter() async {
    //final picker = ImagePicker();
    image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      image = XFile(image!.path);
      imageList.add(image!);
    }
  }

  Future<void> _chooseFromGallery() async {
    final List<XFile> images = await ImagePicker().pickMultiImage();
    imageList.addAll(images);
  }

  FotoSecCekDugmeleri({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /*const SizedBox(
            height: 1,
            width: 1,
          ),*/
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: FloatingActionButton.extended(
            onPressed: _chooseFromGallery,
            //icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Icon(Icons.add_photo_alternate_outlined),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        //const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add_a_photo_outlined),
        ),
      ],
    );
  }
}
