import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'User.dart';

class SQLiteHelper {
  initDB() async {
    var versionDB = 1;

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "kopaja.db");
    var db = await openDatabase(path, version: versionDB, onCreate: createUser);
    return db;
  }

  createUser(Database db, int version) async {
    await db
        .execute('CREATE TABLE User(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT)');
  }

  getUser() async {
    var db = await initDB();
    List<Map> list = await db.rawQuery('SELECT * FROM User');

    List<User> users = [];
    for (var l in list) {
      User user;

      var id = l['id'].toString();
      var username = l['username'];
      var email = l['email'];
      user = User(id, username, email);
      users.add(user);
    }
    return users;
  }

  deleteAllUsers() async {
    var db = await initDB();
    String query = 'DELETE FROM User';
    await db.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
  }

  addUser(User user) async {
    var db = await initDB();
    String query = 'INSERT INTO User(username, email) VALUES (\'${user.username}\',\'${user.email}\')';
    await db.transaction((transaction) async {
      return await transaction.rawInsert(query);
    });
  }

  updateUser(User user, String id) async{
    var db = await initDB();
    String query = 'UPDATE User SET username = \'${user.username}\', email = \'${user.email}\' WHERE id = $id';
    await db.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  deleteUser(String id) async{
    var db = await initDB();
    String query = 'DELETE FROM User WHERE id = $id';
    await db.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }
}
