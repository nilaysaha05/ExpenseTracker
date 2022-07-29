import 'package:budget_tracker_app/controller/db_helper.dart';
import 'package:budget_tracker_app/pages/home_page.dart';
import 'package:budget_tracker_app/theme/colors.dart';
import 'package:flutter/material.dart';

class AddName extends StatefulWidget {
  const AddName({Key? key}) : super(key: key);

  @override
  State<AddName> createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  DbHelper dbHelper = DbHelper();
  String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        backgroundColor: offWhite,
        toolbarHeight: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
            const SizedBox(
              height: 15.0,
            ),
            const Text(
              "What should we call you?",
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            TextField(
              style: const TextStyle(
                color: Colors.black45,
                height: 2,
              ),
              decoration: InputDecoration(
                hintText: "enter your name..",
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
              onChanged: (val)
              {
                name = val;
              },
            ),
            const SizedBox(
              height: 25.0,
            ),
            Container(
              width: double.maxFinite,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                  boxShadow: [
              BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 0.5,
              offset: const Offset(0, 0),
            ),],
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
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        action: SnackBarAction(
                          label: "OK",
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                        backgroundColor: Colors.white,
                        content: const Text(
                          "Please enter a name",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    );
                  } else {
                    DbHelper dbHelper = DbHelper();
                    await dbHelper.addName(name);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }
                },
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    Icon(Icons.navigate_next_rounded),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
