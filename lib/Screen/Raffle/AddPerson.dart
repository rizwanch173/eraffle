import 'package:eraffle/Models/PrizeList.dart';
import 'package:eraffle/Screen/Raffle/RaffleScreen.dart';
import 'package:eraffle/Services/API.dart';
import 'package:eraffle/Tabs.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';

class AddPersonScreen extends StatefulWidget {
  AddPersonScreen({Key? key, this.id, required this.totalEntries})
      : super(key: key);
  final id;
  int totalEntries;

  @override
  _AddPersonScreenState createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  TextEditingController _prizeController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _entryController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  List<String> selectedList = [];

  var _formKey = GlobalKey<FormState>();
  List<String> prizes = [];
  bool haveData = false;
  double btnWidth = 0.0;
  double btnHeight = 0.0;
  bool isInserted = false;
  var _chosenValue;

  void addPrize({String? prize}) {
    if (!selectedList.contains(prize))
      setState(() {
        selectedList.add(prize!);
      });
  }

  void removePrize({String? prize}) {
    if (selectedList.contains(prize))
      setState(() {
        selectedList.remove(prize);
      });
  }

  List<PrizeList> obj = [];

  @override
  void initState() {
    Services.getRafflePrizelist(id: widget.id).then((value) {
      setState(() {
        haveData = true;
        obj = value;
        for (var prize in obj) {
          prizes.add(prize.prizeDetail!);
        }
        selectedList.add(prizes[0]);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Person"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
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
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                      labelText: "Person Name",
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: "Enter Person Name",
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
                        return 'Enter Person Name';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    controller: _entryController,
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
                      labelText: "No of Entry",
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: "Enter No of Entry",
                      hintStyle: TextStyle(color: Colors.grey),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SvgPicture.asset(
                          "assets/Icons/countdown.svg",
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
                        return 'Enter No of Entry';
                      } else if (int.parse(value) > widget.totalEntries) {
                        return 'Must be less then Total Raffle Entries (${widget.totalEntries})';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: "Enter Phone Number",
                      hintStyle: TextStyle(color: Colors.grey),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Icon(
                          Icons.phone_android_rounded,
                          size: 25,
                          color: Color(0xffFFE278),
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
                        return 'Enter Phone Number';
                      }
                      return null;
                    },
                  ),
                ),
                haveData
                    ? Row(
                        children: [
                          GroupButton(
                            spacing: 5,
                            selectedButtons: [0],
                            isRadio: false,
                            direction: Axis.horizontal,
                            onSelected: (index, isSelected) {
                              if (isSelected) {
                                addPrize(prize: prizes[index]);
                              } else {
                                removePrize(prize: prizes[index]);
                              }
                              setState(() {});
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
                        ],
                      )
                    : Container(),
                isInserted
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Person has been Added Fill to add more.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
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
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        Services.insertPerson(
                          name: _nameController.text,
                          noOfEntries: _entryController.text,
                          phoneNo: _phoneController.text,
                          prizeList: selectedList,
                          id: widget.id,
                        ).then((value) {
                          setState(() {
                            isInserted = true;
                            widget.totalEntries -=
                                int.parse(_entryController.text);
                            _entryController.clear();
                            _nameController.clear();
                            _phoneController.clear();
                            _chosenValue = 0;
                          });
                        });
                      } //Navigator.pop(context);
                    },
                    child: Text(
                      'Add Participate',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Tabs()),
                      );
                    },
                    child: Text(
                      'Back to Raffles',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
