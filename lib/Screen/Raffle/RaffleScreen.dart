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

  bool isData = false;

  @override
  void initState() {
    super.initState();
    Services.getActiveRaffle().then((value) {
      setState(() {
        obj = value[0];
        prizes = value[1];
        persons = value[2];
        isData = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Raffle"),
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
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: AppColor.primary,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateRaffleScreen()),
                          );
                        },
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Text(
                          'Create Raffle',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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
                      );
                    }),
                  ],
                )
              : new CupertinoActivityIndicator(
                  animating: true,
                  radius: 20,
                ),
        ),
      ),
    );
  }
}
