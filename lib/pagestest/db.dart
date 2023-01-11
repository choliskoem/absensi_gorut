// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class MyDb{
//    Database? database;
//
//   Future open() async {
//     // Get a location using getDatabasesPath
//     var databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, 'demo2.db');
//     //join is from path package
//     print(path); //output /data/user/0/com.testapp.flutter.testapp/databases/demo.db
//
//     Database database = await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//           // When creating the db, create the table
//           await db.execute(
//               'CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, roll_no INTEGER, address TEXT)');
//         });
//           //table students will be created if there is no table 'students'
//           print("Table Created");
//
//   }
//
// Future<Map<dynamic, dynamic>?> getStudent(int rollno) async {
//   List<Map> maps = await database!.query('students',
//       where: 'roll_no = ?',
//       whereArgs: [rollno]);
//   //getting student data with roll no.
//   if (maps.length > 0) {
//     return maps.first;
//   }
//   return null;
// }
// }