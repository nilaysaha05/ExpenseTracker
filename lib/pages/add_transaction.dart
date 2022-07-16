import 'package:budget_tracker_app/controller/db_helper.dart';
import 'package:budget_tracker_app/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  double? amount;
  String note = "untitled";
  String type = "Income";
  DateTime selectedDate = DateTime.now();

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 12),
      lastDate: DateTime(
        2100,
        12,
      ),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: offWhite,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: offWhite,
        automaticallyImplyLeading: false,
        //toolbarHeight: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              color: Colors.grey,
              iconSize: 26.0,
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                Navigator.of(context).pop(const AddTransaction());
              },
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 35.0,
          vertical: 12.0,
        ),
        child: Column(
          children: [
            const Text(
              'Add Expenses',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black45,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 28.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.black45,
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.attach_money_rounded,
                    color: Colors.black45,
                    size: 32.0,
                  ),
                  hintText: "0",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                onChanged: (val) {
                  try {
                    amount = double.parse(val);
                  } catch (e) {}
                },
              ),
            ),
            const SizedBox(
              height: 45.0,
            ),
            TextField(
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black45,
                  height: 2.1,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  CupertinoIcons.doc_plaintext,
                  color: Colors.black45,
                  size: 32.0,
                ),
                hintText: "Note",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) {
                note = val;
              },
            ),
            const SizedBox(
              height: 25.0,
            ),
            Row(
              children: [
                const Icon(
                  Icons.moving_sharp,
                  color: Colors.black45,
                  size: 32.0,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  padding: const EdgeInsets.all(10),
                  label: Text(
                    "Income",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            type == "Income" ? Colors.black45 : Colors.white),
                  ),
                  selected: type == "Income" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "Income";
                      });
                    }
                  },
                  selectedColor: Colors.white,
                ),
                const SizedBox(
                  width: 15.0,
                ),
                ChoiceChip(
                  padding: const EdgeInsets.all(10),
                  label: Text(
                    "Expense",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: type == "Expense" ? Colors.black45 : Colors.white),
                  ),
                  selected: type == "Expense" ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "Expense";
                      });
                    }
                  },
                  selectedColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(
              height: 25.0,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              height: 63,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent),
                onPressed: () {
                  _selectDate(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.calendar_circle_fill,
                      color: Colors.black45,
                      size: 33.0,
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "${selectedDate.day}-${months[selectedDate.month - 1]}-${selectedDate.year}",
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [
                    peach,
                    purpleAccent,
                    deepPurple,
                    blue,
                    blue1,
                  ],
                  stops: [
                    0.25,
                    0.45,
                    0.7,
                    0.85,
                    1,
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent),
                onPressed: () async {
                  if (amount != null && note != null && type != null) {
                    DbHelper dbHelper = DbHelper();
                   await dbHelper.addData(amount!, selectedDate, note, type);
                   Navigator.of(context).pop();
                  } else {
                    print('error occurred');
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
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
