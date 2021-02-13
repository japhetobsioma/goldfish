import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = 'goldfish.db';
  static const _databaseVersion = 1;

  static const table = 'user_information';

  static const columnId = 'id';
  static const columnGender = 'gender';
  static const columnBirthday = 'birthday';
  static const columnAge = 'age';
  static const columnWakeUpTime = 'wakeUpTime';
  static const columnBedtime = 'bedtime';
  static const columnWaterIntakeGoal = 'waterIntakeGoal';

  static const queryOnCreate = '''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnGender TEXT NOT NULL,
            $columnBirthday TEXT NOT NULL,
            $columnAge INTEGER NOT NULL,
            $columnWakeUpTime TEXT NOT NULL,
            $columnBedtime TEXT NOT NULL,
            $columnWaterIntakeGoal REAL NOT NULL
          )
          ''';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(queryOnCreate);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    var db = await instance.database;
    return await db.insert(
      table,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    var db = await instance.database;
    return await db.query(table);
  }
}
