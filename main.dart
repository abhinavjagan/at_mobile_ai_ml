
import 'dart:io';
import 'dart:math';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
      final options = FaceDetectorOptions();
      final faceDetector = FaceDetector(options: options);
      for (var name in imageFileList!) {
        Directory directory = await getApplicationDocumentsDirectory();
        String path = directory.path;
        File tmpFile = File(name.path);
        final String fileName = basename(name.path);
        File newImage = await tmpFile.copy('$path/$fileName');
        final List<Face> faces = await faceDetector.processImage(InputImage.fromFilePath(name.path));
        print(faces.length);
        print(newImage.path);
        for (var i=0; i<faces.length ;i++){
          Face f=faces[i];
          print(f.boundingBox);

        }

      }
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cont@cts"),
        ),
        body: Center(
          child: Column(
            children: [
              RaisedButton(
                onPressed: () {
                  selectImages();
                },
                color: Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text("Pick images from gallery"),
              ),
              SizedBox(height: 20,),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      
                        itemCount: imageFileList!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Image.file(File(imageFileList![index].path), fit: BoxFit.cover);
                        }
                    ),
                  )
              )
            ],
          ),
        )
    );
  }
}