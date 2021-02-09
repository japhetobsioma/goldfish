import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = 'goldfish.db';
  static final _databaseVersion = 1;

  static final table = 'user_information';

  static final columnId = 'id';
  static final columnGender = 'gender';
  static final columnDateOfBirth = 'dateOfBirth';
  static final columnAge = 'age';
  static final columnWakeUpTime = 'wakeUpTime';
  static final columnBedtime = 'bedtime';
  static final columnWaterIntakeGoal = 'waterIntakeGoal';

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
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnGender TEXT NOT NULL,
            $columnDateOfBirth TEXT NOT NULL,
            $columnAge INTEGER NOT NULL,
            $columnWakeUpTime TEXT NOT NULL,
            $columnBedtime TEXT NOT NULL,
            $columnWaterIntakeGoal REAL NOT NULL
          )
          ''');
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
