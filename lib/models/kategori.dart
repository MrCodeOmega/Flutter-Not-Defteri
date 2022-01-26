class Kategori {
  int? kategoriID;
  String? kategoriBaslik;

  Kategori(this.kategoriBaslik); //Kategori Eklerken çağrılan

  Kategori.withID(this.kategoriID, this.kategoriBaslik); //Kategori Okurken

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["kategoriID"] = kategoriID;
    map["kategoriBaslik"] = kategoriBaslik;
    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map) {
    this.kategoriID = map["kategoriID"];
    this.kategoriBaslik = map["kategoriBaslik"];
  }

  String toString() {
    return "Kategori{KategoriID : $kategoriID , KategoriBaslik : $kategoriBaslik}";
  }
}
