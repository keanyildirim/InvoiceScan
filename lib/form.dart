import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormWidget extends StatefulWidget {
  FormWidget({super.key, required this.toplaTutarForm, required this.adresForm, required this.tarihForm, required this.kdvForm, required this.vkn});

  String adresForm;
  String tarihForm;
  int vkn;
  double kdvForm;
  double toplaTutarForm;
  

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

var items =const <DropdownMenuItem<String>>[
                  DropdownMenuItem(value: "Yiyecek",child: Text("Yiyecek"),),
                  DropdownMenuItem(value: "İçecek",child: Text("İçecek"),),
                  DropdownMenuItem(value: "Akaryakıt",child: Text("Akaryakıt"),),
                  DropdownMenuItem(value: "Otopark",child: Text("Otopark"),)
                  ];

class _FormWidgetState extends State<FormWidget> {
  TextEditingController dateController = TextEditingController();

  Future<void> tarihSec(BuildContext context)async{
    DateTime? secilenTarih=await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100));
    if (secilenTarih!=null) {
      setState(() {
        dateController.text=secilenTarih.toString().split(' ')[0];
      });
    }
  }
  
  String dropdownValue = items.first.value!;
  void dropDownCallBack(String? selectedValue){
    if (selectedValue is String) {
      setState(() {
        dropdownValue=selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                
                decoration: const InputDecoration(
                  labelText: 'Adres',
                  border: OutlineInputBorder(),

                ),
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'V.D',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Tarih',
                  prefixIcon: Icon(Icons.calendar_today),
                  
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.none,
                onTap: () {
                  tarihSec(context);
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder()
                ),
                items: items,
                value: dropdownValue,
                onChanged: (value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },//dropDownCallBack
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'KDV Tutarı',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Toplam Tutar',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              
            ],
          ),
        ),
      ),
      //floatingActionButton: FloatingActionButton(onPressed: (){}, backgroundColor: Colors.green,child: const Icon(Icons.save),),
    );
  }
}