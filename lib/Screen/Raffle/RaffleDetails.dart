import 'package:eraffle/Models/PrizeList.dart';
import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Models/person_model.dart';
import 'package:eraffle/Models/prize_model.dart';
import 'package:eraffle/Screen/Raffle/RaffleScreen.dart';
import 'package:eraffle/Services/API.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_below/dropdown_below.dart';

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
  bool expand = false;
  bool haveData = false;
  bool isInserted = false;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _entryController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  PersonModel? personModel;
  List<String> prizeList = [];

  var _formKey = GlobalKey<FormState>();
  var _chosenValue;

  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
  var _selectedTest;

  @override
  void initState() {
    _dropdownTestItems = buildDropdownTestItems();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<DropdownMenuItem<Object?>> buildDropdownTestItems() {
    List<DropdownMenuItem<Object?>> items = [];
    for (var prize in widget.prizeList) {
      items.add(
        DropdownMenuItem(
          value: prize.prizeDetail,
          child: Text(prize.prizeDetail!),
        ),
      );
    }
    return items;
  }

  onChangeDropdownTests(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest = selectedTest;
    });
  }

  final ScrollController _sc = ScrollController();
  List<PrizeList> obj = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            )
                          ],
                        ),
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
                            elevation: 1.0,
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
                                          (index + 1).toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.prizeList[index].prizeDetail
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
                            ),
                          ),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            primary: AppColor.secondary,
                            backgroundColor: AppColor.primary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                          ),
                          onPressed: () async {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => MyHomePage(
                            //             title: 'xxx',
                            //           )),
                            // );
                          },
                          child: Text(
                            'Add More',
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
                              elevation: 1.0,
                              child: Container(
                                height: 50,
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                    const Radius.circular(6.0),
                                  ),
                                ),
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
                                            (index + 1).toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        widget.personList[index].name
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
                              ),
                            ),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              primary: AppColor.secondary,
                              backgroundColor: AppColor.primary,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                            ),
                            onPressed: () async {
                              print("object");
                              setState(() {
                                expand = !expand;
                              });

                              // WidgetsBinding.instance!.addPostFrameCallback(
                              //     (_) => {
                              //           _sc.jumpTo(_sc.position.minScrollExtent)
                              //         });
                            },
                            child: Text(
                              'Add More',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExpandedSection(
                            child: expandedCard(),
                            expand: expand,
                          ),
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

  Widget expandedCard() {
    return Padding(
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
                  } else if (int.parse(value) >
                      widget.obj[widget.index].currentEntries!) {
                    return 'Must be less then Total Raffle Entries (${widget.obj[widget.index].currentEntries!})';
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
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              width: MediaQuery.of(context).size.width - 80,
              child: DropdownBelow(
                icon: Icon(Icons.arrow_drop_down),
                isDense: true,
                itemWidth: 300,
                itemTextstyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
                boxTextstyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0XFFbbbbbb)),
                boxPadding: EdgeInsets.fromLTRB(13, 12, 0, 12),
                boxWidth: 330,
                boxHeight: 45,
                hint: Text('choose item'),
                value: _selectedTest,
                items: _dropdownTestItems,
                onChanged: onChangeDropdownTests,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  primary: AppColor.secondary,
                  backgroundColor: AppColor.primary,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Services.insertPerson(
                      name: _nameController.text,
                      noOfEntries: _entryController.text,
                      phoneNo: _phoneController.text,
                      prizeType: _chosenValue,
                      id: widget.obj[widget.index].id,
                    ).then((value) {
                      setState(() {
                        isInserted = true;
                        personModel = new PersonModel(
                            id: value,
                            name: _nameController.text,
                            noOfEntries: int.parse(_entryController.text),
                            phoneNo: _phoneController.text,
                            prizeType: _phoneController.text);
                        widget.personList.add(personModel!);
                        expand = false;
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
