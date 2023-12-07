import 'package:flutter/material.dart';

import 'Login.dart';
import 'Schedule.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: new Center(
                child: const Text('Report', style: TextStyle(fontSize: 50),)),
            automaticallyImplyLeading: false,
        ),
        body:
        Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: MenuBar(
                    children: <Widget>[
                      MenuItemButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Schedule()
                            ),
                          );
                        },
                        child: const MenuAcceleratorLabel('&Schedule'),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Report()
                            ),
                          );
                        },
                        child: const MenuAcceleratorLabel('&Report'),
                      ),
                      MenuItemButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text('Do you sure you want to logout?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()
                                    ),
                                  );},
                                child: const Text('Sure'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        ),
                        child: const MenuAcceleratorLabel('&Logout'),
                      ),
                    ],

                  ),

                ),
              ],
            ),
          ],
        )
    );
  }
}
