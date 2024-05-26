
import 'package:flutter/material.dart';



// MY PAGES
//import 'package:faturami_tara/form.dart';
import 'package:faturami_tara/anasayfa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Faturamı Tara'),
      home:const AnaMainPage(title: 'Faturamı Tara',),
    );
  }
}






/*

Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(image!.path)),
                  fit: BoxFit.cover,
                ),
              ),
            ),





*/

  //XFile? image;
  //final List<XFile> imageList = [];
//int _counter = 0;

  /*void _incrementCounter() {
    setState(() {
      _counter = _counter + 1;
    });
  }*/
  /*
  Future<void> _incrementCounter() async {
    //final picker = ImagePicker();
    image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        image = XFile(image!.path);
        imageList.add(image!);
      });
    }
  }
  */
  /*void _chooseFromGallery() async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    List<CellValue> row1 = [];
    //List<CellValue> satirlar = [];

    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //List<String> kelimeler = ['Fatura Başlık'];

    // setState(() {
    //   imageList.addAll(images);
    // });
    
    try {
      final girisFoto = InputImage.fromFilePath(image!.path);
      final yaziReco = GoogleMlKit.vision
          .textRecognizer(script: TextRecognitionScript.latin);
      final islenenMetin = await yaziReco.processImage(girisFoto);
      //String metin = islenenMetin.text;
      List<TextBlock> faturaBlolklari = islenenMetin.blocks;
      List<String> hucreler = [];
      //String hucre;
      for (var i = 0; i < faturaBlolklari.length; i++) {
        hucreler.addAll(faturaBlolklari[i].text.split(' '));
      }
      if (kDebugMode) {
        print(hucreler);
      }
      String text = '';
      //Entity için string başla
      for (var i = 0; i < hucreler.length; i++) {
        text = '$text${hucreler[i]} ';
      }
      //Entity için string bitiş
      //ENTİTY START
      final varlikCikarma =
          EntityExtractor(language: EntityExtractorLanguage.turkish);
      final List<EntityAnnotation> annotations =
          await varlikCikarma.annotateText(text);
      int i = 0;
      for (final annotation in annotations) {
        annotation.start;
        annotation.end;
        annotation.text;
        for (final entity in annotation.entities) {
          entity.type;
          if (kDebugMode) {
            print('anana girsin başladı');
            print(entity.type);
            print('------');
            print(annotations[i].text);
            print('anana birşin bitti');
          }
          i++;
          entity.rawValue;
        }
      }

      //ENTİTY END

      //kelimeler = metin.split(' ');
      //row1.add(TextCellValue(metin));
      for (var i = 0; i < hucreler.length; i++) {
        // if (kDebugMode) {
        //   print(' Blok $i == ${faturaBlolklari[i].text}');
        // }
        row1.add(TextCellValue(hucreler[i]));
        sheet.appendRow(row1);
        row1.clear();
      }
      // for (var i = 0; i < faturaBlolklari.length; i++) {
      //   satirlar.add(TextCellValue(faturaBlolklari[i].text));
      // }
      sheet.appendRow(row1);

      // if (kDebugMode) {
      //   print('haydiiii haydiii ==============$metin');
      //   if (kDebugMode) {
      //     print(metin.length.toString());
      //     print(kelimeler.length);
      //     print(kelimeler);
      //   }
      //   // for (var i = 0; i < kelimeler.length; i++) {
      //   //   print(kelimeler);
      //   // }
      // }
      Directory? appDocDir = await getDownloadsDirectory();
      var path = appDocDir!.path;
      //String appDocPath = '/storage/emulated/0/Download/blockExcelv002.xlsx';
      String appDocPath = '$path/bimFis004.xlsx';
      // if (kDebugMode) {
      //   print(appDocPath);
      // }
      List<int>? fileBytes = excel.save();
      //print('saving executed in ${stopwatch.elapsed}');
      if (fileBytes != null) {
        File(join(appDocPath))
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }
    } catch (e) {
      if (kDebugMode) {
        print('ananın amina girisin ========$e');
      }
    }
  }*/

        /*floatingActionButton: Row(
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
              onPressed: () => {},
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
      ),*/