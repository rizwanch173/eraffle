import 'package:eraffle/Models/RaffleModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RaffleCard extends StatelessWidget {
  const RaffleCard({
    Key? key,
    required this.obj,
    required this.index,
  }) : super(key: key);

  final List<RaffleModel> obj;
  final int index;

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
        onPressed: () {},
        child: Row(
          children: [
            SizedBox(width: 10),
            Expanded(child: Text(obj[index].eventName!)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
