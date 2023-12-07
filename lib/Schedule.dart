import 'package:flutter/material.dart';

import 'Login.dart';
import 'Report.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime date = DateTime(2024,1,1);
  final TextEditingController dateController = TextEditingController();

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
                            initialDate: date,
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2100)
                        );

                        if (newDate == null) return;
                        setState(() {
                          date = newDate;
                          dateController.text = "${date.year} - ${date.month} - ${date.day}";
                        });
                      },
                      child: Icon(Icons.calendar_today))

                ],
              ),),
          ],
        )
    );
  }
}
