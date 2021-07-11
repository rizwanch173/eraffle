import 'package:eraffle/Models/person_model.dart';
import 'package:eraffle/Models/prize_model.dart';
import 'package:eraffle/Screen/Raffle/RaffleCard.dart';
import 'package:eraffle/Services/API.dart';
import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Screen/Raffle/Create.dart';
import 'package:eraffle/theme/CustomWidgets.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RaffleScreen extends StatefulWidget {
  const RaffleScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<RaffleScreen> {
  @override
  List<RaffleModel> obj = [];
  List prizes = [];
  List persons = [];
  List winners = [];

  bool isData = false;

  @override
  void initState() {
    super.initState();
    Services.getRaffles(which: 0).then((value) {
      obj = value[0];
      prizes = value[1];
      persons = value[2];
    });

    Services.getLockWinner().then((value) {
      print("winner");
      print(value[3]);
      winners = value[3];
      setState(() {
        isData = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Active Raffle"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: isData
              ? Column(
                  children: [
                    Container(
                      width: fullWidth(context),
                      margin: EdgeInsets.symmetric(vertical: 35),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: AppColor.primary,
                          backgroundColor: AppColor.secondary,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                        ),
                        child: Text(
                          'Create Raffle',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateRaffleScreen()),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ...List.generate(obj.length, (index) {
                      return RaffleCard(
                          index: index,
                          obj: obj,
                          prizes: prizes,
                          persons: persons,
                          winner: winners);
                    }),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2 - 100),
                    child: new CupertinoActivityIndicator(
                      animating: true,
                      radius: 20,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
