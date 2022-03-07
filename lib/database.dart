import 'package:events_planning/data/client.dart';
import 'package:events_planning/data/event.dart';
import 'package:events_planning/data/event_category.dart';
import 'package:events_planning/data/preference.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "events_db.db");
    print(path);
    return await openDatabase(path, version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE IF NOT EXISTS Client ("
              "id INTEGER PRIMARY KEY,"
              "name TEXT,"
              "username TEXT,"
              "pass TEXT,"
              "phone TEXT,"
              "email TEXT,"
              "social TEXT"
              ");"
              "CREATE TABLE IF NOT EXISTS Category ("
              "id INTEGER PRIMARY KEY,"
              "title TEXT,"
              "color TEXT);"
              "CREATE TABLE IF NOT EXISTS Event ("
              "id INTEGER PRIMARY KEY,"
              "categoryId INTEGER,"
              "title TEXT,"
              "description TEXT,"
              "address TEXT,"
              "budget REAL,"
              "startTime TEXT,"
              "ownerId INTEGER"
              "FOREIGN KEY (categoryId) REFERENCES Category (id)"
              "ON DELETE CASCADE ON UPDATE CASCADE,"
              "FOREIGN KEY (ownerId) REFERENCES Client (id)"
              "ON DELETE CASCADE ON UPDATE CASCADE);"
              "CREATE TABLE IF NOT EXISTS Preference ("
              "id INTEGER PRIMARY KEY,"
              "title TEXT,"
              "img TEXT);"
              "CREATE TABLE IF NOT EXISTS Client_Preference (id INTEGER PRIMARY KEY, client_id INTEGER, pref_id INTEGER"
              "FOREIGN KEY (client_id) REFERENCES Client (id) ON DELETE CASCADE ON UPDATE CASCADE,"
              "FOREIGN KEY (pref_id) REFERENCES Preference (id) ON DELETE CASCADE ON UPDATE CASCADE);"
              "CREATE TABLE IF NOT EXISTS Client_Event (id INTEGER PRIMARY KEY, client_id INTEGER, event_id INTEGER"
              "FOREIGN KEY (client_id) REFERENCES Client (id) ON DELETE CASCADE ON UPDATE CASCADE,"
              "FOREIGN KEY (event_id) REFERENCES Event (id) ON DELETE CASCADE ON UPDATE CASCADE);");
        });
  }

  newClient(Client newClient) async {
    final db = await database;
    var res = await db?.rawInsert(
        "INSERT Into Client (id,name,username,pass,phone,email,social)"
            " VALUES (${newClient.id},'${newClient.name}','${newClient.username}',"
            "'${newClient.pass}','${newClient.phone}','${newClient
            .email}', '${newClient.social}')");
    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db?.query("Client", where: "id = ?", whereArgs: [id]);
    return res!.isNotEmpty ? Client.fromJson(res.first) : Null;
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db!.query("Client");
    List<Client> list =
    res.isNotEmpty ? res.map((c) => Client.fromJson(c)).toList() : [];
    return list;
  }

  updateClient(Client newClient) async {
    final db = await database;
    var res = await db!.update("Client", newClient.toJson(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  deleteClient(int id) async {
    final db = await database;
    db!.delete("Client", where: "id = ?", whereArgs: [id]);
  }

  newEvent(Event newEvent) async {
    final db = await database;
    var res = await db?.rawInsert(
        "INSERT Into Event (id,categoryId,title,description,"
            "address,budget,startTime,ownerId)"
            " VALUES (${newEvent.id},${newEvent.categoryId},${newEvent.title},"
            "${newEvent.description},${newEvent.address},${newEvent.budget}, "
            "${newEvent.startTime},${newEvent.ownerId})");
    return res;
  }
  getEvent(int id) async {
    final db = await database;
    var res =await  db?.query("Event", where: "id = ?", whereArgs: [id]);
    return res!.isNotEmpty ? Event.fromJson(res.first) : Null ;
  }
  getAllEvent() async {
    final db = await database;
    var res = await db!.query("Event");
    List<Event> list =
    res.isNotEmpty ? res.map((c) => Event.fromJson(c)).toList() : [];
    return list;
  }
  updateEvent(Event newEvent) async {
    final db = await database;
    var res = await db!.update("Event", newEvent.toJson(),
        where: "id = ?", whereArgs: [newEvent.id]);
    return res;
  }
  deleteEvent(int id) async {
    final db = await database;
    db!.delete("Event", where: "id = ?", whereArgs: [id]);
  }

  getEventsByCategory(int cat) async {
    final db = await database;
    var res = await db!.query("Event", where: "categoryId = ?", whereArgs: [cat]);
    List<Event> list =
    res.isNotEmpty ? res.map((c) => Event.fromJson(c)).toList() : [];
    return list;
  }

  newCategory(EventCategory newCat) async {
    final db = await database;
    var res = await db?.rawInsert(
        "INSERT Into EventCategory (id,title,color)"
            " VALUES (${newCat.id},${newCat.title},${newCat.color}");
    return res;
  }
  getCategory(int id) async {
    final db = await database;
    var res =await  db?.query("EventCategory", where: "id = ?", whereArgs: [id]);
    return res!.isNotEmpty ? EventCategory.fromJson(res.first) : Null ;
  }
  getAllCat() async {
    final db = await database;
    var res = await db!.query("EventCategory");
    List<EventCategory> list =
    res.isNotEmpty ? res.map((c) => EventCategory.fromJson(c)).toList() : [];
    return list;
  }
  updateCat(EventCategory newCat) async {
    final db = await database;
    var res = await db!.update("EventCategory", newCat.toJson(),
        where: "id = ?", whereArgs: [newCat.id]);
    return res;
  }
  deleteCat(int id) async {
    final db = await database;
    db?.delete("EventCategory", where: "id = ?", whereArgs: [id]);
  }

  newPreference(Preference newPref) async {
    final db = await database;
    var res = await db!.rawInsert(
        "INSERT Into Preference (id,title,img)"
            " VALUES (${newPref.id},${newPref.title},${newPref.img}");
    return res;
  }
  getPreference(int id) async {
    final db = await database;
    var res =await  db!.query("Preference", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Preference.fromJson(res.first) : Null ;
  }
  getAllPreference() async {
    final db = await database;
    var res = await db!.query("Preference");
    List<Preference> list =
    res.isNotEmpty ? res.map((c) => Preference.fromJson(c)).toList() : [];
    return list;
  }
  updatePreference(Preference newPref) async {
    final db = await database;
    var res = await db!.update("Preference", newPref.toJson(),
        where: "id = ?", whereArgs: [newPref.id]);
    return res;
  }
  deletePreference(int id) async {
    final db = await database;
    db!.delete("Preference", where: "id = ?", whereArgs: [id]);
  }
}

