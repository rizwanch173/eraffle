import 'package:eraffle/Models/RaffleModel.dart';
import 'package:eraffle/Models/person_model.dart';
import 'package:eraffle/Models/prize_model.dart';
import 'package:eraffle/Screen/Raffle/RaffleDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.all(20),
          primary: Colors.black,
          backgroundColor: Colors.grey,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RaffleDetailsScreen(
                      index: widget.index,
                      obj: widget.obj,
                      personList: personList,
                      prizeList: prizeList,
                    )),
          );
        },
        child: Row(
          children: [
            SizedBox(width: 10),
            Expanded(
              child: Text(widget.obj[widget.index].eventName!),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
