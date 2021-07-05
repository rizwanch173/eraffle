import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Models/person_model.dart';
import 'package:eraffle/Models/prize_model.dart';
import 'package:eraffle/Models/winner_model.dart';
import 'package:eraffle/Screen/History/HistoryDetails.dart';
import 'package:eraffle/Screen/Raffle/RaffleDetails.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatefulWidget {
  HistoryCard({
    Key? key,
    required this.obj,
    required this.index,
    required this.prizes,
    required this.persons,
    required this.winners,
  }) : super(key: key);

  final List<RaffleModel> obj;
  final List prizes;
  final List persons;
  final List winners;
  final int index;

  @override
  _RaffleCardState createState() => _RaffleCardState();
}

class _RaffleCardState extends State<HistoryCard> {
  List<PrizeModel> prizeList = [];

  List<PersonModel> personList = [];
  List<WinnerModel> winnerList = [];
  @override
  void initState() {
    // TODO: implement initState
    prizeList = widget.prizes[widget.index];
    personList = widget.persons[widget.index];
    winnerList = widget.winners[widget.index];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            SizedBox(width: 10),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(1.0, 0.0), // shadow direction: bottom right
                  )
                ],
                gradient: new LinearGradient(
                    stops: [0.98, 0.02],
                    colors: [Colors.white, AppColor.primary]),
                borderRadius: new BorderRadius.all(
                  const Radius.circular(6.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            widget.obj[widget.index].eventName.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 5),
                      child: Row(
                        children: [
                          Text(
                            "Closing Date",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Spacer(),
                          Text(
                            widget.obj[widget.index].createdDate!
                                .substring(0, 16),
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          primary: AppColor.primary,
                          backgroundColor: AppColor.secondary,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryDetailsScreen(
                                      index: widget.index,
                                      obj: widget.obj,
                                      personList: personList,
                                      prizeList: prizeList,
                                      winnerList: winnerList,
                                    )),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        child: Text(
                          'Details',
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
            ),
          ],
        ),
      ),
    );
  }
}
