import 'package:budget_tracker_app/controller/db_helper.dart';
import 'package:budget_tracker_app/theme/colors.dart';
import 'package:budget_tracker_app/widgets/expense_tile.dart';
import 'package:budget_tracker_app/widgets/income_tile.dart';
import 'package:flutter/material.dart';

class TransactionDataPage extends StatefulWidget {
  const TransactionDataPage({Key? key}) : super(key: key);

  @override
  State<TransactionDataPage> createState() => _TransactionDataPageState();
}

class _TransactionDataPageState extends State<TransactionDataPage> {
  DbHelper dbHelper = DbHelper();
  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;

  getBalance(Map entireData) {
    totalExpense = 0;
    totalIncome = 0;
    totalBalance = 0;
    entireData.forEach((key, value) {
      if (value['type'] == "Income") {
        totalBalance += (value['amount'] as double);
        totalIncome += (value['amount'] as double);
      } else {
        totalBalance -= (value['amount'] as double);
        totalExpense += (value['amount'] as double);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: offWhite,
        toolbarHeight: 20.0,
        elevation: 0.0,
      ),
      body: FutureBuilder<Map>(
        future: dbHelper.fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Unexpected error occurred !"),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No Data",
                  textAlign: TextAlign.center,
                ),
              );
            }
            getBalance(snapshot.data!);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 12.0),
                  child: Row(
                    children: [
                      Container(
                        height: 39.0,
                        width: 39.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_circle_left,
                              color: Colors.black38,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      const Text(
                        "Transactions",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Map dataAtIndex = snapshot.data![index];
                    if (dataAtIndex['type'] == 'Income') {
                      return IncomeTile(
                          value: dataAtIndex["amount"],
                          note: dataAtIndex["note"]);
                    } else {
                      return ExpenseTile(
                        value: dataAtIndex["amount"],
                        note: dataAtIndex["note"],
                      );
                    }
                  },
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("Unexpected error occurred !"),
            );
          }
        },
      ),
    );
  }
}
