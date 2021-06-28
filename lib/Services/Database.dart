// import 'dart:async';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
//
// class DBProvider {
//   DBProvider._();
//
//   static final DBProvider db = DBProvider._();
//
//   static Database? _database;
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//
//     // if _database is null we instantiate it
//     _database = await initDB();
//     return _database!;
//   }
//
//   initDB() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     print("x1");
//     print(documentsDirectory.path);
//     String path = join(documentsDirectory.path, "assets/Raffle.db");
//
//     print("xxx");
//     print(path);
//     return await openDatabase(path, version: 1, onOpen: (db) {});
//   }
// }

/// delete the db, create the folder and returnes its path
// Future<String> initDeleteDb(String dbName) async {
//   final databasePath = await getDatabasesPath();
//   // print(databasePath);
//   final path = join(databasePath, dbName);
//
//   // make sure the folder exists
//   // ignore: avoid_slow_async_io
//   if (await Directory(dirname(path)).exists()) {
//     await deleteDatabase(path);
//   } else {
//     try {
//       await Directory(dirname(path)).create(recursive: true);
//     } catch (e) {
//       print(e);
//     }
//   }
//   return path;
// }

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DataBaseHelper {
  Database? _db;

  Future<Database> init() async {
    print("object");
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();

    String dbpath = path.join(applicationDirectory.path, "Raffle.db");

    bool dbRaffleInternal = await io.File(dbpath).exists();

    if (!dbRaffleInternal) {
      // Copy from asset
      ByteData data =
          await rootBundle.load(path.join("assets/db", "Raffle.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(dbpath).writeAsBytes(bytes, flush: true);
    }

    this._db = await openDatabase(dbpath, onConfigure: (db) async {
      await db.execute("PRAGMA foreign_keys = ON");
    });
    return this._db!;
  }
}
