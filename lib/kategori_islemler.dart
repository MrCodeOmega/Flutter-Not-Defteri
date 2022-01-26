import 'package:flutter/material.dart';
import 'package:flutter_chat_project/models/kategori.dart';
import 'package:flutter_chat_project/utils/database_helper.dart';

class Kategoriler extends StatefulWidget {
  const Kategoriler({Key? key}) : super(key: key);

  @override
  State<Kategoriler> createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  List<Kategori>? tumKategoriler;

  DatabaseHelper? databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (tumKategoriler == null) {
      tumKategoriler = <Kategori>[];
      kategoriListesiniGuncelle();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Kategoriler"),
        ),
        body: ListView.builder(
            itemCount: tumKategoriler!.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () => kategoriGuncelle(tumKategoriler![index], context),
                title: Text(
                  tumKategoriler![index].kategoriBaslik!,
                ),
                trailing: InkWell(
                  child: Icon(Icons.delete),
                  onTap: () => _kategoriSil(tumKategoriler![index].kategoriID!),
                ),
                leading: Icon(Icons.category),
              );
            }));
  }

  void kategoriListesiniGuncelle() {
    databaseHelper!.kategoriListesiniGetir().then((kategorileriIcerenList) {
      setState(() {
        tumKategoriler = kategorileriIcerenList;
      });
    });
  }

  _kategoriSil(int kategoriID) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Kategori Silinecek ?"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Kategori Silinirse Alakalı Notlar da Silinecektir"),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Vazgeç")),
                    TextButton(
                        onPressed: () {
                          databaseHelper!
                              .kategoriSil(kategoriID)!
                              .then((value) {
                            if (value != 0) {
                              kategoriListesiniGuncelle();
                            }

                            Navigator.pop(context);
                          });
                        },
                        child: Text("SİL")),
                  ],
                ),
              ],
            ),
          );
        });
  }

  kategoriGuncelle(Kategori guncellenecekKategori, BuildContext context) {
    kategoriGuncelleDialog(context, guncellenecekKategori);
  }

  kategoriGuncelleDialog(BuildContext context, Kategori guncellenecekKategori) {
    var formKey = GlobalKey<FormState>();
    var guncellenecekKategoriAdi;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                "Kategori Güncelle",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              children: [
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: guncellenecekKategori.kategoriBaslik,
                      onSaved: (deger) {
                        guncellenecekKategoriAdi = deger;
                      },
                      decoration: InputDecoration(
                        label: Text(
                          "Kategori Adı :",
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.8)),
                      ),
                      validator: (girilenKategoriAdi) {
                        if (girilenKategoriAdi!.length < 3) {
                          return "En az üç Karakter olmalıdır.";
                        }
                      },
                    ),
                  ),
                ),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Vazgeç"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          databaseHelper!
                              .kategoriGuncelle(Kategori.withID(
                                  guncellenecekKategori.kategoriID,
                                  guncellenecekKategoriAdi))!
                              .then((kategoriID) {
                            if (kategoriID != 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Kategori Güncellendi")));
                              kategoriListesiniGuncelle();
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      },
                      child: Text("Kaydet"),
                    )
                  ],
                ),
              ],
            ));
  }
}
