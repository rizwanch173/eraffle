import 'package:eraffle/Services/API.dart';
import 'package:eraffle/Tabs.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'AddPerson.dart';

class CreateRaffleScreen extends StatefulWidget {
  const CreateRaffleScreen({Key? key}) : super(key: key);

  @override
  _CreateRaffleScreenState createState() => _CreateRaffleScreenState();
}

class _CreateRaffleScreenState extends State<CreateRaffleScreen> {
  TextEditingController _prizeController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _entryController = new TextEditingController();
  List<String> prizeList = [];

  var _formKey = GlobalKey<FormState>();
  int? insertedVal;

  void addPrize({String? prize}) {
    if (!prizeList.contains(prize))
      setState(() {
        prizeList.add(prize!);
      });
  }

  void removePrize({String? prize}) {
    if (prizeList.contains(prize))
      setState(() {
        prizeList.remove(prize);
      });
  }

  double btnWidth = 0;
  double btnHeight = 0;
  bool isInserted = false;
  bool isNa = false;

  Color naColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Raffle"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    readOnly: isInserted,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                      labelText: "Event Name",
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: "Enter Event Name",
                      hintStyle: TextStyle(color: Colors.grey),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SvgPicture.asset(
                          "assets/Icons/calendar.svg",
                          height: 5,
                          width: 5,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: AppColor.primary)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide: BorderSide(color: AppColor.primary)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Event Name';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          controller: _prizeController,
                          readOnly: isInserted,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                          ),
                          decoration: InputDecoration(
                            labelText: "Prize",
                            labelStyle: TextStyle(color: Colors.grey),
                            hintText: "Enter prize details",
                            hintStyle: TextStyle(color: Colors.grey),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: SvgPicture.asset(
                                "assets/Icons/trophy.svg",
                                height: 5,
                                width: 5,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                borderSide:
                                    BorderSide(color: AppColor.primary)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                                borderSide:
                                    BorderSide(color: AppColor.primary)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                          validator: (value) {
                            if (prizeList.length == 0) {
                              return 'At least add one Prize';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (!isInserted) {
                          if (_prizeController.text != "") {
                            addPrize(prize: _prizeController.text);
                            _prizeController.clear();
                          }
                        }
                      },
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.secondary,
                        onSurface: AppColor.primary,
                        shadowColor: AppColor.primary,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
                ...List.generate(prizeList.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              prizeList[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                if (!isInserted)
                                  removePrize(prize: prizeList[index]);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: AppColor.white,
                              ))
                        ],
                      ),
                    ),
                  );
                }),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    controller: _entryController,
                    readOnly: isNa,
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                      signed: true,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: "Entries available",
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: "Enter Entries available",
                      hintStyle: TextStyle(color: Colors.grey),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isNa = !isNa;
                              if (isNa) {
                                naColor = AppColor.secondary;
                              } else {
                                naColor = Colors.grey;
                              }
                            });
                          },
                          child: Text(
                            'N/A',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: naColor,
                            onSurface: AppColor.primary,
                            shadowColor: AppColor.primary,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: AppColor.primary)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide: BorderSide(color: AppColor.primary)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    validator: (value) {
                      if (isNa == false) {
                        if (value!.isEmpty) return 'Enter Entries available';
                      } else if (isNa == false) {
                        if (int.parse(value!) < 1)
                          return 'At least add 1 Entry';
                      }
                      return null;
                    },
                  ),
                ),
                isInserted == false
                    ? TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          primary: AppColor.primary,
                          backgroundColor: AppColor.secondary,
                          padding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 12),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            Services.insertRaffle(
                              name: _nameController.text,
                              entries: _entryController.text,
                              isNa: isNa,
                            ).then((value) {
                              insertedVal = value;
                              Services.insertRafflePrize(
                                  id: value, prizeList: prizeList);
                            }).then((value) {
                              setState(() {
                                isInserted = true;
                                btnWidth = 300;
                                btnHeight = 45;
                              });
                            });
                          } //Navigator.pop(context);
                        },
                        child: Text(
                          'Create',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : Container(),
                isInserted
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Tabs()),
                                );
                              },
                              child: RichText(
                                text: new TextSpan(
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: "Raffle has been created",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    new TextSpan(
                                      text: "  Go Back",
                                      style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  width: btnWidth,
                  height: btnHeight,
                  color: Colors.white,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      primary: AppColor.primary,
                      backgroundColor: AppColor.secondary,
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                    ),
                    onPressed: () async {
                      //Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPersonScreen(
                                id: insertedVal,
                                totalEntries: isNa
                                    ? -1
                                    : int.parse(_entryController.text))),
                      );
                    },
                    child: Text(
                      'Add Participant',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
