import 'package:budget_tracker_app/controller/db_helper.dart';
import 'package:budget_tracker_app/models/transaction_models.dart';
import 'package:budget_tracker_app/theme/colors.dart';
import 'package:budget_tracker_app/widgets/confirm_dialog.dart';
import 'package:budget_tracker_app/widgets/info_snackbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TransactionDataPage extends StatefulWidget {
  const TransactionDataPage({Key? key}) : super(key: key);

  @override
  State<TransactionDataPage> createState() => _TransactionDataPageState();
}

class _TransactionDataPageState extends State<TransactionDataPage> {
  //
  DbHelper dbHelper = DbHelper();
  double totalBalance = 0;
  late Box box;
  double totalIncome = 0;
  double totalExpense = 0;
  DateTime today = DateTime.now();
  List<FlSpot> dataSet = [];
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

  List<FlSpot> getChartPoints(List<TransactionModel> entireData) {
    dataSet = [];
    List tempDataSet = [];

    for (TransactionModel item in entireData) {
      if (item.date.month == today.month && item.type == "Expense") {
        tempDataSet.add(item);
      }
    }
    //
    // Sorting the list as per the date
    tempDataSet.sort((a, b) => a.date.day.compareTo(b.date.day));
    //
    for (var i = 0; i < tempDataSet.length; i++) {
      dataSet.add(
        FlSpot(
          tempDataSet[i].date.day.toDouble(),
          tempDataSet[i].amount.toDouble(),
        ),
      );
    }
    return dataSet;
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box('money');
    fetch();
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
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 6,
                                spreadRadius: 0.5,
                                offset: const Offset(0, 0),
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
                              offset: const Offset(1, 1),
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
                            SizedBox(
                              height: 400,
                              width: 400,
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: getChartPoints(snapshot.data!),
                                      isCurved: true,
                                      barWidth: 3,
                                      showingIndicators: [200,200,90,10],
                                      dotData: FlDotData(show: true),
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
                              offset: const Offset(1, 1),
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
                            const SizedBox(
                              height: 100,
                              width: 400,
                              child: Center(
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

}
