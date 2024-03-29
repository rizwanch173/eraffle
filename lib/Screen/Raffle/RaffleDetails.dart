import 'package:eraffle/Models/PrizeList.dart';
import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Models/person_model.dart';
import 'package:eraffle/Models/prize_model.dart';
import 'package:eraffle/Services/API.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';

class RaffleDetailsScreen extends StatefulWidget {
  const RaffleDetailsScreen({
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
  _RaffleDetailsScreenState createState() => _RaffleDetailsScreenState();
}

class _RaffleDetailsScreenState extends State<RaffleDetailsScreen> {
  bool personExpanded = false;
  bool prizeExpanded = false;
  bool editExpanded = false;
  bool haveData = false;
  bool isInserted = false;

  TextEditingController _nameControllerEdit = new TextEditingController();
  TextEditingController _entryControllerEdit = new TextEditingController();
  TextEditingController _prizeValueController = new TextEditingController();
  TextEditingController _prizeEntryController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _entryController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _prizeController = new TextEditingController();
  PersonModel? personModel;
  PrizeModel? prizeModel;
  List<String> prizeList = [];
  List<String> selectedList = [];
  List<String> prizes = [];
  var _formKeyPerson = GlobalKey<FormState>();
  var _formKeyPrize = GlobalKey<FormState>();
  var _formKeyEdit = GlobalKey<FormState>();

  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
  var _selectedVal;

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

  @override
  void initState() {
    _nameControllerEdit.text = widget.obj[widget.index].eventName!;

    for (var prize in widget.prizeList) {
      prizes.add(prize.prizeDetail!);
    }
    selectedList.add(prizes[0]);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onChangeDropdownTests(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedVal = selectedTest;
    });
  }

  final ScrollController _sc = ScrollController();
  List<PrizeList> obj = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Details"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        controller: _sc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(1.0, 0.0), // shadow direction: bottom right
                      )
                    ],
                    gradient: new LinearGradient(
                        stops: [0.98, 0.02],
                        colors: [Colors.white, AppColor.primary]),
                    borderRadius: new BorderRadius.all(
                      const Radius.circular(6.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Text(
                                  widget.obj[widget.index].eventName!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
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
                        padding: const EdgeInsets.all(15),
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
                                  : widget.obj[widget.index].currentEntries!
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
                        padding: const EdgeInsets.all(15),
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
                        padding: const EdgeInsets.all(15),
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
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Text(
                                  "Total Prize",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              widget.prizeList.length.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpandedSection(
                          child: expandedCardEntry(),
                          expand: editExpanded,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          editExpanded
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        // borderRadius: BorderRadius.circular(30),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.zero,
                                          topRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.zero,
                                        ),
                                      ),
                                      primary: AppColor.primary,
                                      backgroundColor: AppColor.primary,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 15),
                                    ),
                                    onPressed: () {
                                      if (editExpanded == false) {
                                        setState(() {
                                          editExpanded = true;
                                        });
                                      } else {
                                        if (_formKeyEdit.currentState!
                                            .validate()) {
                                          _formKeyEdit.currentState!.save();

                                          Services.updateRaffle(
                                                  id: widget
                                                      .obj[widget.index].id,
                                                  name:
                                                      _nameControllerEdit.text,
                                                  entries: int.parse(
                                                      _entryControllerEdit
                                                          .text))
                                              .then((value) {
                                            widget.obj[widget.index].eventName =
                                                _nameControllerEdit.text;
                                            widget.obj[widget.index]
                                                .currentEntries = widget
                                                    .obj[widget.index]
                                                    .currentEntries! +
                                                int.parse(
                                                    _entryControllerEdit.text);
                                            widget.obj[widget.index]
                                                .initialEntries = widget
                                                    .obj[widget.index]
                                                    .initialEntries! +
                                                int.parse(
                                                    _entryControllerEdit.text);
                                            setState(() {
                                              editExpanded = false;
                                            });
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Update',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  // borderRadius: BorderRadius.circular(30),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.zero,
                                    bottomLeft: Radius.zero,
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                primary: AppColor.primary,
                                backgroundColor: AppColor.primary,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                              ),
                              onPressed: () {
                                setState(() {
                                  editExpanded = !editExpanded;
                                });
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(1.0, 0.0), // shadow direction: bottom right
                      )
                    ],
                    gradient: new LinearGradient(
                        stops: [0.98, 0.02],
                        colors: [Colors.white, AppColor.primary]),
                    borderRadius: new BorderRadius.all(
                      const Radius.circular(6.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Prize List",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ),
                      ...List.generate(widget.prizeList.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                            left: 10,
                            right: 20,
                          ),
                          child: Card(
                            elevation: 3,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Text(
                                          widget.prizeList[index].prizeDetail!,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.prizeList[index].value.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpandedSection(
                          child: expandedCardPrize(),
                          expand: prizeExpanded,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  // borderRadius: BorderRadius.circular(30),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.zero,
                                    bottomLeft: Radius.zero,
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                primary: AppColor.primary,
                                backgroundColor: AppColor.primary,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                              ),
                              onPressed: () {
                                if (prizeExpanded == false) {
                                  setState(() {
                                    prizeExpanded = true;
                                  });
                                } else {
                                  if (_formKeyPrize.currentState!.validate()) {
                                    _formKeyPrize.currentState!.save();

                                    Services.insertSingleRafflePrize(
                                      id: widget.obj[widget.index].id,
                                      prize: _prizeController.text,
                                      value: _prizeValueController.text,
                                      costEachEntry: _prizeEntryController.text,
                                    ).then((value) {
                                      prizeModel = new PrizeModel(
                                        id: value,
                                        prizeDetail: _prizeController.text,
                                        value: int.parse(
                                            _prizeValueController.text),
                                        costEachEntry: int.parse(
                                            _prizeEntryController.text),
                                        raffleId: widget.obj[widget.index].id,
                                      );
                                      widget.prizeList.add(prizeModel!);
                                      prizes.add(_prizeController.text);

                                      setState(() {
                                        prizeExpanded = false;
                                      });
                                    });
                                  }
                                }
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              1.0, 0.0), // shadow direction: bottom right
                        )
                      ],
                      gradient: new LinearGradient(
                          stops: [0.98, 0.02],
                          colors: [Colors.white, AppColor.primary]),
                      borderRadius: new BorderRadius.all(
                        const Radius.circular(6.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Participate",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ),
                        ...List.generate(widget.personList.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: 10,
                              right: 20,
                            ),
                            child: Card(
                              elevation: 3.0,
                              child: Container(
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                    const Radius.circular(6.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Name",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                widget.personList[index].name
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Initial Entries",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              widget.personList[index]
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
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Current Entries",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              widget
                                                  .personList[index].noOfEntries
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                "Prize Enrolled",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                widget
                                                    .personList[index].prizeType
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExpandedSection(
                            child: expandedCard(),
                            expand: personExpanded,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    // borderRadius: BorderRadius.circular(30),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.zero,
                                      bottomLeft: Radius.zero,
                                      bottomRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  primary: AppColor.primary,
                                  backgroundColor: AppColor.primary,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                ),
                                onPressed: () {
                                  if (personExpanded == false) {
                                    setState(() {
                                      personExpanded = true;
                                    });
                                  } else {
                                    if (_formKeyPerson.currentState!
                                        .validate()) {
                                      _formKeyPerson.currentState!.save();

                                      Services.insertPerson(
                                        name: _nameController.text,
                                        noOfEntries: _entryController.text,
                                        phoneNo: _phoneController.text,
                                        prizeList: selectedList,
                                        id: widget.obj[widget.index].id,
                                      ).then((value) {
                                        personModel = new PersonModel(
                                          id: value,
                                          name: _nameController.text,
                                          noOfEntries: int.parse(
                                            _entryController.text,
                                          ),
                                          phoneNo: _phoneController.text,
                                          prizeType: selectedList.join(","),
                                          raffleId: widget.obj[widget.index].id,
                                          initialEntries: int.parse(
                                            _entryController.text,
                                          ),
                                        );
                                        widget.personList.add(personModel!);
                                        if (widget.obj[widget.index]
                                                .currentEntries ==
                                            -1) {
                                          setState(() {
                                            personExpanded = false;
                                            isInserted = true;
                                            widget.obj[widget.index]
                                                .initialEntries = widget
                                                    .obj[widget.index]
                                                    .initialEntries! +
                                                int.parse(
                                                    _entryController.text);
                                          });
                                        } else {
                                          setState(() {
                                            widget.obj[widget.index]
                                                .currentEntries = widget
                                                    .obj[widget.index]
                                                    .currentEntries! -
                                                int.parse(
                                                    _entryController.text);
                                            widget.obj[widget.index]
                                                .initialEntries = widget
                                                    .obj[widget.index]
                                                    .initialEntries! +
                                                int.parse(
                                                    _entryController.text);
                                            personExpanded = false;
                                            isInserted = true;
                                          });
                                        }
                                      });
                                    }
                                  }
                                },
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget expandedCardEntry() {
    return Padding(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: Form(
          key: _formKeyEdit,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _nameControllerEdit,
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _entryControllerEdit,
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
                    labelText: "Initial Entry",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Entries you want to add",
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
                      return 'Enter Current Entry';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget expandedCardPrize() {
    return Padding(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: Form(
          key: _formKeyPrize,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _prizeController,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    labelText: "Prize name",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Enter Prize name",
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
                      return 'Enter Prize name';
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
                  controller: _prizeValueController,
                  readOnly: isInserted,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$'))
                  ],
                  decoration: InputDecoration(
                    labelText: "Prize value",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Enter prize value",
                    hintStyle: TextStyle(color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: SvgPicture.asset(
                        "assets/Icons/dollar.svg",
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
                      return 'add prize value';
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
                  controller: _prizeEntryController,
                  readOnly: isInserted,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$'))
                  ],
                  decoration: InputDecoration(
                    labelText: "Entries price",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Enter price per entry",
                    hintStyle: TextStyle(color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: SvgPicture.asset(
                        "assets/Icons/dollar.svg",
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
                      return 'add price per entry';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget expandedCard() {
    return Padding(
      padding: EdgeInsets.only(right: 20, left: 20),
      child: Form(
        key: _formKeyPerson,
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
                  } else if (widget.obj[widget.index].currentEntries != -1) {
                    int totalEntry = int.parse(value) +
                        widget.obj[widget.index].initialEntries!;
                    if (totalEntry > widget.obj[widget.index].currentEntries!) {
                      return 'Must be less then Total Raffle Entries (${widget.obj[widget.index].currentEntries!})';
                    }
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
            Row(
              children: [
                Expanded(
                  child: GroupButton(
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
                      print(selectedList);
                      setState(() {});
                    },
                    buttons: prizes,
                    selectedTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    unselectedTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    selectedColor: AppColor.secondary,
                    unselectedColor: Colors.grey[300]!,
                    selectedBorderColor: AppColor.primary,
                    unselectedBorderColor: Colors.grey[500]!,
                    borderRadius: BorderRadius.circular(5.0),
                    selectedShadow: <BoxShadow>[
                      BoxShadow(color: Colors.transparent)
                    ],
                    unselectedShadow: <BoxShadow>[
                      BoxShadow(color: Colors.transparent)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ExpandedSection extends StatefulWidget {
  final Widget? child;
  final bool? expand;
  ExpandedSection({this.expand = false, this.child});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  AnimationController? expandController;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController!,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (widget.expand!) {
      expandController!.forward();
    } else {
      expandController!.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizeTransition(
          axisAlignment: 1.0, sizeFactor: animation!, child: widget.child),
    );
  }
}
