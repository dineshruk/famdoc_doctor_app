import 'package:famdoc_doctor_app/screens/add_new_time_screen.dart';
import 'package:famdoc_doctor_app/widgets/published_package.dart';
import 'package:famdoc_doctor_app/widgets/unpublished_package.dart';
import 'package:flutter/material.dart';

class SetTimeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
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
                        child: Row(
                          children: [
                            Text('SetUp Hire'),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              maxRadius: 8,
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '20',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    FlatButton.icon(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Add New',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AddNewTime.id);
                      },
                    )
                  ],
                ),
              ),
            ),
            TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: 'Published',
                  ),
                  Tab(
                    text: 'Un Published',
                  )
                ]),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  PublishedPckages(),
                  UnPublishedPckages(),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
