import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


String varlikBulunacakMetin =" ";
String faturaAdress="";
String faturaTarih="";
int faturaVKN=0;
double faturaKDV=0;
double faturaToplamTutar=0;
List<String> tutarlar=[];

// metin işleme başla
void metinIsleme(String path, BuildContext context) async{
  try {
    final inputFoto = InputImage.fromFilePath(path);
    final recoYazi = GoogleMlKit.vision.textRecognizer(script: TextRecognitionScript.latin);
    final processedMetin = await recoYazi.processImage(inputFoto);
    List<TextBlock> blocksMetin = processedMetin.blocks;
    List<String> blokParcalari;
    recoYazi.close();
    if (kDebugMode) {
      for (var i = 0; i < blocksMetin.length; i++) {
        //print(blocksMetin[i].text);
        //print('----------');
        varlikBulunacakMetin+="${blocksMetin[i].text} ";
      }
    }
    blokParcalari = varlikBulunacakMetin.split("\n");
    varlikBulunacakMetin=" ";
    for (var i = 0; i < blokParcalari.length; i++) {
      varlikBulunacakMetin+="${blokParcalari[i]} ";
    }
    if (kDebugMode) {
      print("Metnin düzenlenmiş hali ==> $varlikBulunacakMetin");
    }
    varlikBulunacakMetin = varlikBulunacakMetin.replaceAll('*', '₺');
    varlikBulunacakMetin = varlikBulunacakMetin.replaceAll('.', '/');
    varlikBulunacakMetin = varlikBulunacakMetin.toLowerCase();
    //kdvBul(varlikBulunacakMetin);
    // ignore: use_build_context_synchronously
    varlikBulma(varlikBulunacakMetin,context);
    varlikBulunacakMetin = "";
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
// metin işleme bitti
// adres, tarih saat ve vergi numarası bulma başladı
void varlikBulma(String metin,BuildContext context) async{
  final varlikCik = EntityExtractor(language: EntityExtractorLanguage.turkish);
  final List<EntityAnnotation> annotation= await varlikCik.annotateText(metin);
  varlikCik.close();
  for (final annot in annotation) {
    annot.start;
    annot.end;
    annot.text;
    for (final entity in annot.entities) {
      if (kDebugMode) {
            print("Tip : ${entity.type} Metin : ${annot.text}");
          }
      switch (entity.type) {
              case EntityType.address:
                if(faturaAdress.isEmpty){
                  faturaAdress=annot.text;
                }                
              case EntityType.phone:
                if(faturaVKN==0 && annot.text.length==10){
                  faturaVKN=int.parse(annot.text);
                }
              case EntityType.money:
                tutarlar.add(annot.text);
              case EntityType.dateTime:
                if(faturaTarih.isEmpty && annot.text.length>=10){
                  faturaTarih=annot.text;
                }
                break;
              default:
            }
        
    } 
    //annotation.clear();
  }
  annotation.clear();
  int uzunluk = tutarlar.length;
  if (double.parse(tutarlar[(uzunluk-1)].replaceAll('₺', '0').replaceAll(',', '.'))==double.parse(tutarlar[(uzunluk-2)].replaceAll('₺', '0').replaceAll(',', '.'))) {
    tutarlar.removeLast();
    uzunluk = uzunluk-1;
  }
  faturaKDV = double.parse(tutarlar[uzunluk-2].replaceAll('₺', '0').replaceAll(',', '.'));
  faturaToplamTutar=double.parse(tutarlar[uzunluk-1].replaceAll('₺', '0').replaceAll(',', '.'));

  //forma veri gönderme başladı
  // navigator push yapıcan
  // youtube linki 
  // https://www.youtube.com/watch?v=_si3U8XoKBI
  //forma veri gönderme bitti

  excelIslemleri(faturaAdress, faturaVKN, faturaTarih, faturaKDV, faturaToplamTutar);
  // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("adres => $faturaAdress vkn => $faturaVKN tarih => $faturaTarih kdv => $faturaKDV toplam fiyat => $faturaToplamTutar")));

  faturaAdress = "";
  faturaVKN = 0;
  faturaTarih ="";
  faturaKDV=0;
  faturaToplamTutar=0;
  annotation.clear();
}
// adres, tarih, saat ve vergi numarası bitti
// excel işlemleri başladı
void excelIslemleri(String fAdres,int fVkn, String fTarih, double fKDV, double fTutar) async{
  final Excel excel;
  //List<CellValue> firstRow = const [TextCellValue("Adres"),TextCellValue("VKN"),TextCellValue("Tarih"),TextCellValue("Toplam KDV"),TextCellValue("Toplam Tutar")];
  List<String> tarih=fTarih.split(' ')[0].split('/');
  int yil = int.parse(tarih[2]);
  int ay =int.parse(tarih[1]);
  int gun = int.parse(tarih[0]);
  List<CellValue> fatura =[TextCellValue(fAdres),IntCellValue(fVkn),DateCellValue(year: yil, month: ay, day: gun),DoubleCellValue(fKDV),DoubleCellValue(fTutar)];
  //sheet.appendRow(firstRow);
  

  Directory? extDoc = await getDownloadsDirectory();
  //Directory? appDocDir = await getDownloadsDirectory();
  var path = extDoc?.path;
  String appDocPath = '$path/faturalarim3.xlsx';
  if (kDebugMode) {
    print("burdayımmmm = ============ $appDocPath");
  }
  if (File(appDocPath).existsSync()==true) {
    var bytes = File(appDocPath).readAsBytesSync();
    excel = Excel.decodeBytes(bytes);
    var sheetOkunan = excel["Sheet1"];
    sheetOkunan.appendRow(fatura);
  } else {
    excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    sheet.appendRow(fatura);
  }
  List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
        File(join(appDocPath))
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
        if (kDebugMode) {
          print("kaydedildi");
        }
    } 
}
// excel işlemleri bitti
// foto seçme ya da çekme başladı
// ignore: must_be_immutable
class FotoSecCek extends StatelessWidget {
  XFile? fotograf;
  FotoSecCek({super.key});
  void fotoYukle(int secim, BuildContext context) async{
    if (secim==0) {
      fotograf = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (kDebugMode) {
        print("calisti foto seçildi");
      }
    }else{
      fotograf = await ImagePicker().pickImage(source: ImageSource.camera);
    }
    if (fotograf!=null)  {
      if (kDebugMode) {
        print("calisti");
      }
      // ignore: use_build_context_synchronously
      metinIsleme(fotograf!.path,context);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Deneme")));
      //varlikBulma();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          TextButton(onPressed: () {
            fotoYukle(0, context);
          }, child: const Text('Galeriden Seç')),
          TextButton(onPressed: () {
            fotoYukle(1, context);
          }, child: const Text('Fotoğraf Çek'))
        ],
      ),
    );
  }
}
// foto seçme ya da çekme bitti
// fotoda ki metinleri düzenleme başladı
// fotoda ki metinleri düzenleme bitti