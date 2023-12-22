import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Menu.dart';
import 'model/admin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Admin').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }
        if (snapshot.hasData) {
          List docs = snapshot.data!.docs;
        }
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _login(context, data as List<DocumentSnapshot<Object?>>)).toList(),
    );
  }
  
  Widget _login(BuildContext context, List<DocumentSnapshot> data){
    //final record = Record.fromSnapshot(data as DocumentSnapshot<Object?>);
    return Scaffold(
      appBar: AppBar(
          title: new Center(child: const Text('Login Screen', style: TextStyle(fontSize: 50),)),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(250.0,40.0,250.0,40.0),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(250.0,40.0,250.0,40.0),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),

            ElevatedButton(
              onPressed: (){
                //Implement Login logic here
                String username = usernameController.text;
                String password = passwordController.text;


                if(username == 'test' && password == '123456789'){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Menu()
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Login Failed'),
                        content: const Text('Invalid username or password.'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('login'),
            ),

          ],
        ),
      ),
    );
  }
}
Stream<List<admin>> readBin() =>
    FirebaseFirestore.instance
        .collection('admin')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => admin.fromJson(doc.data())).toList());
