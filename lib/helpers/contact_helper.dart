import 'package:sqflite/sqflite.dart';

final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper {}

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
  Map toMap() {
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
