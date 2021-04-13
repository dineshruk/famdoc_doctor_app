import 'package:flutter/material.dart';

class AddNewTime extends StatefulWidget {
  static const String id = 'addnew-time';

  @override
  _AddNewTimeState createState() => _AddNewTimeState();
}

class _AddNewTimeState extends State<AddNewTime> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Material(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        child: Text('SetUp Your Hire Time'),
                      ),
                    ),
                    FlatButton.icon(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(
                        Icons.save_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            
              ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(labelText: 'sdsd'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
            
          
          ],
        ),
      ),
    );
  }
}
