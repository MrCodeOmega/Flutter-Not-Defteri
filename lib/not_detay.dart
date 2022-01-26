import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_project/main.dart';
import 'package:flutter_chat_project/models/kategori.dart';
import 'package:flutter_chat_project/models/notlar.dart';
import 'package:flutter_chat_project/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NotDetay extends StatefulWidget {
  String? baslik;
  Not? duzenlenecekNot;
  NotDetay({this.baslik, this.duzenlenecekNot});

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  List<Kategori>? tumKategoriler;
  DatabaseHelper? databaseHelper;
  int kategoriID = 1;
  int secilenOncelik = 1;
  String? notBaslik, notIcerik;
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    super.initState();
    tumKategoriler = [];
    databaseHelper = DatabaseHelper();
    databaseHelper!.kategorileriGetir().then((kategoriIcerenMapListesi) {
      for (Map<String, dynamic> okunanmap in kategoriIcerenMapListesi!) {
        setState(() {
          tumKategoriler!.add(Kategori.fromMap(okunanmap));
        });
      }
      if (widget.duzenlenecekNot != null) {
        kategoriID = widget.duzenlenecekNot!.kategoriID!;
        secilenOncelik = widget.duzenlenecekNot!.notOncelik!;
      } else {
        kategoriID = 1;
        secilenOncelik = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text(widget.baslik!),
        ),
      ),
      body: tumKategoriler!.length <= 0
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Kategori",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 24),
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.amber.shade400, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              items: kategorileriOlustur(),
                              value: kategoriID,
                              onChanged: (secilenKategoriID) {
                                setState(() {
                                  kategoriID = secilenKategoriID!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.duzenlenecekNot != null
                            ? widget.duzenlenecekNot!.notBaslik
                            : "",
                        validator: (text) {
                          if (text!.length < 3) {
                            return "Not 3 karakterden kısa girilemez.";
                          }
                        },
                        onSaved: (text) {
                          notBaslik = text;
                        },
                        decoration: InputDecoration(
                            hintText: "Not Başlığı",
                            labelText: "Başlık",
                            border: OutlineInputBorder()),
                      ),
                    ),
                    //Not İceriği *****
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.duzenlenecekNot != null
                            ? widget.duzenlenecekNot!.notIcerik
                            : "",
                        onSaved: (text) {
                          notIcerik = text;
                        },
                        minLines: 4,
                        maxLines: 8,
                        decoration: InputDecoration(
                            hintText: "Not İçeriği",
                            labelText: "İçerik",
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Öncelik",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 24),
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.amber.shade400, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              items: _oncelik
                                  .map((oncelik) => DropdownMenuItem<int>(
                                        child: Text(oncelik,
                                            style: TextStyle(fontSize: 24)),
                                        value: _oncelik.indexOf(oncelik),
                                      ))
                                  .toList(),
                              value: secilenOncelik,
                              onChanged: (secilenOncelikID) {
                                setState(() {
                                  secilenOncelik = secilenOncelikID!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage()));
                          },
                          child: Text("Vazgeç"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red.shade900),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            var suan = DateTime.now();
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              if (widget.duzenlenecekNot == null) {
                                databaseHelper!
                                    .notEkle(Not(
                                        kategoriID,
                                        notBaslik,
                                        notIcerik,
                                        suan.toString(),
                                        secilenOncelik))!
                                    .then((value) {
                                  if (value != 0) {
                                    print("Not Eklendi $notIcerik");
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.grey,
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("Notunuz Kaydedildi."),
                                          Icon(
                                            Icons.thumb_up,
                                            color: Colors.amber.shade700,
                                          ),
                                        ],
                                      ),
                                    ));
                                  }
                                  setState(() {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  });
                                });
                              } else {
                                databaseHelper!.notGuncelle(Not.withID(
                                    widget.duzenlenecekNot!.notID,
                                    kategoriID,
                                    notBaslik,
                                    notIcerik,
                                    suan.toString(),
                                    secilenOncelik));

                                setState(() {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => HomePage()));
                                });
                              }
                            }
                          },
                          child: Text("Notu Kaydet"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.orange.shade600),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    _ozelButton(),
                    Spacer(),
                    Text(
                      "@Code0mega",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<DropdownMenuItem<int>> kategorileriOlustur() {
    List<DropdownMenuItem<int>> kategoriler = [];
    return tumKategoriler!
        .map((kategori) => DropdownMenuItem<int>(
            value: kategori.kategoriID,
            child: Text(
              kategori.kategoriBaslik!,
              style: TextStyle(fontSize: 18, color: Colors.amber.shade600),
            )))
        .toList();
  }

  Widget _ozelButton() {
    if (widget.duzenlenecekNot == null) {
      return Divider(
        color: Colors.grey,
        indent: 25,
        endIndent: 25,
      );
    } else {
      return ElevatedButton(
          onPressed: () {
            if (widget.duzenlenecekNot == null) {
            } else {
              databaseHelper!.notSil(widget.duzenlenecekNot!.notID!);

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Not Silindi")));
              setState(() {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
              });
            }
          },
          child: Text("Notu Sil"));
    }
  }
}
