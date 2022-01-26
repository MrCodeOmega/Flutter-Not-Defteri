import 'package:flutter/material.dart';

class FormElemanlari extends StatefulWidget {
  const FormElemanlari({Key? key}) : super(key: key);
  @override
  _FormElemanlariState createState() => _FormElemanlariState();
}

class _FormElemanlariState extends State<FormElemanlari> {
  bool checkBoxState = false;
  String? radioState = "default";
  double? sliderState = 0.0;
  List<String> renkler = ["Kırmızı", "Mavi", "Yeşil"];
  String? dropDownState = "";
  List<Step>? tumStepler;

  var key0, key1, key2 = GlobalKey<FormFieldState>();

  void initState() {
    super.initState();
  }

  int _aktifStep = 0;
  String isim = "", mail = "", sifre = "";
  bool hata = false;
  @override
  Widget build(BuildContext context) {
    tumStepler = _tumStepler();
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Elemanları"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(children: [
          CheckboxListTile(
              title: Text("Formu kabil et"),
              value: checkBoxState,
              onChanged: (durum) {
                checkBoxState = durum!;
                setState(() {});
              }),
          RadioListTile<String>(
              title: Text("Game"),
              value: "Game",
              groupValue: radioState,
              onChanged: (deger) {
                radioState = deger;
                print("$radioState");
                setState(() {});
              }),
          RadioListTile<String>(
              title: Text("Sport"),
              value: "Sport",
              groupValue: radioState,
              onChanged: (deger) {
                radioState = deger;
                print("$radioState");
                setState(() {});
              }),
          RadioListTile<String>(
              title: Text("Book"),
              value: "Book",
              groupValue: radioState,
              onChanged: (deger) {
                radioState = deger;
                print("$radioState");
                setState(() {});
              }),
          Slider(
            value: sliderState!,
            onChanged: (deger) {
              sliderState = deger;
              setState(() {});
            },
            min: 0.0,
            max: 50.0,
            label: "$sliderState",
          ),
          Text("${sliderState!.round()}"),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            DropdownButton<String>(
              hint: Text("Renk Seçin"),
              items: renkler.map((e) {
                return DropdownMenuItem<String>(
                  child: Text(e),
                  value: e,
                );
              }).toList(),
              onChanged: (deger) {
                setState(() {
                  dropDownState = deger;
                });
              },
            ),
            Text("$dropDownState"),
          ]),
          Stepper(
            currentStep: _aktifStep,

            onStepTapped: (tiklanilanStep) {
              _aktifStep = tiklanilanStep;
              setState(() {});
            },
            onStepContinue: () {
              setState(() {
                _ileriButonuKontrol();
              });
            },
            onStepCancel: () {
              if (_aktifStep > 0) {
                setState(() {
                  _aktifStep--;
                });
              }
            },
            steps: _tumStepler(),
            // type: StepperType.horizontal,
          ),
        ]),
      ),
    );
  }

  List<Step> _tumStepler() {
    List<Step> stepler = [
      Step(
          title: Text("Username"),
          state: _stateAyarla(0),
          isActive: true,
          content: TextFormField(
            key: key0,
            decoration: InputDecoration(
                labelText: "Username Label",
                hintText: "Username",
                border: OutlineInputBorder()),
            onSaved: (girilenDeger) {
              isim = girilenDeger!;
            },
          )),
      Step(
          title: Text("Email"),
          state: _stateAyarla(1),
          content: TextFormField(
            key: key1,
            decoration: InputDecoration(
                labelText: "Email Label",
                hintText: "Email",
                border: OutlineInputBorder()),
            onSaved: (girilenDeger) {
              mail = girilenDeger!;
            },
          )),
      Step(
          title: Text("Password"),
          state: _stateAyarla(2),
          content: TextFormField(
            key: key2,
            decoration: InputDecoration(
                labelText: "Password Label",
                hintText: "Password",
                border: OutlineInputBorder()),
            onSaved: (girilenDeger) {
              sifre = girilenDeger!;
            },
          ))
    ];
    return stepler;
  }

  StepState _stateAyarla(int oankiStep) {
    if (_aktifStep == oankiStep) {
      if (hata) {
        return StepState.error;
      }
    } else {
      return StepState.editing;
    }
    return StepState.complete;
  }

  void _ileriButonuKontrol() {
    switch (_aktifStep) {
      case 0:
        if (key0.currentState!.validate()) {
          key0.currentState!.save();
          hata = false;
          _aktifStep = 1;
        } else {
          hata = true;
        }
        break;

      case 1:
        if (key1.currentState!.validate()) {
          key1.currentState!.save();
          hata = false;
          _aktifStep = 2;
        } else {
          hata = true;
        }
        break;
      case 2:
        if (key2.currentState!.validate()) {
          key2.currentState!.save();
          hata = false;
          _aktifStep = 2;
        } else {
          hata = true;
          formTamamlandi();
        }
        break;
      default:
    }
  }

  void formTamamlandi() {
    debugPrint("Girilen değerler : isim => ${isim} mail =>$mail sifre=>$sifre");
  }
}
