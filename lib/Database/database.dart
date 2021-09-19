import 'package:expense_tracker/Model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  String? path;
  String trackerTable = 'Tracker';
  DatabaseService._();
  static final DatabaseService db = DatabaseService._();
  Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await innitialize();
    return _database;
  }

 Future<Database> innitialize() async {
    String path = await getDatabasesPath();
    path = join(path, 'tracker.db');
    print('Entered path : $path');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Tracker(id INTEGER PRIMARY KEY, description TEXT, amount TEXT, date TEXT, isIncome INTEGER);');
      print('New table created at $path');
    });
  }

  Future<List<TrackerModel>> getDataFromDB() async {
    final db = await database;
    List<TrackerModel> dataList = [];
    List<Map<String, dynamic>> maps = await db!.query('tracker',
        columns: ['id', 'description', 'amount', 'isIncome', 'date DESC']);
    if (maps.length > 0) {
      maps.forEach((map) {
        dataList.add(TrackerModel.fromMap(map));
      });
    }
    return dataList;
  }

  Future<TrackerModel> addDataIntoDB(TrackerModel newData) async {
    final db = await database;
    if (newData.description!.trim().isEmpty)
      newData.description = 'Description';
    int id = await db!.transaction((transaction) {
      return transaction.rawInsert(
          'INSERT into Tracker(amount, description, date, isIncome) VALUES ("${newData.amount}", "${newData.description}", "${newData.date}", ${newData.isIncome});');
    });
    newData.id = id;
    print(
        'Data Added : ${newData.amount} , ${newData.description} , ${newData.date} , ${newData.isIncome} , ${newData.id}');
    return newData;
  }

 Future<int> deleteDataFromDB(int id) async {
		final db = await database;
		int result = await db!.rawDelete('DELETE FROM $trackerTable WHERE id = $id');
    print('Data Deleted : $id');
		return result;
	}

  Future<List<Map<String, dynamic>>> getDataMapList() async {
    final db = await database;
    var result = await db!.query(trackerTable);
    return result;
  }

  Future<int> getCount() async {
    final db = await database;
    List<Map<String, dynamic>> count =
        await db!.rawQuery('SELECT COUNT (*) from Tracker');
    int? result = Sqflite.firstIntValue(count);
    return result!;
  }

  Future<List<TrackerModel>> getDataList() async {
    var mapDataList = await getDataMapList();
    int count = mapDataList.length;
    List<TrackerModel> dataList = [];
    for (int i = 0; i < count; i++) {
      dataList.add(TrackerModel.fromMap(mapDataList[i]));
    }
    return dataList;
  }
  Future<List<Map<String, dynamic>>> getData(String tableName) async {
    final db = await innitialize();
    return await db.query('Tracker', orderBy: "date DESC");
  }
}
