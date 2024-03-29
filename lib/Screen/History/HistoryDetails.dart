import 'package:eraffle/Models/PrizeList.dart';
import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Models/person_model.dart';
import 'package:eraffle/Models/prize_model.dart';
import 'package:eraffle/Models/winner_model.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';

class HistoryDetailsScreen extends StatefulWidget {
  const HistoryDetailsScreen({
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
  _RaffleDetailsScreenState createState() => _RaffleDetailsScreenState();
}

class _RaffleDetailsScreenState extends State<HistoryDetailsScreen> {
  bool personExpanded = false;
  bool prizeExpanded = false;
  bool editExpanded = false;
  bool haveData = false;
  bool isInserted = false;

  PersonModel? personModel;
  PrizeModel? prizeModel;
  WinnerModel? winnerModel;
  List<String> prizeList = [];
  List<String> selectedList = [];
  List<String> prizes = [];
  List<WinnerModel> sortedWinnerList=[];
  int profit=0;

  @override
  void initState() {
    print("dgd");
     DateTime now = DateTime.now();
    for (var prize in widget.prizeList) {
      
      prizes.add(prize.prizeDetail!);
     int index = widget.winnerList.indexWhere((element) =>
                                                    element.prizeName ==prize.prizeDetail);
     
     
     

    if(index==-1)
    {
      WinnerModel winobj=new WinnerModel(name: "N/A",prizeName: prize.prizeDetail,noOfEntries: 0,initialEntries: 0,lock: 1,date: "N/A",phoneNo: "N/A");
      sortedWinnerList.add(winobj);
    }

    if(index!=-1)
    {
      profit+=((widget.winnerList[index].initialEntries!*prize.costEachEntry!)-prize.value!);
      print("test");
      sortedWinnerList.add(widget.winnerList[index]);
    }
   
    }
    print(profit);
    
    selectedList.add(prizes[0]);

    print(sortedWinnerList.length);
    for (var winner in sortedWinnerList) {
      print("dgd");
      print(winner.prizeName);
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                  child: Stack(
                    children: [
                      Column(
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
                                      "Closing Date",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.obj[widget.index].closeDate!
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
                                      "Available Entries",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.obj[widget.index].currentEntries!<0?"0":
                                  widget.obj[widget.index].currentEntries!.toString(),
                
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
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Text(
                                      "Raffle Profit",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  profit.toString(),
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
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(top: 5),
                          //       child: TextButton(
                          //         style: TextButton.styleFrom(
                          //           shape: RoundedRectangleBorder(
                          //             // borderRadius: BorderRadius.circular(30),
                          //             borderRadius: BorderRadius.only(
                          //               topLeft: Radius.circular(10.0),
                          //               topRight: Radius.zero,
                          //               bottomLeft: Radius.zero,
                          //               bottomRight: Radius.circular(10.0),
                          //             ),
                          //           ),
                          //           primary: AppColor.primary,
                          //           backgroundColor: AppColor.primary,
                          //           padding: EdgeInsets.symmetric(
                          //               horizontal: 50, vertical: 15),
                          //         ),
                          //         onPressed: () {
                          //           setState(() {
                          //             editExpanded = !editExpanded;
                          //           });
                          //         },
                          //         child: Text(
                          //           editExpanded ? 'Close' : 'Winners',
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 18,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
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
                      ...List.generate(sortedWinnerList.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                            left: 10,
                            right: 20,
                          ),
                          child: Card(
                            elevation: 3.0,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 15),
                                            child: Text(
                                              "Prize Name",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          sortedWinnerList[index].prizeName
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 15),
                                            child: Text(
                                              "Prize Value",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          widget.prizeList[index].value
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 15),
                                            child: Text(
                                              "Cost per Entry",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          widget.prizeList[index].costEachEntry
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 15),
                                            child: Text(
                                              "Prize Profit",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          ((widget.prizeList[index].costEachEntry!*sortedWinnerList[index].initialEntries!)-widget.prizeList[index].value!).toString()
                                              ,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 15),
                                            child: Text(
                                              "Winner Name",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          sortedWinnerList[index].name
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 15),
                                            child: Text(
                                              "Winning Date",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          sortedWinnerList[index].date
                                              .toString()=="N/A"?"N/A":
                                              sortedWinnerList[index].date.toString().substring(0,13),

                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 15),
                                            child: Text(
                                              "Mobile ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          sortedWinnerList[index].phoneNo
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                    
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 20,
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
                        SizedBox(
                          height: 20,
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
    return Column(
      children: [
        ...List.generate(widget.winnerList.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 5,
              left: 10,
              right: 10,
            ),
            child: Card(
              elevation: 3.0,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Text(
                                  "Winner name",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              widget.winnerList[index].name!,
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
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
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
                              widget.winnerList[index].prizeName!,
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
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Text(
                                  "Initial Entries",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              widget.winnerList[index].initialEntries
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
                        padding: const EdgeInsets.all(5.0),
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
                              widget.winnerList[index].noOfEntries.toString(),
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
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Text(
                                  "Winning Date",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              widget.winnerList[index].date!.substring(0, 16),
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
              ),
            ),
          );
        }),
      ],
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
