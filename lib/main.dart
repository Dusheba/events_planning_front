
import 'package:flutter/material.dart';
import 'database.dart';
import 'package:events_planning/data/client.dart';
import 'dart:math' as math;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DBProvider.db.initDB();
  Client cl = Client(id:1,name: "Raouf", username: "Rahiche", pass: "1",
      phone: "99999", email: "test", social: "aahgag");
  print(DBProvider.db.newClient(cl));
 runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // data for testing
  List<Client> testClients = [
    Client(name: "Raouf", username: "Rahiche", pass: "1", phone: "99999", email: "test", social: "fh"),
    Client(name: "ete", username: "Rahiche", pass: "1", phone: "99999", email: "test", social: "jf"),
    Client(name: "Shl", username: "Rahiche", pass: "1", phone: "99999", email: "test", social: "jf"),
  ];
  final Future<List<Client>> _clients = DBProvider.db.getAllClients();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQLite")),
      body: FutureBuilder<List<Client>>(
        future: _clients,
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                Client item = snapshot.data![index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DBProvider.db.deleteClient(item.id!);
                  },
                  child: ListTile(
                    title: Text(item.name),
                    leading: Text(item.id.toString()),
                    // trailing: Checkbox(
                    //   onChanged: (bool value) {
                    //     DBProvider.db.blockOrUnblock(item);
                    //     setState(() {});
                    //   },
                    //   value: item.blocked,
                    // ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Client rnd = testClients[math.Random().nextInt(testClients.length)];
          await DBProvider.db.newClient(rnd);
          setState(() {});
        },
      ),
    );
  }
}