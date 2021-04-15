



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famdoc_doctor_app/screens/edit_view_packages.dart';
import 'package:famdoc_doctor_app/services/firebase_services.dart';
import 'package:flutter/material.dart';

class PublishedPckages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Container(
      child: StreamBuilder(
        stream:
            _services.packages.where('published', isEqualTo: true).snapshots(),
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
            child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 60,
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: <DataColumn>[
                DataColumn(
                  label: Text('Package'),
                ),
                DataColumn(
                  label: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text('Day Time'),
                  ),
                ),
                DataColumn(
                  label: Text('Actions'),
                ),
              ],
              rows: _packageDetails(snapshot.data),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _packageDetails(QuerySnapshot snapshot) {
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                document.data()['categoryName']['categoryImage'],
                width: 50,
              ),
            ),
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
          if (value == 'unpublish') {
            _services.unpublishPackage(
              id: data['packageId'],
            );
          }
         
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem(
                value: 'unpublish',
                child: ListTile(
                  leading: Icon(Icons.check),
                  title: Text('Un Publish'),
                ),
              ),
              const PopupMenuItem(
                value: 'preview',
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Preview'),
                ),
              ),
            ]);
  }
}
