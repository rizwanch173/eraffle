import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Screen/History/HistoryCard.dart';
import 'package:eraffle/Services/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<RaffleModel> obj = [];
  List prizes = [];
  List persons = [];
  List winners = [];

  bool isData = false;

  @override
  void initState() {
    Services.getClosedRaffles().then((value) {
      setState(() {
        obj = value[0];
        prizes = value[1];
        persons = value[2];
        winners = value[3];
        isData = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Closed Raffle"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 10, left: 10),
          child: isData
              ? Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ...List.generate(obj.length, (index) {
                      return Dismissible(
                        confirmDismiss: (direction) {
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text('Confirm Delete Raffle'),
                                content: Text("it's not reversible"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pop(false);
                                    },
                                    child: Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Services.deleteRaffle(id: obj[index].id);
                                      setState(() {
                                        obj.removeAt(index);
                                      });

                                      Navigator.of(
                                        context,
                                        // rootNavigator: true,
                                      ).pop(true);
                                    },
                                    child: Text('Yes'),
                                    style: TextButton.styleFrom(),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {},
                        background: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFE6E6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Spacer(),
                                SvgPicture.asset(
                                  "assets/Icons/Trash.svg",
                                  height: 45,
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: obj.length > 0
                            ? HistoryCard(
                                index: index,
                                obj: obj,
                                prizes: prizes,
                                persons: persons,
                                winners: winners,
                              )
                            : Container(),
                      );
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
