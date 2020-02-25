import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_app/models/contact.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Column(
        children: <Widget>[Expanded(child: _buildListView()), NewContactForm()],
      ),
    );
  }

  Widget _buildListView() {
    // ignore: deprecated_member_use
    return WatchBoxBuilder(
      box: Hive.box('contacts'),
      builder: (context, contactBox) {
        return ListView.builder(
            itemCount: contactBox.length,
            itemBuilder: (context, index) {
              final contact = contactBox.getAt(index) as Contact;
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.age.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: null // you need perform update operation here
//                            () {
//                          contactBox.putAt(
//                              index,
//                              Contact(
//                                  '${contact.name.substring(0, contact.name.length - 1)}',
//                                  contact.age + 1));
//                        },
                    ),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          contactBox.deleteAt(index);
                        })
                  ],
                ),
              );
            });
      },
    );
  }
}

class NewContactForm extends StatefulWidget {
  @override
  _NewContactFormState createState() => _NewContactFormState();
}

class _NewContactFormState extends State<NewContactForm> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _name;

  String _age;

  void addContact(Contact newContact) {
    //print('name : ${newContact.name}  age: ${newContact.age}');
    final contactBox = Hive.box('contacts');
    contactBox.add(newContact);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      onSaved: (value) => _name = value,
                      validator: (value) =>
                          value.isEmpty ? 'user name required' : null,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                          labelText: 'Enter User Name',
                          errorStyle: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 16.0,
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: ageController,
                      onSaved: (value) => _age = value,
                      validator: (value) => value.isEmpty
                          ? 'Mobile Number\nis required'
                          : (value.length < 10 && value.length != 10)
                              ? 'Number should have\n10 character'
                              : (value.length > 10 && value.length < 12) ||
                                      value.length > 12
                                  ? 'Number should have\n12 or 10 characters'
                                  : null,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                          labelText: 'Enter Mobile number',
                          errorStyle: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 16.0,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: MaterialButton(
                color: Colors.purpleAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 4.0),
                  child: Text(
                    'Save contact',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ),
                onPressed: () {
                  final form = _formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    final newContact = Contact(_name, int.parse(_age));
                    nameController.clear();
                    ageController.clear();
                    addContact(newContact);
                  }
                },
              ),
            )
          ],
        ));
  }
}
