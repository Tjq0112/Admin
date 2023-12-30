import 'package:admin/model/driver1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isSecuredPassword = true;

  _DriverState(this.username, this.password);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Center(
              child: const Text('Manage Driver', style: TextStyle(fontSize: 50),)),
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
            Column(
              children: [
                Text("Add new driver",style: TextStyle(
                    fontSize: 30
                ),),
                Padding(
                  padding: const EdgeInsets.fromLTRB(250.0, 40.0, 250.0, 40.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter driver name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(250.0, 40.0, 250.0, 40.0),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Enter driver username',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(250.0, 40.0, 250.0, 40.0),
                  child: TextField(
                    obscureText: _isSecuredPassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter driver password',
                      suffixIcon: togglePassword(),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: (){
                      String d_name = nameController.text;
                      String d_username = usernameController.text;
                      String d_password = passwordController.text;
                      
                      final driver = Driver1(
                          d_name: d_name, 
                          d_username: d_username, 
                          d_password: d_password
                      );
                      
                      createDriver(driver);
                    },
                    child: const Text("Add")
                )
              ],
            )
          ],
        )
    );
  }
  Widget togglePassword(){
    return IconButton(onPressed: (){
      setState(() {
        _isSecuredPassword = !_isSecuredPassword;
      });
    }, icon: _isSecuredPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility));
  }
  
  Future createDriver(Driver1 driver) async{
    final docDriver = FirebaseFirestore.instance.collection('Driver').doc();
    driver.id = docDriver.id;

    final json = driver.toJson();
    await docDriver.set(json);

    const snackBar = SnackBar(
      content: Text('Driver Added!'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}
