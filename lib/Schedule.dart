import 'package:admin/model/Pickup.dart';
import 'package:admin/model/Schedule1.dart';
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
  final TextEditingController sequenceController = TextEditingController();

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
              child: StreamBuilder<List<Schedule1>>(
                stream: readSchedule(date1),
                builder: (context,snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong! ${snapshot.error}");
                  }
                  else if (snapshot.hasData) {
                    final schedules = snapshot.data!;
                    List<Schedule1> schedule1 = schedules.toList();
                    return  Container(
                      height: 200,
                      child: ListView.builder(
                        // Let the ListView know how many items it needs to build.
                        itemCount: schedule1.length,
                        // Provide a builder function. This is where the magic happens.
                        // Convert each item into a widget based on the type of item it is.
                        itemBuilder: (context, index) {
                          final item = schedule1[index];

                          return StreamBuilder<List<Pickup>>(
                      stream: readPickup(item.id),
                      builder: (context,snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong! ${snapshot.error}");
                        }
                        else if (snapshot.hasData) {
                          final pickups = snapshot.data!;

                          return Container(
                            height: 400,

                            child: ListView(
                              children: pickups.map(buildPickup).toList(),
                            ),
                          );
                        } else if(!snapshot.hasData){
                          return Text("no data");
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                        },
                      ),
                    );

                    /*Container(
                      height: 400,

                      child: ListView(
                          children: schedules.map(buildSchedule).toList(),
                      ),
                    );*/
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
  
  Widget buildPickup(Pickup pickup){
        return ListTile(
          title: Text("${pickup.bin_Id}"),
          subtitle: Text("${pickup.status}"),
          onTap: (){
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Enter sequence"),
                  content: TextField(
                    controller: sequenceController,
                    decoration: const InputDecoration(
                      labelText: 'sequence',
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: (){
                          String sequence = sequenceController.text;
                          final editSequence = FirebaseFirestore.instance.collection('Pickup').doc(pickup.id);
                          editSequence.update({'sequence' : sequence});
                          Text(pickup.id);
                        },
                        child: Text("Save"))
                  ],
                )
            );
          },
        );

  }

  Stream<List<Schedule1>> readSchedule(String a) =>
      FirebaseFirestore.instance
          .collection('Schedule').where('date', isEqualTo: a)
          .snapshots()
          .map((snapshot) =>
            snapshot.docs.map((doc) => Schedule1.fromJson(doc.data())).toList());

  Stream<List<Pickup>> readPickup(String b) =>
      FirebaseFirestore.instance
          .collection('Pickup').where('schedule_Id', isEqualTo: b)
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => Pickup.fromJson(doc.data())).toList());

}

