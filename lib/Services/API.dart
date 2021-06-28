import 'dart:convert';

import 'package:eraffle/Models/PrizeList.dart';
import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Services/Database.dart';
import 'package:sqflite/sqflite.dart';

class Services {
  // static Database get getDbConnection => _db!;
  static Database? _db;
  static Future<List<RaffleModel>> getActiveRaffle() async {
    final db = DataBaseHelper();
    _db = await db.init();
    List<RaffleModel> obj = [];

    var res = await _db!.rawQuery("Select * from Raffle");

    obj =
        res.isNotEmpty ? res.map((c) => RaffleModel.fromJson(c)).toList() : [];

    return obj;
  }

  static Future<int> insertRaffle({name, entries}) async {
    final db = DataBaseHelper();
    _db = await db.init();
    DateTime now = DateTime.now();
    var res = await _db!.rawInsert(
        "INSERT INTO Raffle(event_name,created_date,current_entries,status)VALUES('$name','$now',$entries,0);");
    return res;
  }

  static Future<int> insertPerson(
      {name, id, noOfEntries, prizeType, phoneNo}) async {
    final db = DataBaseHelper();
    _db = await db.init();
    DateTime now = DateTime.now();
    var res = await _db!.rawInsert(
        "INSERT INTO Particepent(name,no_of_entries,phone_no,prize_type,raffle_id)VALUES('$name','$noOfEntries','$phoneNo','$prizeType', '$id');");
    return res;
  }

  static Future<int> insertRafflePrize({id, prizeList}) async {
    final db = DataBaseHelper();
    _db = await db.init();
    var res;
    for (var prize in prizeList) {
      res = await _db!.rawInsert(
          "INSERT INTO Prize(prize_detail,raffle_id)VALUES('$prize',$id);");
    }
    return res;
  }

  static Future<List<PrizeList>> getRafflePrizelist({id}) async {
    final db = DataBaseHelper();
    _db = await db.init();
    List<PrizeList> obj = [];
    var res = await _db!
        .rawQuery("Select id,prize_detail from Prize where raffle_id='$id'");
    obj = res.isNotEmpty ? res.map((c) => PrizeList.fromJson(c)).toList() : [];
    return obj;
  }
}
