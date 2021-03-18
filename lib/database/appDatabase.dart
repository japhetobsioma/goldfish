import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';

part 'appDatabase.g.dart';

/* class HydrationPlans extends Table {
  /* IntColumn get id => integer()();
  TextColumn get gender => text()();
  DateTimeColumn get birthday => dateTime()();
  DateTimeColumn get wakeupTime => dateTime()();
  DateTimeColumn get bedtime => dateTime()();
  IntColumn get dailyGoal => integer()();
  TextColumn get liquidMeasurement => text()();
  BoolColumn get isUsingRecommendedDailyGoal =>
      boolean().withDefault(Constant(true))();
  DateTimeColumn get joinedDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id}; */
} */

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return VmDatabase(file, logStatements: true);
  });
}

@UseMoor(include: {'tables.moor'})
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /* Future<List<HydrationPlan>> getAllHydrationPlans() =>
      select(hydrationPlans).get();
  Stream<List<HydrationPlan>> watchAllHydrationPlans() =>
      select(hydrationPlans).watch();
  Future insertHydrationPlan(HydrationPlan hydrationPlan) =>
      into(hydrationPlans).insert(hydrationPlan);

  Future updateHydrationPlan(HydrationPlan hydrationPlan) =>
      update(hydrationPlans).replace(hydrationPlan);
  Future deleteHydrationPlan(HydrationPlan hydrationPlan) =>
      delete(hydrationPlans).delete(hydrationPlan); */
}
