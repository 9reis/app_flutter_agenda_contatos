import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  late Database _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    //Pega o local onde o db é armazenado
    final databasesPath = await getDatabasesPath();
    // pega o caminho e junta com o nome do db
    final path = join(databasesPath, "contacts.db");
    //Abre o db
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)");
    });
  }

  //Salvando o contato
  Future<Contact> saveContact(Contact contact) async {
    final dbContact = await db;
    contact.id = await dbContact!.insert(contactTable, contact.toMap());
    return contact;
  }

  //Obtendo contato
  Future<Contact?> getContact(int id) async {
    Database? dbContact = await db;
    List<Map> maps = await dbContact!.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  //DELETA contato
  Future<int> deleteContact(int id) async {
    Database? dbContact = await db;
    return await dbContact!
        .delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  //ATUALIZA contato
  Future<int> updateContact(Contact contact) async {
    Database? dbContact = await db;
    return await dbContact!.update(contactTable, contact.toMap(),
        where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  //PEGA todos os contatos
  Future<List> getAllContact() async {
    Database? dbContact = await db;
    //Retorna uma lista de Map
    List listMap = await dbContact!.rawQuery("SELECT * FROM $contactTable");
    //Map to Contact - Pega cada map e transforma em um contato
    List<Contact> listContact = [];
    for (Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  //PEGA o numero do contato
  getNumber() async {
    Database? dbContact = await db;
    //Qnt de contatos da tb
    return Sqflite.firstIntValue(
        await dbContact!.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  //FECHA o db
  Future close() async {
    Database? dbContact = await db;
    dbContact!.close();
  }
}

class Contact {
  late int id;
  late String name;
  late String email;
  late String phone;
  late String img;

  //COnstruto - Pega o map e constroi o Contato
  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  // Contact TO Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact( id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
