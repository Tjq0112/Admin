import 'package:flutter/material.dart';

import 'Login.dart';
import 'Report.dart';
import 'Schedule.dart';
import 'Setting.dart';

class Driver extends StatefulWidget {
  final String username;
  final String password;

  Driver({required this.username, required this.password});

  @override
  State<Driver> createState() => _DriverState(username, password);
}

class _DriverState extends State<Driver> {
  String username;
  String password;

  _DriverState(this.username, this.password);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Center(
              child: const Text('Main Menu', style: TextStyle(fontSize: 50),)),
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
                                builder: (context) => Schedule(username: username,password: password)
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
                                builder: (context) => Report(username: username,password: password)
                            ),
                          );
                        },
                        child: const MenuAcceleratorLabel('&Report'),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Driver(username: username,password: password)
                            ),
                          );
                        },
                        child: const MenuAcceleratorLabel('&Manage Driver'),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: MenuItemButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Setting(username: username,password: password)
                              ),
                            );
                          },
                          child: const MenuAcceleratorLabel('Setting'),
                        ),),
                    ],

                  ),

                ),
              ],
            ),
            Scaffold(

            )
          ],
        )
    );
  }
}
