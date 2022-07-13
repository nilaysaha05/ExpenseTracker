import 'package:hive_flutter/hive_flutter.dart';

class DbHelper {
  late Box box;

  DbHelper() {
    openBox();
  }

  openBox() {
    box = Hive.box("money");
  }

  Future addData(
    double amount,
    DateTime date,
    String note,
    String type,
  ) async {
    var value = {
      'amount': amount,
      'date': date,
      'note': note,
      'type': type,
    };
    box.add(value);
  }
  Future<Map> fetch()
  {
    if(box.values.isEmpty)
      {
        return Future.value({});
      }
    else{
      return Future.value(box.toMap());
    }
  }
}
