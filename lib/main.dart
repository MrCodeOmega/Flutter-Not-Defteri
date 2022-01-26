import 'package:flutter/material.dart';
import 'package:flutter_chat_project/kategori_islemler.dart';
import 'package:flutter_chat_project/models/kategori.dart';
import 'package:flutter_chat_project/models/notlar.dart';
import 'package:flutter_chat_project/not_detay.dart';
import 'package:flutter_chat_project/utils/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseHelper databaseHelper = DatabaseHelper();
    databaseHelper.kategorileriGetir();

    return MaterialApp(
      title: "NOTLARIM",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          InkWell(
              child: Icon(Icons.settings),
              onTap: () => _kategorilerSayfasinaGit(context)),
        ],
        title: Center(
          child: Text("Not Sepeti"),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 1,
            onPressed: () {
              kategoriEkleDialog();
            },
            child: Icon(Icons.star_rate_rounded),
            mini: true,
            backgroundColor: Colors.amber[400],
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            heroTag: 2,
            onPressed: () {
              _detaySayfasinaGit();
            },
            child: const Icon(Icons.note_add),
            backgroundColor: Colors.white,
          ),
        ],
      ),
      body: Notlar(),
    );
  }

  void kategoriEkleDialog() {
    var formKey = GlobalKey<FormState>();
    var yeniKategoriAdi;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                "Kategori Ekle",
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
                      onSaved: (deger) {
                        yeniKategoriAdi = deger;
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
                          databaseHelper
                              .kategoriEkle(Kategori(yeniKategoriAdi))!
                              .then((kategoriID) {
                            if (kategoriID > 0) {
                              const snackBar =
                                  SnackBar(content: Text("Kategori Eklendi"));

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              print("kategori Eklendi : $kategoriID");
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

  void _detaySayfasinaGit() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NotDetay(
              baslik: "Yeni Not",
            )));
  }

  _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Kategoriler()));
  }
}

class Notlar extends StatefulWidget {
  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  List<Not>? tumNotlar;
  DatabaseHelper? databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
    tumNotlar = <Not>[];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseHelper!.notListesiniGetir(),
      builder: (context, AsyncSnapshot<List<Not>> snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          tumNotlar = snapShot.data;
          return ListView.builder(
              itemCount: tumNotlar!.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Colors.deepPurple.shade400
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 12,
                                    offset: Offset(0, 6))
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(databaseHelper!.dateFormat(
                                        DateTime.parse(
                                            tumNotlar![index].notTarih!)))),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(tumNotlar![index].notBaslik!,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16)),
                                      SizedBox(height: 16),
                                      Text(tumNotlar![index].notIcerik!,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(children: [
                                        _oncelikIconuAta(
                                            tumNotlar![index].notOncelik!),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(tumNotlar![index].kategoriBaslik!,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500)),
                                      ]),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder:
                                                    (context) => SimpleDialog(
                                                            backgroundColor:
                                                                Colors.brown
                                                                    .shade600,
                                                            title: Text(
                                                              tumNotlar![index]
                                                                  .notBaslik!,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            children: [
                                                              ButtonBar(
                                                                children: [
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          "Vazgeç")),
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        _detaySayfasinaGit(
                                                                            context,
                                                                            tumNotlar![index]);
                                                                      },
                                                                      child: Text(
                                                                          "Düzenle"))
                                                                ],
                                                              )
                                                            ]));
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.settings_applications,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                "Düzenle",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _notSil(int notID) {
    databaseHelper!.notSil(notID)!.then((silinenNotID) {
      if (silinenNotID != 0) {}
    });
  }

  void _detaySayfasinaGit(BuildContext context, Not not) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NotDetay(
              baslik: "Not Düzenle",
              duzenlenecekNot: not,
            )));
  }
}

_oncelikIconuAta(int notOncelik) {
  switch (notOncelik) {
    case 0:
      return Icon(
        Icons.label_important_sharp,
        size: 20,
        color: Colors.white,
      );
    case 1:
      return Icon(
        Icons.label_important_sharp,
        size: 20,
        color: Colors.yellow.shade300,
      );
    case 2:
      return Icon(
        Icons.label_important_sharp,
        size: 20,
        color: Colors.red,
      );
    default:
  }
}
