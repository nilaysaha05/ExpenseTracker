import 'package:budget_tracker_app/controller/db_helper.dart';
import 'package:budget_tracker_app/theme/colors.dart';
import 'package:budget_tracker_app/widgets/expense_tile.dart';
import 'package:budget_tracker_app/widgets/income_tile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TransactionDataPage extends StatefulWidget {
  const TransactionDataPage({Key? key}) : super(key: key);

  @override
  State<TransactionDataPage> createState() => _TransactionDataPageState();
}

class _TransactionDataPageState extends State<TransactionDataPage> {
  DbHelper dbHelper = DbHelper();
  DateTime today = DateTime.now();
  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;
  List<FlSpot> dataSet = [];

  List<FlSpot> getChartPoints(Map entireData) {
    dataSet = [];
    entireData.forEach((key, value) {
      if (value['type'] == 'Expense' && (value['date'] as DateTime).month == today.month)
      {
        dataSet.add(FlSpot((value['date'] as DateTime).day.toDouble(),
            (value['amount'] as double)));
      }
    });
    return dataSet;
  }

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
            getChartPoints(snapshot.data!);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 39.0,
                          width: 39.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:Colors.grey.withOpacity(0.4),
                                blurRadius: 6,
                                spreadRadius: 0.5,
                                offset: const Offset(0,0),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_circle_left,
                            color: Colors.black38,
                            size: 24.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21.0),
                  child: Text(
                    "Expense Chart",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                dataSet.length > 2
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 0.5,
                              offset: const Offset(1,1),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Total Balance",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "₹ $totalBalance",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 400,
                              width: 400,
                              child: LineChart(
                                LineChartData(
                                  minX: 1,
                                  maxX: 30,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: getChartPoints(snapshot.data!),
                                      isCurved: true,
                                      barWidth: 3,
                                      gradient: const LinearGradient(
                                        colors: [
                                          blue1,
                                          blue,
                                          deepPurple,
                                          purpleAccent,
                                          peach,
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 0.5,
                              offset: const Offset(1,1),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Total Balance",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "₹ $totalBalance",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 100,
                              width: 400,
                              child: const Center(
                                child: Text(
                                  "Not enough data to show chart !",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 10.0,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21.0),
                  child: Text(
                    "Transactions",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
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
