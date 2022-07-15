import 'dart:ffi';

import 'package:budget_tracker_app/controller/db_helper.dart';
import 'package:budget_tracker_app/pages/add_transaction.dart';
import 'package:budget_tracker_app/pages/transaction_data_page.dart';
import 'package:budget_tracker_app/theme/colors.dart';
import 'package:budget_tracker_app/widgets/expense_tile.dart';
import 'package:budget_tracker_app/widgets/income_tile.dart';
import 'package:budget_tracker_app/widgets/tracker_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        elevation: 0.0,
        backgroundColor: offWhite,
        toolbarHeight: 15.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 62,
        width: 62,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: purpleAccent.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(-1, 10),
            )
          ],
          gradient: const LinearGradient(
            colors: [peach, purpleAccent, deepPurple, blue, blue1],
            stops: [
              0.25,
              0.45,
              0.7,
              0.85,
              1,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: IconButton(
          color: Colors.white,
          iconSize: 35.0,
          icon: const Icon(Icons.add_rounded),
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => const AddTransaction(),
              ),
            )
                .whenComplete(() {
              setState(() {});
            });
          },
        ),
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
                  "No data found click on + to get Started !",
                  textAlign: TextAlign.center,
                ),
              );
            }

            getBalance(snapshot.data!);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xfff5c560),
                            maxRadius: 26.0,
                            child: Image.asset(
                              'assets/user.png',
                              height: 45.0,
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Welcome!",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                'Nilay Saha',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.settings,
                          size: 25.0,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: const LinearGradient(
                      colors: [
                        blue1,
                        blue,
                        Colors.deepPurpleAccent,
                        Colors.purpleAccent,
                        peach,
                      ],
                      stops: [
                        0.01,
                        0.3,
                        0.45,
                        0.65,
                        1.2,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: purpleAccent.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 0.5,
                        offset: const Offset(2, 4),
                      ),
                      BoxShadow(
                        color: blue.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 0.5,
                        offset: const Offset(-2, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 18.0,
                      ),
                      Text(
                        "Total Balance",
                        style: TextStyle(
                          color: Colors.white60.withOpacity(0.7),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "₹ $totalBalance",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 18.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TrackerCard(
                              value: totalIncome.toString(),
                              type: "Income",
                              iconData: Icons.arrow_downward_rounded,
                              iconColor: Colors.greenAccent[700]!,
                            ),
                            TrackerCard(
                              value: totalExpense.toString(),
                              type: "Expenses",
                              iconData: Icons.arrow_upward_rounded,
                              iconColor: Colors.redAccent[700]!,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 21.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Transactions",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TransactionDataPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
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
                )
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
