import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Models/person_model.dart';
import 'package:eraffle/Models/prize_model.dart';
import 'package:eraffle/Screen/Raffle/RaffleDetails.dart';
import 'package:eraffle/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'DrawScreen.dart';

class RaffleCard extends StatefulWidget {
  RaffleCard({
    Key? key,
    required this.obj,
    required this.index,
    required this.prizes,
    required this.persons,
  }) : super(key: key);

  final List<RaffleModel> obj;
  final List prizes;
  final List persons;

  final int index;

  @override
  _RaffleCardState createState() => _RaffleCardState();
}

class _RaffleCardState extends State<RaffleCard> {
  List<PrizeModel> prizeList = [];

  List<PersonModel> personList = [];
  @override
  void initState() {
    // TODO: implement initState
    prizeList = widget.prizes[widget.index];
    personList = widget.persons[widget.index];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RaffleDetailsScreen(
                    index: widget.index,
                    obj: widget.obj,
                    personList: personList,
                    prizeList: prizeList,
                  )),
        ).then((value) {
          setState(() {});
        });
      },
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
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            widget.obj[widget.index].createdDate!
                                .substring(0, 16),
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              primary: AppColor.secondary,
                              backgroundColor: AppColor.primary,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DrawScreen(
                                          index: widget.index,
                                          obj: widget.obj,
                                          personList: personList,
                                          prizeList: prizeList,
                                        )),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            child: Text(
                              'Draw',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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
