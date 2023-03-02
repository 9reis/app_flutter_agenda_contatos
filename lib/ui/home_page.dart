import 'package:app_flutter_agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    super.initState();

    Contact c = Contact();
    c.name = "teste2";
    c.email = "teste2@teste";
    c.phone = "999 999 999";
    c.img = "imgteste2";

    helper.saveContact(c);

    helper.getAllContact().then((list) {
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
