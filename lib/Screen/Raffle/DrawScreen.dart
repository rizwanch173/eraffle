import 'dart:async';
import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Models/person_model.dart';
import 'package:eraffle/Models/prize_model.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:group_button/group_button.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({
    Key? key,
    required this.obj,
    required this.index,
    required this.prizeList,
    required this.personList,
  }) : super(key: key);

  final List<RaffleModel> obj;
  final List<PrizeModel> prizeList;
  final List<PersonModel> personList;

  final int index;
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  StreamController<int> selected = StreamController<int>();

  int spinCount = 0;
  var selectedPerson;
  List<PersonModel> personList = [];
  List<PersonModel> perviousList = [];
  List<String> Prizes = [];
  var prizeDetail;
  bool isNullPerson = false;

  List<int> testlist = [];
  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    print(testlist);

    for (var prize in widget.prizeList) {
      Prizes.add(prize.prizeDetail!);
    }
    for (var person in widget.personList) {
      print(person.name);
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
      body: Container(
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
                      selectedPerson = Fortune.randomItem(testlist);
                      print(selectedPerson);
                      selected.add(selectedPerson);
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
                          padding: const EdgeInsets.all(8.0),
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
                                widget.obj[widget.index].currentEntries!
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
                              var selectedPrize = person.prizeType!.split(",");
                              if (selectedPrize.contains(Prizes[index])) {
                                personList.add(person);
                              }
                            }

                            if (personList.length == 0) {
                              setState(() {
                                isNullPerson = true;
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
                                  isNullPerson = false;
                                  spinCount = 2;
                                  selectedPerson = 0;
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

                          /// [List<int>] after 2.2.1 version
                          selectedTextStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          unselectedTextStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          selectedColor: Colors.white,
                          unselectedColor: Colors.grey[300]!,
                          selectedBorderColor: Colors.red,
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
                                    setState(() {
                                      spinCount += 1;
                                    });
                                  },
                                  items: [
                                    for (var it in personList)
                                      FortuneItem(child: Text(it.name!)),
                                  ],
                                ),
                              )
                            : Container(
                                child: Text("test"),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            spinCount > 0
                ? Positioned(
                    top: 200,
                    bottom: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
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
                                    child: Image.asset("assets/images/won.gif"),
                                  ),
                                ),
                              ),
                              Column(
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            personList[selectedPerson].name!,
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
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
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
                                  )
                                ],
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "This Prize have no Person Enrolled !",
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
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
