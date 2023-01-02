// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Map<String, dynamic>> _contactCard = [];
  final _contactBox = Hive.box("contact_box");

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = _contactBox.keys.map((key) {
      final value = _contactBox.get(key);
      return {"key": key, "name": value["name"], "phone": value["phone"]};
    }).toList();
    setState(() {
      _contactCard = data.reversed.toList();
    });
  }

  Future<void> _createContact(Map<String, dynamic> newContact) async {
    await _contactBox.add(newContact);
    _refreshItems();
  }

  Future<void> _updateContact(
      int contactKey, Map<String, dynamic> contact) async {
    await _contactBox.put(contactKey, contact);
    _refreshItems();
  }

  Future<void> _deleteContact(int contactKey) async {
    await _contactBox.delete(contactKey);
    _refreshItems();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Contact deleted successfully"),
      ),
    );
  }

  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();

  void _showForm(BuildContext context, int? contactKey) async {
    if (contactKey != null) {
      final existingContact =
          _contactCard.firstWhere((element) => element['key'] == contactKey);
      _contactNameController.text = existingContact['name'];
      _contactPhoneController.text = existingContact['phone'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 15.5,
          left: 15.5,
          right: 15.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _contactNameController,
              decoration: InputDecoration(
                hintText: "name",
                prefixIcon: Icon(Icons.person_add),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _contactNameController.clear();
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contactPhoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "number",
                prefixIcon: Icon(Icons.phone),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _contactPhoneController.clear();
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () async {
                if (contactKey == null) {
                  _createContact({
                    "name": _contactNameController.text,
                    "phone": _contactPhoneController.text,
                  });
                }

                if (contactKey != null) {
                  _updateContact(contactKey, {
                    "name": _contactNameController.text,
                    "phone": _contactPhoneController.text,
                  });
                }
                _contactNameController.text = "";
                _contactPhoneController.text = "";

                Navigator.of(context).pop();
              },
              color: Colors.indigo,
              textColor: Colors.white,
              elevation: 0.5,
              child: Text(contactKey == null ? "Create New" : "Update"),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Card"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "OgdenMorrow",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Georgia",
                ),
              ),
              accountEmail: Text(
                "OgdenMorroww@gmail.com",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Georgia",
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("asset/shed.jpg"),
                radius: 45.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        elevation: 0.5,
      ),
      body: _contactCard.isEmpty
          ? Center(
              child: Text(
                "No Contact To Disply",
                style: TextStyle(
                  fontSize: 20.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  fontFamily: "Georgia",
                ),
              ),
            )
          : ListView.builder(
              itemCount: _contactCard.length,
              itemBuilder: (_, index) {
                final currentContact = _contactCard[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(10),
                  elevation: 3.0,
                  child: ListTile(
                    title: Text(
                      "Name: ${currentContact["name"]}",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Georgia",
                      ),
                    ),
                    subtitle: Text(
                      "Phone: ${currentContact["phone"].toString()}",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Georgia",
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.black,
                          onPressed: () =>
                              _showForm(context, currentContact["key"]),
                        ),
                        IconButton(
                          onPressed: () =>
                              _deleteContact(currentContact["key"]),
                          icon: Icon(Icons.delete),
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        tooltip: "Add Contact",
        backgroundColor: Colors.indigo,
        elevation: 3.0,
      ),
    );
  }
}
