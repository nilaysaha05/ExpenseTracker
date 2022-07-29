import 'package:budget_tracker_app/controller/db_helper.dart';
import 'package:budget_tracker_app/pages/add_name_page.dart';
import 'package:budget_tracker_app/pages/home_page.dart';
import 'package:budget_tracker_app/theme/colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  DbHelper dbHelper = DbHelper();

  Future getSettings() async {
    String? name = await dbHelper.getName();
    if(name != null)
      {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    else
      {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AddName(),
          ),
        );
      }
  }

  @override
  void initState() {
    super.initState();
    getSettings();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        backgroundColor: offWhite,
        toolbarHeight: 0.0,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
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
          child: const Center(
            child: Text(
              "₹",
              style: TextStyle(
                color: Colors.white,
                fontSize: 35.0,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
