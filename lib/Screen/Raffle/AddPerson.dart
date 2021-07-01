import 'package:eraffle/Models/PrizeList.dart';
import 'package:eraffle/Screen/Raffle/RaffleScreen.dart';
import 'package:eraffle/Services/API.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddPersonScreen extends StatefulWidget {
  const AddPersonScreen({Key? key, this.id, this.totalEntries})
      : super(key: key);
  final id;
  final totalEntries;
  @override
  _AddPersonScreenState createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  TextEditingController _prizeController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _entryController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  List<String> prizeList = [];

  var _formKey = GlobalKey<FormState>();

  bool haveData = false;
  double btnWidth = 0.0;
  double btnHeight = 0.0;
  bool isInserted = false;
  var _chosenValue;

  List<PrizeList> obj = [];
  PrizeList fObj = new PrizeList(id: 0, prizeDetail: "Choose Prize");
  PrizeList lObj = new PrizeList(id: -1, prizeDetail: "For All");
  @override
  void initState() {
    Services.getRafflePrizelist(id: widget.id).then((value) {
      setState(() {
        haveData = true;
        obj = value;
        obj.insert(0, fObj);
        obj.add(lObj);
        print(value.runtimeType);

        _chosenValue = 0;
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
                        return 'Enter Phone Number';
                      }
                      return null;
                    },
                  ),
                ),
                haveData
                    ? Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.70),
                            ),
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              validator: (value) {
                                if (value == 0) {
                                  return 'Choose Prize';
                                }
                              },
                              value: _chosenValue,
                              icon: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColor.primary,
                                  size: 30,
                                ),
                              ),
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                              style: TextStyle(color: Colors.black),
                              items: obj.map((item) {
                                return new DropdownMenuItem(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: new Text(item.prizeDetail!),
                                  ),
                                  value: item.id,
                                );
                              }).toList(),
                              hint: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  "Choose Prize",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  print(value);
                                  _chosenValue = value;
                                });
                              },
                            ),
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
                      primary: AppColor.secondary,
                      backgroundColor: AppColor.primary,
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
                          prizeType: _chosenValue,
                          id: widget.id,
                        ).then((value) {
                          setState(() {
                            isInserted = true;
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
                      primary: AppColor.secondary,
                      backgroundColor: AppColor.primary,
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                    ),
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RaffleScreen()),
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
