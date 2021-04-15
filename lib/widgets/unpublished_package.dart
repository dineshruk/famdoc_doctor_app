import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famdoc_doctor_app/screens/edit_view_packages.dart';
import 'package:famdoc_doctor_app/services/firebase_services.dart';
import 'package:flutter/material.dart';

class UnPublishedPckages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Container(
      child: StreamBuilder(
        stream:
            _services.packages.where('published', isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: FittedBox(
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 60,
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                columns: <DataColumn>[
                  DataColumn(
                    label: Expanded(child: Text('Package')),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text('Price(Rs.)'),
                    ),
                  ),
                  DataColumn(
                    label: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text('Info'),
                    ),
                  ),
                  DataColumn(
                    label: Text('Actions'),
                  ),
                ],
                rows: _packageDetails(snapshot.data, context),
              ),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _packageDetails(QuerySnapshot snapshot, context) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      if (document != null) {
        return DataRow(cells: [
          DataCell(SizedBox(
            width: 130,
            child: Container(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Expanded(child: Text(document.data()['packageName'])),
                subtitle: Text(document.data()['categoryName']['subCategory']),
              ),
            ),
          )),
          DataCell(Container(
            child: Text(document.data()['price'].toString()),
          )),
          DataCell(IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditViewPackage(
                            packageId: document.data()['packageId'],
                          )));
            },
          )),
          DataCell(
            popUpButton(document.data()),
          ),
        ]);
      }
    }).toList();
    return newList;
  }

  Widget popUpButton(data, {BuildContext context}) {
    FirebaseServices _services = FirebaseServices();
    return PopupMenuButton<String>(
        onSelected: (String value) {
          if (value == 'publish') {
            _services.publishPackage(
              id: data['packageId'],
            );
          }
          if (value == 'delete') {
            _services.deletePackage(
              id: data['packageId'],
            );
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem(
                value: 'publish',
                child: ListTile(
                  leading: Icon(Icons.check),
                  title: Text('Publish'),
                ),
              ),
              const PopupMenuItem(
                value: 'preview',
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Preview'),
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Edit Package'),
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outlined),
                  title: Text('Delete Package'),
                ),
              ),
            ]);
  }
}
