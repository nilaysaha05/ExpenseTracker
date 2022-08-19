import 'package:budget_tracker_app/controller/db_helper.dart';
import 'package:budget_tracker_app/theme/colors.dart';
import 'package:budget_tracker_app/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';

class IncomeTile extends StatefulWidget {
    IncomeTile({
    Key? key,
    required this.value,
    required this.note,
    required this.date,
     required this.type,
      required this.index,
  }) : super(key: key);



  final double value;
  final String note;
  final String type;
  final DateTime date;
  final int index;

  @override
  State<IncomeTile> createState() => _IncomeTileState();
}

class _IncomeTileState extends State<IncomeTile> {

  DbHelper dbHelper = DbHelper();
   List<String> months = [
     "Jan",
     "Feb",
     "Mar",
     "Apr",
     "May",
     "Jun",
     "Jul",
     "Aug",
     "Sep",
     "Oct",
     "Nov",
     "Dec",
   ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress:() async{
      bool? answer = await showConfirmDialog(
          context, "WARNING", "Do you want to delete this?");

      if(answer !=null && answer == true)
      {
        await dbHelper.deleteData(widget.index);
        setState((){});
      }
    },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 22.0,
          vertical: 8.0,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 25.0,
          horizontal: 20.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: grey.withOpacity(0.4),
              blurRadius: 6,
              spreadRadius: 0.8,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_circle_down_outlined,
                      color: Colors.greenAccent[700],
                      size: 30.0,
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      widget.type,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0,left: 5),
                  child: Text(
                    "${widget.date.day} ${months[widget.date.month-1]}",
                    style:  TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+₹${widget.value}",
                  style: TextStyle(
                      color: Colors.greenAccent[700],
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    widget.note,
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
