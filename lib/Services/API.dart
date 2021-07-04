import 'package:eraffle/Models/PrizeList.dart';
import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Models/person_model.dart';
import 'package:eraffle/Models/prize_model.dart';
import 'package:eraffle/Services/Database.dart';
import 'package:sqflite/sqflite.dart';

class Services {
  static Database? _db;
  static Future<List<dynamic>> getActiveRaffle() async {
    final db = DataBaseHelper();
    _db = await db.init();
    List models = [];
    List prizes = [];
    List persons = [];
    List<RaffleModel> obj = [];
    List<PrizeModel> prizeList = [];
    List<PersonModel> personList = [];

    var res = await _db!.rawQuery("Select * from Raffle Where status=0");

    obj =
        res.isNotEmpty ? res.map((c) => RaffleModel.fromJson(c)).toList() : [];
    for (var raffle in obj) {
      var result = await _db!
          .rawQuery("Select * from Prize where raffle_id='${raffle.id!}'");
      var personResult = await _db!
          .rawQuery("Select * from Particepent where raffle_id='${raffle.id}'");
      print(personResult);
      prizeList = result.isNotEmpty
          ? result.map((c) => PrizeModel.fromJson(c)).toList()
          : [];
      personList = personResult.isNotEmpty
          ? personResult.map((c) => PersonModel.fromJson(c)).toList()
          : [];
      prizes.add(prizeList);
      persons.add(personList);
    }
    models.add(obj);
    models.add(prizes);
    models.add(persons);
    return models;
  }

  static Future<int> insertRaffle({name, entries}) async {
    final db = DataBaseHelper();
    _db = await db.init();
    DateTime now = DateTime.now();
    var res = await _db!.rawInsert(
        "INSERT INTO Raffle(event_name,created_date,current_entries,initial_entries,status)VALUES('$name','$now','$entries','$entries',0);");
    return res;
  }

  static Future<int> insertPerson(
      {name, id, noOfEntries, prizeList, phoneNo}) async {
    final db = DataBaseHelper();
    _db = await db.init();
    DateTime now = DateTime.now();

    var list = prizeList.join(",");
    print(list);

    var res = await _db!.rawInsert(
        "INSERT INTO Particepent(name,no_of_entries,initial_entries,phone_no,prize_type,raffle_id)VALUES('$name','$noOfEntries' ,'$noOfEntries' , '$phoneNo','$list', '$id');");

    var update = await _db!.rawUpdate(
        "update Raffle set current_entries=current_entries-'$noOfEntries' where id='$id'");
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

  static Future<int> insertSingleRafflePrize({id, prize}) async {
    final db = DataBaseHelper();
    _db = await db.init();
    var res;

    res = await _db!.rawInsert(
        "INSERT INTO Prize(prize_detail,raffle_id)VALUES('$prize','$id');");

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

  static Future<int> updateRaffle({id, entries, name}) async {
    final db = DataBaseHelper();
    _db = await db.init();
    DateTime now = DateTime.now();
    var res = await _db!.rawInsert(
        "UPDATE Raffle SET  event_name = '$name', current_entries =current_entries+ '$entries', initial_entries=initial_entries+'$entries' WHERE id = '$id' ;");
    return res;
  }

  static Future<int> reducePersonEntries({id}) async {
    final db = DataBaseHelper();
    _db = await db.init();
    DateTime now = DateTime.now();
    var res = await _db!.rawInsert(
        "UPDATE Particepent SET   no_of_entries =no_of_entries - 1 WHERE id = '$id' ;");
    return res;
  }

  static Future<int> setPersonEntriesZero({id}) async {
    final db = DataBaseHelper();
    _db = await db.init();
    DateTime now = DateTime.now();
    var res = await _db!.rawInsert(
        "UPDATE Particepent SET   no_of_entries = 0 WHERE id = '$id' ;");
    return res;
  }
}
