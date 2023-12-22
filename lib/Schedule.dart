import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:admin/model/bin.dart';
import 'Login.dart';
import 'Report.dart';
import '../model/bin.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime dates = DateTime(2024, 1, 1);
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
                        onPressed: () =>
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                    title: const Text('Logout'),
                                    content: const Text(
                                        'Do you sure you want to logout?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()
                                            ),
                                          );
                                        },
                                        child: const Text('Sure'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
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
                        setState(() {
                          dates = newDate;
                          dateController.text =
                          "${dates.year} - ${dates.month} - ${dates.day}";
                          Timestamp timeStamp = Timestamp.fromDate(dates);
                          String timeStamps = timeStamp.toString();
                        });
                      },
                      child: Icon(Icons.calendar_today))

                ],
              ),),

            /*Padding(padding: const EdgeInsets.all(20.0),
            child: ReorderableListView(
                children: children,
                onReorder: onReorder)
              ,
            ),*/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<List<bin>>(
                stream: readBin(),
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
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )


          ],
        )
    );
  }

  /*Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
        shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    bin record = bin.fromSnapshot(data);
    DateTime date1 = record.date.toDate();
    String date2 = date1.toString();
    int index = 0;
    List<DateTime> date3 = [];
    if(index < 5) {
      bin record1;
    }
    
    return Padding(
      //key: ValueKey(record.date),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
                   title: Text(record.toString()),
                  trailing: Text(record.location),
                  //onTap: () => print(record),
                 ),
      ),
    );*/


  Widget buildbin(bin bin) =>
        ListTile(
          title: Text("${bin.date.year.toString()} - ${bin.date.month.toString()} - ${bin.date.day.toString()}"),
          subtitle: Text(bin.latitude.toString()),

        );

  Stream<List<bin>> readBin() =>
      FirebaseFirestore.instance
          .collection('bin')
          .snapshots()
          .map((snapshot) =>
            snapshot.docs.map((doc) => bin.fromJson(doc.data())).toList());

}

