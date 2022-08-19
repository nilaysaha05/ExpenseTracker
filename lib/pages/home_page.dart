import 'package:budget_tracker_app/controller/db_helper.dart';
import 'package:budget_tracker_app/models/transaction_models.dart';
import 'package:budget_tracker_app/pages/add_transaction.dart';
import 'package:budget_tracker_app/pages/settings_page.dart';
import 'package:budget_tracker_app/pages/transaction_data_page.dart';
import 'package:budget_tracker_app/theme/colors.dart';
import 'package:budget_tracker_app/widgets/confirm_dialog.dart';
import 'package:budget_tracker_app/widgets/info_snackbar.dart';
import 'package:budget_tracker_app/widgets/tracker_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  DbHelper dbHelper = DbHelper();
  double totalBalance = 0;
  late SharedPreferences preferences;
  late Box box;
  double totalIncome = 0;
  double totalExpense = 0;
  DateTime today = DateTime.now();
  DateTime now = DateTime.now();
  int index =1;

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

  getBalance(List<TransactionModel> entireData) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
    for (TransactionModel data in entireData) {
      if (data.date.month == DateTime.now().month) {
        if (data.type == "Income") {
          totalBalance += data.amount;
          totalIncome += data.amount;
        } else {
          totalBalance -= data.amount;
          totalExpense += data.amount;
        }
      }
    }
  }

  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        //print(element);
        items.add(
          TransactionModel(
            element['amount'] as double,
            element['date'] as DateTime,
            element['type'],
            element['note'],
          ),
        );
      });
      return items;
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
    box = Hive.box('money');
    fetch();
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
              blurRadius: 10,
              spreadRadius: 0.8,
              offset: const Offset(0, 0),
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
      body: FutureBuilder<List<TransactionModel>>(
        future: fetch(),
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
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 6,
                                  spreadRadius: 0.5,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              backgroundColor: Colors.grey,
                              maxRadius: 26.0,
                              backgroundImage: AssetImage("assets/face1.png"),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Welcome!",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                '${preferences.getString("name")}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: boxShadow1,
                          ),
                          child: const Icon(
                            Icons.settings,
                            size: 25.0,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                selectMonth(),
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
                        deepPurple,
                        purpleAccent,
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
                        blurRadius: 15,
                        spreadRadius: 0.5,
                        offset: const Offset(1, 1),
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
                      vertical: 20.0, horizontal: 20.0),
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
                    TransactionModel dataAtIndex =snapshot.data![index];
                    if (dataAtIndex.type == "Income") {
                      return incomeTile(
                           dataAtIndex.amount,
                           dataAtIndex.note,
                         dataAtIndex.type,
                         dataAtIndex.date,
                         index,
                      );
                    } else {
                      return expenseTile(
                         dataAtIndex.amount,
                         dataAtIndex.note,
                         dataAtIndex.type,
                         dataAtIndex.date,
                         index,
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
  //incomeTile
  Widget incomeTile(double value, String note,String type, DateTime date, int index)
  {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          deleteInfoSnackBar,
        );
      },
      onLongPress:() async{
        bool? answer = await showConfirmDialog(
            context, "WARNING", "Do you want to delete this?");

        if(answer !=null && answer == true)
        {
          await dbHelper.deleteData(index);
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
                      type,
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
                    "${date.day} ${months[date.month-1]}",
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
                  "+₹$value",
                  style: TextStyle(
                      color: Colors.greenAccent[700],
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    note,
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

  //ExpenseTile
  Widget expenseTile(double value, String note,String type, DateTime date, int index)
  {
    return InkWell(
      onLongPress: () async{
        bool? answer = await showConfirmDialog(
            context, "WARNING", "Do you want to delete this?");

        if(answer !=null && answer == true)
        {
          await dbHelper.deleteData(index);
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
                      Icons.arrow_circle_up_outlined,
                      color: Colors.redAccent[700],
                      size: 30.0,
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      type,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                  child: Text(
                    "${date.day} ${months[date.month - 1]}",
                    style: TextStyle(
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
                  "-₹$value",
                  style: TextStyle(
                      color: Colors.redAccent[700],
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    note,
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

  // select month
  Widget selectMonth() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                index = 3;
                today = DateTime(now.year, now.month - 2, today.day);
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                boxShadow: boxShadow1,
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
                color: index == 3 ? Colors.white : Colors.grey,
              ),
              alignment: Alignment.center,
              child: Text(
                months[now.month - 3],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: index == 3 ? Colors.black54 : Colors.black38,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                index = 2;
                today = DateTime(now.year, now.month - 1, today.day);
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                boxShadow: boxShadow1,
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
                color: index == 2 ? Colors.white : Colors.grey,
              ),
              alignment: Alignment.center,
              child: Text(
                months[now.month - 2],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: index == 2 ? Colors.black54 : Colors.black38,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                index = 1;
                today = DateTime.now();
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                boxShadow: boxShadow1,
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
                color: index == 1 ? Colors.white : Colors.grey,
              ),
              alignment: Alignment.center,
              child: Text(
                months[now.month - 1],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: index == 1 ? Colors.black54 : Colors.black38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




