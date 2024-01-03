import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:admin/model/bin.dart';
import 'Driver.dart';
import 'Login.dart';
import 'Setting.dart';

class Schedule extends StatefulWidget {
  final String username;
  final String password;

  Schedule({required this.username, required this.password});

  @override
  State<Schedule> createState() => _ScheduleState(username, password);
}

class _ScheduleState extends State<Schedule> {
  DateTime dates = DateTime(2023, 12, 18);
  String date1 = "2023-12-18";
  final TextEditingController dateController = TextEditingController();
  String username;
  String password;

  _ScheduleState(this.username,this.password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Center(
              child: const Text('Schedule', style: TextStyle(fontSize: 50),)),
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
                                builder: (context) => Driver(username: username,password: password)
                            ),
                          );
                        },
                        child: const MenuAcceleratorLabel('&Manage Driver'),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Setting(username: username,password: password)
                            ),
                          );
                        },
                        child: const MenuAcceleratorLabel('Setting'),
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

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    child: SizedBox(
                      height: 50.0,
                      width: 150,
                      child: TextField(
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Date",
                        ),
                      ),
                    ),),
                  ElevatedButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: dates,
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2100)
                        );

                        if (newDate == null) return;

                        else
                          setState(() {
                            dates = newDate;
                            date1 = dateController.text =
                            "${dates.year} - ${dates.month} - ${dates.day}";


                          });
                        /*StreamBuilder<List<bin>>(
                          stream: readBin(newDate.toString()),
                          builder: (context,snapshot) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong! ${snapshot.error}");
                            }
                            else if (snapshot.hasData) {
                              final bins = snapshot.data!;

                              return  Container(
                                height: 400,

                                child: ListView(
                                  children: bins.map(buildbin).toList(),
                                ),
                              );
                            } else if(!snapshot.hasData){
                              return Text("no data");
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        );*/

                      },
                      child: Icon(Icons.calendar_today))

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<List<bin>>(
                stream: readBin(dates.toString()),
                builder: (context,snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong! ${snapshot.error}");
                  }
                  else if (snapshot.hasData) {
                    final bins = snapshot.data!;

                    return  Container(
                      height: 400,

                      child: ListView(
                          children: bins.map(buildbin).toList(),
                      ),
                    );
                  } else if(!snapshot.hasData){
                      return Text("no data");
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],

        )
    );
  }
  
  Widget buildbin(bin bin){
        return ListTile(
          title: Text("${bin.id}"),
          subtitle: Text("${bin.date}"),
          //subtitle: Text(bin.latitude.toString()),
        );

  }

  Stream<List<bin>> readBin(String a) =>
      FirebaseFirestore.instance
          .collection('bin').where('date', isEqualTo: date1)
          .snapshots()
          .map((snapshot) =>
            snapshot.docs.map((doc) => bin.fromJson(doc.data())).toList());

}

