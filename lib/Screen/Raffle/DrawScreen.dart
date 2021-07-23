import 'dart:async';
import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Models/person_model.dart';
import 'package:eraffle/Models/prize_model.dart';
import 'package:eraffle/Models/winner_model.dart';
import 'package:eraffle/Services/API.dart';
import 'package:eraffle/Tabs.dart';
import 'package:eraffle/theme/CustomWidgets.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:group_button/group_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DrawScreen extends StatefulWidget {
  const DrawScreen({
    Key? key,
    required this.obj,
    required this.index,
    required this.prizeList,
    required this.personList,
    required this.winnerList,
  }) : super(key: key);

  final List<RaffleModel> obj;
  final List<PrizeModel> prizeList;
  final List<PersonModel> personList;
  final List<WinnerModel> winnerList;

  final int index;
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  StreamController<int> selected = StreamController<int>();
  bool isLoc = false;
  int spinCount = 0;
  var selectedPerson;
  List<PersonModel> personList = [];
  List<PersonModel> previousList = [];
  List<String> prizes = [];
  int winnerIndex = 0;
  var prizeDetail;
  bool isNullPerson = false;
  String singleWinner = "";

  List<String> singleLockedPrize = [];

  List<int> testList = [];

  List<String> lockPrize = [];
  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    for (var prize in widget.prizeList) {
      prizes.add(prize.prizeDetail!);
    }
      
    
    for (var prize in prizes) {
      int count = 0;
      for (var person in widget.personList) {
        var selectedPrize = person.prizeType!.split(",");
        if (selectedPrize.contains(prize)) {
          count += 1;
          
        }
      }
      if (count <= 1) {
        singleLockedPrize.add(prize);
      }
      for (var winner in widget.winnerList) {
        if (prize == winner.prizeName) {
          lockPrize.add(prize);
          singleLockedPrize.add(prize);
        }
      }
    }


  
    print("prize locked");
    print(singleLockedPrize);
    //print(lockPrize);

    if (lockPrize.contains(prizes[0])) {
      for (int i = 0; i < widget.winnerList.length; i++) {
        if (widget.winnerList[i].prizeName == prizes[0]) {
          winnerIndex = i;
        }
      }

      setState(() {
        isLoc = true;
      });
    }

    for (var person in widget.personList) {
      var selectedPrize = person.prizeType!.split(",");

      if (selectedPrize.contains(prizes[0])) {
        personList.add(person);
      }
    }

    if (personList.length > 1) {
      previousList = List.from(personList);
    }
    print("previous");
    print(previousList.length);

    for (int i = 0; i < personList.length; i++) {
      testList.addAll(List.filled(personList[i].noOfEntries!, i));
    }
    testList.shuffle();
    print(testList);
    prizeDetail = prizes[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.obj[widget.index].eventName!),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (testList.length == 0) {
                          final snackBar = SnackBar(
                            content: Text(
                              'All Participant have Zero Entries',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: AppColor.primary,
                            action: SnackBarAction(
                              label: 'ok',
                              textColor: Colors.white,
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          selectedPerson = Fortune.randomItem(testList);
                          int index = widget.personList.indexWhere((element) =>
                              element.id == personList[selectedPerson].id);
                          print(index);
                          print("selectedPerson");
                          print(widget.personList[index].name);
                          print(widget.personList[index].noOfEntries);

                          print(widget.personList[index].noOfEntries);

                          selected.add(selectedPerson);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text(
                                    "Creation Date",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.obj[widget.index].createdDate!
                                      .substring(0, 16),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Text(
                                      "Current Entries",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.obj[widget.index].initialEntries!
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Text(
                                      "Entries Available",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.obj[widget.index].currentEntries == -1
                                      ? "N/A"
                                      : widget.obj[widget.index].currentEntries
                                          .toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Text(
                                      "Total Participants",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.personList.length.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                          GroupButton(
                            spacing: 5,
                            selectedButton: 0,
                            isRadio: true,
                            direction: Axis.horizontal,
                            onSelected: (index, isSelected) {
                              print("test");
                              setState(() {
                                isLoc = false;
                              });
                              print(previousList.length);
                              personList.clear();
                              prizeDetail = prizes[index];

                              for (var person in widget.personList) {
                                var selectedPrize =
                                    person.prizeType!.split(",");
                                if (selectedPrize.contains(prizes[index])) {
                                  personList.add(person);
                                }
                              }

                              if (personList.length == 0) {
                                setState(() {
                                  isNullPerson = true;
                                  singleWinner = "";
                                  personList = List.from(previousList);
                                  print(previousList.length);
                                  print(personList.length);
                                });
                                final snackBar = SnackBar(
                                  content: Text(
                                    'No Participant for this Prize!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: AppColor.primary,
                                  action: SnackBarAction(
                                    label: 'ok',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      // Some code to undo the change.
                                    },
                                  ),
                                );

                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                if (personList.length < 2) {
                                  setState(() {
                                    isNullPerson = true;
                                    singleWinner = personList[0].name!;

                                    personList = List.from(previousList);
                                    print(previousList.length);
                                  });
                                } else {
                                  if (lockPrize.contains(prizes[index])) {
                                    for (int i = 0;
                                        i < widget.winnerList.length;
                                        i++) {
                                      if (widget.winnerList[i].prizeName ==
                                          prizes[index]) {
                                        winnerIndex = i;
                                      }
                                    }

                                    setState(() {
                                      isLoc = true;
                                    });
                                  }
                                  previousList = List.from(personList);
                                  testList.clear();
                                  for (int i = 0; i < personList.length; i++) {
                                    testList.addAll(List.filled(
                                        personList[i].noOfEntries!, i));
                                  }
                                  testList.shuffle();
                                  print(testList);

                                  setState(() {
                                    isNullPerson = false;
                                    spinCount = 0;
                                  });
                                }
                              }
                            },
                            buttons: prizes,
                            selectedTextStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: AppColor.primary,
                            ),
                            unselectedTextStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            selectedColor: Colors.white,
                            unselectedColor: Colors.grey[300]!,
                            selectedBorderColor: AppColor.secondary,
                            unselectedBorderColor: Colors.grey[500]!,
                            borderRadius: BorderRadius.circular(5.0),
                            selectedShadow: <BoxShadow>[
                              BoxShadow(color: Colors.transparent)
                            ],
                            unselectedShadow: <BoxShadow>[
                              BoxShadow(color: Colors.transparent)
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          personList.length > 1
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.48,
                                  child: FortuneWheel(
                                    selected: selected.stream,
                                    animateFirst: false,
                                    onAnimationEnd: () {
                                      int index = widget.personList.indexWhere(
                                          (element) =>
                                              element.id ==
                                              personList[selectedPerson].id);

                                      widget.personList[index].noOfEntries =
                                          widget.personList[index]
                                                  .noOfEntries! -
                                              1;
                                      Services.reducePersonEntries(
                                          id: widget.personList[index].id);

                                      // Services.insertRaffleHistory(
                                      //   raffle_id: widget.obj[widget.index].id,
                                      //   person_id: widget.personList[index].id,
                                      //   prize: prizeDetail,
                                      //   current_entries: widget
                                      //       .obj[widget.index].currentEntries,
                                      // );

                                      setState(() {
                                        spinCount += 1;
                                      });
                                    },
                                    items: [
                                      for (var it in personList)
                                        FortuneItem(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 60),
                                                  child: Text(
                                                    it.name!,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Text(
                                                    it.noOfEntries!.toString()),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              : Container(
                                  child: Text("No Participant Enrolled."),
                                ),
                          singleLockedPrize.length == prizes.length
                              ? Container(
                                  width: fullWidth(context) - 100,
                                  margin: EdgeInsets.only(top: 50),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      primary: AppColor.primary,
                                      backgroundColor: AppColor.secondary,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                    ),
                                    child: Text(
                                      'Close Raffle',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              new CupertinoAlertDialog(
                                                title: Text(
                                                    'Confirm Close Raffle'),
                                                content:
                                                    Text("it's not reversible"),
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
                                                      Services.closeRaffle(
                                                              id: widget
                                                                  .obj[widget
                                                                      .index]
                                                                  .id)
                                                          .then((value) {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Tabs(),
                                                          ),
                                                        );
                                                      });

                                                      // Navigator.of(
                                                      //   context,
                                                      // ).pop(true);
                                                    },
                                                    child: Text('Yes'),
                                                    style:
                                                        TextButton.styleFrom(),
                                                  ),
                                                ],
                                              ));
                                    },
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              isLoc
                  ? Positioned(
                      top: MediaQuery.of(context).size.height * 0.34,
                      bottom: MediaQuery.of(context).size.height * 0.12,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, left: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: MediaQuery.of(context).size.height - 100,
                          width: MediaQuery.of(context).size.width - 20,
                          child: Container(
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Align(
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      height: 200,
                                      width: 200,
                                      child:
                                          Image.asset("assets/images/won.gif"),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Winner:",
                                                style: TextStyle(
                                                  color: AppColor.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            widget
                                                .winnerList[winnerIndex].name!,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Prize",
                                                style: TextStyle(
                                                  color: AppColor.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            widget.winnerList[winnerIndex]
                                                .prizeName!,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Initial Entries",
                                                style: TextStyle(
                                                  color: AppColor.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            widget.winnerList[winnerIndex]
                                                .initialEntries
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Current Entries",
                                                style: TextStyle(
                                                  color: AppColor.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            widget.winnerList[winnerIndex]
                                                .noOfEntries
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 250.0, minHeight: 50.0),
                                        margin: EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColor.primary,
                                          ),
                                          onPressed: () {
                                            int index = widget.personList
                                                .indexWhere((element) =>
                                                    element.id ==
                                                    personList[selectedPerson]
                                                        .id);
                                            setState(() {
                                              widget.personList[index]
                                                  .noOfEntries = 0;
                                            });
                                            Services.setPersonEntriesZero(
                                                id: widget
                                                    .personList[index].id);
                                            final snackBar = SnackBar(
                                              content: Text(
                                                'Entries has been Set to Zero',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              backgroundColor: AppColor.primary,
                                              action: SnackBarAction(
                                                label: 'ok',
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  // Some code to undo the change.
                                                },
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'Remove Remaining Entries ',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 250.0, minHeight: 50.0),
                                        margin: EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColor.primary,
                                          ),
                                          onPressed: () {
                                            // int index = widget.personList
                                            //     .indexWhere((element) =>
                                            //         element.id ==
                                            //         personList[selectedPerson]
                                            //             .id);
                                            setState(() {
                                              isLoc = false;
                                              lockPrize.remove(prizeDetail);
                                               singleLockedPrize.remove(prizeDetail);
                                              widget.winnerList
                                                  .removeAt(winnerIndex);
                                            });

                                            Services.unlockWinner(
                                              raffleId:
                                                  widget.obj[widget.index].id,
                                              prize: prizeDetail,
                                            );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'Unlock',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.lock_open,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 250.0, minHeight: 50.0),
                                        margin: EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColor.primary,
                                          ),
                                          onPressed: () {
                                            // int index = widget.personList
                                            //     .indexWhere((element) =>
                                            //         element.id ==
                                            //         personList[selectedPerson]
                                            //             .id);
                                            sendEmail(
                                                email: "rizwanch173@gmail.com",
                                                name: widget
                                                    .winnerList[winnerIndex]
                                                    .name!,
                                                prize: prizeDetail,
                                                dateOfWin: widget
                                                    .winnerList[winnerIndex]
                                                    .date!,
                                                raffleName: widget
                                                    .obj[widget.index]
                                                    .eventName,
                                                dateOfRaffle: widget
                                                    .obj[widget.index]
                                                    .createdDate);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'Send Email',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.email_outlined,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              spinCount > 0
                  ? Positioned(
                      top: MediaQuery.of(context).size.height * 0.34,
                      bottom: MediaQuery.of(context).size.height * 0.12,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, left: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: MediaQuery.of(context).size.height - 100,
                          width: MediaQuery.of(context).size.width - 20,
                          child: Container(
                            child: Stack(
                              children: [
                                // Positioned(
                                //   right: 0,
                                //   child: GestureDetector(
                                //     onTap: () {
                                //       setState(() {
                                //         isNullPerson = false;
                                //         spinCount = 0;
                                //       });
                                //
                                //       print(previousList.length);
                                //       personList.clear();
                                //
                                //       for (var person in widget.personList) {
                                //         var selectedPrize =
                                //             person.prizeType!.split(",");
                                //         if (selectedPrize
                                //             .contains(prizeDetail)) {
                                //           personList.add(person);
                                //         }
                                //       }
                                //
                                //       if (personList.length == 0) {
                                //         setState(() {
                                //           isNullPerson = true;
                                //           singleWinner = "";
                                //           personList = List.from(previousList);
                                //           print(previousList.length);
                                //           print(personList.length);
                                //         });
                                //         final snackBar = SnackBar(
                                //           content: Text(
                                //             'No Participant for this Prize!',
                                //             style: TextStyle(
                                //               color: Colors.white,
                                //               fontWeight: FontWeight.bold,
                                //             ),
                                //           ),
                                //           backgroundColor: AppColor.primary,
                                //           action: SnackBarAction(
                                //             label: 'ok',
                                //             textColor: Colors.white,
                                //             onPressed: () {
                                //               // Some code to undo the change.
                                //             },
                                //           ),
                                //         );
                                //
                                //         // Find the ScaffoldMessenger in the widget tree
                                //         // and use it to show a SnackBar.
                                //         ScaffoldMessenger.of(context)
                                //             .showSnackBar(snackBar);
                                //       } else {
                                //         if (personList.length < 2) {
                                //           setState(() {
                                //             isNullPerson = true;
                                //             singleWinner = personList[0].name!;
                                //
                                //             personList =
                                //                 List.from(previousList);
                                //             print(previousList.length);
                                //           });
                                //         } else {
                                //           previousList = List.from(personList);
                                //           testList.clear();
                                //           for (int i = 0;
                                //               i < personList.length;
                                //               i++) {
                                //             testList.addAll(List.filled(
                                //                 personList[i].noOfEntries!, i));
                                //           }
                                //           testList.shuffle();
                                //           print(testList);
                                //
                                //           setState(() {
                                //             isNullPerson = false;
                                //             spinCount = 0;
                                //           });
                                //         }
                                //       }
                                //     },
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(2.0),
                                //       child: Icon(
                                //         Icons.cancel,
                                //         size: 30,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Positioned.fill(
                                  child: Align(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      height: 200,
                                      width: 200,
                                      child:
                                          Image.asset("assets/images/won.gif"),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Winner:",
                                                style: TextStyle(
                                                  color: AppColor.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            personList[selectedPerson].name!,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Prize",
                                                style: TextStyle(
                                                  color: AppColor.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            prizeDetail,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Initial Entries",
                                                style: TextStyle(
                                                  color: AppColor.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            personList[selectedPerson]
                                                .initialEntries!
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Current Entries",
                                                style: TextStyle(
                                                  color: AppColor.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            personList[selectedPerson]
                                                .noOfEntries!
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 250.0, minHeight: 50.0),
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 2.0,
                                                offset: Offset(0.0, 0.75))
                                          ],
                                          color: AppColor.primary,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Text(
                                                    widget
                                                        .personList[
                                                            selectedPerson]
                                                        .phoneNo!,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await launch(
                                                            'sms:${widget.personList[selectedPerson].phoneNo}');
                                                      },
                                                      child: Icon(
                                                        Icons.message,
                                                        color: Colors.white,
                                                        size: 25,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await launch(
                                                            'tel:${widget.personList[selectedPerson].phoneNo}');
                                                      },
                                                      child: Icon(
                                                        Icons.call,
                                                        color: Colors.white,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 250.0, minHeight: 50.0),
                                        margin: EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColor.primary,
                                          ),
                                          onPressed: () {
                                            int index = widget.personList
                                                .indexWhere((element) =>
                                                    element.id ==
                                                    personList[selectedPerson]
                                                        .id);
                                            setState(() {
                                              widget.personList[index]
                                                  .noOfEntries = 0;
                                            });
                                            Services.setPersonEntriesZero(
                                                id: widget
                                                    .personList[index].id);
                                            final snackBar = SnackBar(
                                              content: Text(
                                                'Entries has been Set to Zero',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              backgroundColor: AppColor.primary,
                                              action: SnackBarAction(
                                                label: 'ok',
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  // Some code to undo the change.
                                                },
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'Remove Remaining Entries ',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 250.0, minHeight: 50.0),
                                        margin: EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColor.primary,
                                          ),
                                          onPressed: () {
                                            int index = widget.personList
                                                .indexWhere((element) =>
                                                    element.id ==
                                                    personList[selectedPerson]
                                                        .id);
                                            DateTime now = DateTime.now();
                                            WinnerModel win = new WinnerModel(
                                              name: personList[selectedPerson]
                                                  .name,
                                              prizeName: prizeDetail,
                                              initialEntries:
                                                  personList[selectedPerson]
                                                      .initialEntries,
                                              noOfEntries:
                                                  personList[selectedPerson]
                                                      .noOfEntries,
                                              lock: 1,
                                              date: now.toString(),
                                            );

                                            setState(() {
                                              widget.winnerList.add(win);
                                              lockPrize.add(prizeDetail);
                                              singleLockedPrize
                                                  .add(prizeDetail);
                                            });

                                            Services.insertRaffleHistory(
                                              raffle_id:
                                                  widget.obj[widget.index].id,
                                              person_id:
                                                  widget.personList[index].id,
                                              prize: prizeDetail,
                                              current_entries: widget
                                                  .obj[widget.index]
                                                  .currentEntries,
                                            );

                                            final snackBar = SnackBar(
                                              content: Text(
                                                'Winner has been Locked',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              backgroundColor: AppColor.primary,
                                              action: SnackBarAction(
                                                label: 'ok',
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  // Some code to undo the change.
                                                },
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'Lock Winner',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.lock,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              isNullPerson
                  ? Positioned(
                      top: MediaQuery.of(context).size.height * 0.27,
                      bottom: MediaQuery.of(context).size.height * 0.20,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: MediaQuery.of(context).size.height - 100,
                          width: MediaQuery.of(context).size.width - 20,
                          child: Stack(
                            children: [
                              // Positioned(
                              //   right: 0,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       setState(() {
                              //         isNullPerson = false;
                              //         spinCount = 0;
                              //       });
                              //
                              //       print(previousList.length);
                              //       personList.clear();
                              //
                              //       for (var person in widget.personList) {
                              //         var selectedPrize =
                              //             person.prizeType!.split(",");
                              //         if (selectedPrize.contains(prizeDetail)) {
                              //           personList.add(person);
                              //         }
                              //       }
                              //
                              //       if (personList.length == 0) {
                              //         setState(() {
                              //           isNullPerson = true;
                              //           singleWinner = "";
                              //           personList = List.from(previousList);
                              //           print(previousList.length);
                              //           print(personList.length);
                              //         });
                              //         final snackBar = SnackBar(
                              //           content: Text(
                              //             'No Participant for this Prize!',
                              //             style: TextStyle(
                              //               color: Colors.white,
                              //               fontWeight: FontWeight.bold,
                              //             ),
                              //           ),
                              //           backgroundColor: AppColor.primary,
                              //           action: SnackBarAction(
                              //             label: 'ok',
                              //             textColor: Colors.white,
                              //             onPressed: () {
                              //               // Some code to undo the change.
                              //             },
                              //           ),
                              //         );
                              //
                              //         // Find the ScaffoldMessenger in the widget tree
                              //         // and use it to show a SnackBar.
                              //         ScaffoldMessenger.of(context)
                              //             .showSnackBar(snackBar);
                              //       } else {
                              //         if (personList.length < 2) {
                              //           setState(() {
                              //             isNullPerson = true;
                              //             singleWinner = personList[0].name!;
                              //
                              //             personList = List.from(previousList);
                              //             print(previousList.length);
                              //           });
                              //         } else {
                              //           previousList = List.from(personList);
                              //           testList.clear();
                              //           for (int i = 0;
                              //               i < personList.length;
                              //               i++) {
                              //             testList.addAll(List.filled(
                              //                 personList[i].noOfEntries!, i));
                              //           }
                              //           testList.shuffle();
                              //           print(testList);
                              //
                              //           setState(() {
                              //             isNullPerson = false;
                              //             spinCount = 0;
                              //           });
                              //         }
                              //       }
                              //     },
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(2.0),
                              //       child: Icon(
                              //         Icons.cancel,
                              //         size: 30,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: singleWinner == ""
                                          ? Text(
                                              "This prize has no person enrolled.",
                                              style: TextStyle(
                                                color: AppColor.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            )
                                          : Text(
                                              "This Prize only has " +
                                                  singleWinner +
                                                  " Enrolled.",
                                              style: TextStyle(
                                                color: AppColor.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                    ),
                                    height: 200,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> sendEmail({
    required email,
    required name,
    required prize,
    required dateOfWin,
    required raffleName,
    required dateOfRaffle,
  }) async {
    final param = {
      "email": email,
      "winer_name": name,
      "prize": prize,
      "date_of_Win": dateOfWin,
      "raffle_name": raffleName,
      "date_of_raffle": dateOfRaffle,
    };

    final snackBar = SnackBar(
      content: Text(
        'Email will receive shortly',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColor.primary,
      action: SnackBarAction(
        label: 'ok',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    http.Response response =
        await apiRequest("https://bwsgroupco.com/Webservices/send_mail", param);
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      print("Sent");

      return true;
    } else {
      print("Error");
      return false;
    }
  }
}

Future<http.Response> apiRequest(String url, Map jsonMap) async {
  var body = jsonEncode(jsonMap);
  var response = await http.post(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    },
    body: body,
  );
  return response;
}
