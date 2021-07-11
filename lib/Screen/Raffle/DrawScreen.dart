import 'dart:async';
import 'dart:developer';
import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Models/person_model.dart';
import 'package:eraffle/Models/prize_model.dart';
import 'package:eraffle/Models/winner_model.dart';
import 'package:eraffle/Screen/Raffle/RaffleScreen.dart';
import 'package:eraffle/Services/API.dart';
import 'package:eraffle/Tabs.dart';
import 'package:eraffle/theme/CustomWidgets.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:group_button/group_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List<PersonModel> perviousList = [];
  List<String> Prizes = [];
  int winnerIndex = 0;
  var prizeDetail;
  bool isNullPerson = false;
  String SingleWinner = "";

  List<int> testlist = [];

  List<String> lockprize = [];
  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    for (var prize in widget.prizeList) {
      Prizes.add(prize.prizeDetail!);
    }

    for (var prize in Prizes) {
      for (var winner in widget.winnerList) {
        if (prize == winner.prizeName) {
          lockprize.add(prize);
        }
      }
    }
    print("prize lock");
    print(lockprize);

    if (lockprize.contains(Prizes[0])) {
      for (int i = 0; i < widget.winnerList.length; i++) {
        if (widget.winnerList[i].prizeName == Prizes[0]) {
          winnerIndex = i;
        }
      }

      setState(() {
        isLoc = true;
      });
    }

    for (var person in widget.personList) {
      var selectedPrize = person.prizeType!.split(",");

      if (selectedPrize.contains(Prizes[0])) {
        personList.add(person);
      }
    }

    if (personList.length > 1) {
      perviousList = List.from(personList);
    }
    print("previous");
    print(perviousList.length);

    for (int i = 0; i < personList.length; i++) {
      testlist.addAll(List.filled(personList[i].noOfEntries!, i));
    }
    testlist.shuffle();
    print(testlist);
    prizeDetail = Prizes[0];
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
                        if (testlist.length == 0) {
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
                          selectedPerson = Fortune.randomItem(testlist);
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
                              print(perviousList.length);
                              personList.clear();
                              prizeDetail = Prizes[index];

                              for (var person in widget.personList) {
                                var selectedPrize =
                                    person.prizeType!.split(",");
                                if (selectedPrize.contains(Prizes[index])) {
                                  personList.add(person);
                                }
                              }

                              if (personList.length == 0) {
                                setState(() {
                                  isNullPerson = true;
                                  SingleWinner = "";
                                  personList = List.from(perviousList);
                                  print(perviousList.length);
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
                                    SingleWinner = personList[0].name!;

                                    personList = List.from(perviousList);
                                    print(perviousList.length);
                                  });
                                } else {
                                  perviousList = List.from(personList);
                                  testlist.clear();
                                  for (int i = 0; i < personList.length; i++) {
                                    testlist.addAll(List.filled(
                                        personList[i].noOfEntries!, i));
                                  }
                                  testlist.shuffle();
                                  print(testlist);

                                  setState(() {
                                    isNullPerson = false;
                                    spinCount = 0;
                                  });
                                }
                              }
                            },
                            buttons: Prizes,
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
                          personList.length > 1
                              ? Expanded(
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
                                  child: Text("No Participant Enrolled"),
                                ),
                          Container(
                            width: fullWidth(context) - 100,
                            margin: EdgeInsets.only(bottom: 80),
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
                                          title: Text('Confirm Close Raffle'),
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
                                                Services.closeRaffle(
                                                        id: widget
                                                            .obj[widget.index]
                                                            .id)
                                                    .then((value) {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Tabs(),
                                                    ),
                                                  );
                                                });

                                                // Navigator.of(
                                                //   context,
                                                // ).pop(true);
                                              },
                                              child: Text('Yes'),
                                              style: TextButton.styleFrom(),
                                            ),
                                          ],
                                        ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              isLoc
                  ? Positioned(
                      top: 200,
                      bottom: 50,
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                widget.winnerList[winnerIndex]
                                                    .name!,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                widget.winnerList[winnerIndex]
                                                    .prizeName!,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                widget.winnerList[winnerIndex]
                                                    .initialEntries
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                widget.winnerList[winnerIndex]
                                                    .noOfEntries
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
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
                                                      fontSize: 15,
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
                      top: 200,
                      bottom: 50,
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
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isNullPerson = false;
                                        spinCount = 0;
                                      });

                                      print(perviousList.length);
                                      personList.clear();

                                      for (var person in widget.personList) {
                                        var selectedPrize =
                                            person.prizeType!.split(",");
                                        if (selectedPrize
                                            .contains(prizeDetail)) {
                                          personList.add(person);
                                        }
                                      }

                                      if (personList.length == 0) {
                                        setState(() {
                                          isNullPerson = true;
                                          SingleWinner = "";
                                          personList = List.from(perviousList);
                                          print(perviousList.length);
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
                                            SingleWinner = personList[0].name!;

                                            personList =
                                                List.from(perviousList);
                                            print(perviousList.length);
                                          });
                                        } else {
                                          perviousList = List.from(personList);
                                          testlist.clear();
                                          for (int i = 0;
                                              i < personList.length;
                                              i++) {
                                            testlist.addAll(List.filled(
                                                personList[i].noOfEntries!, i));
                                          }
                                          testlist.shuffle();
                                          print(testlist);

                                          setState(() {
                                            isNullPerson = false;
                                            spinCount = 0;
                                          });
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(
                                        Icons.cancel,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                personList[selectedPerson]
                                                    .name!,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                prizeDetail,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                personList[selectedPerson]
                                                    .initialEntries!
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                personList[selectedPerson]
                                                    .noOfEntries!
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
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
                                                      fontSize: 15,
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
                      top: 200,
                      bottom: 50,
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
                              Positioned(
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isNullPerson = false;
                                      spinCount = 0;
                                    });

                                    print(perviousList.length);
                                    personList.clear();

                                    for (var person in widget.personList) {
                                      var selectedPrize =
                                          person.prizeType!.split(",");
                                      if (selectedPrize.contains(prizeDetail)) {
                                        personList.add(person);
                                      }
                                    }

                                    if (personList.length == 0) {
                                      setState(() {
                                        isNullPerson = true;
                                        SingleWinner = "";
                                        personList = List.from(perviousList);
                                        print(perviousList.length);
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
                                          SingleWinner = personList[0].name!;

                                          personList = List.from(perviousList);
                                          print(perviousList.length);
                                        });
                                      } else {
                                        perviousList = List.from(personList);
                                        testlist.clear();
                                        for (int i = 0;
                                            i < personList.length;
                                            i++) {
                                          testlist.addAll(List.filled(
                                              personList[i].noOfEntries!, i));
                                        }
                                        testlist.shuffle();
                                        print(testlist);

                                        setState(() {
                                          isNullPerson = false;
                                          spinCount = 0;
                                        });
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.cancel,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: SingleWinner == ""
                                          ? Text(
                                              "This prize has no person enrolled !",
                                              style: TextStyle(
                                                color: AppColor.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            )
                                          : Text(
                                              "This prize has only " +
                                                  SingleWinner +
                                                  " enrolled so consider as Winner.",
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
}
