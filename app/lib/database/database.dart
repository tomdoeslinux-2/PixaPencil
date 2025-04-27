import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Creations extends Table {
  late final IntColumn id = integer().autoIncrement()();
  late final TextColumn title = text().withLength(min: 1, max: 250)();
  late final DateTimeColumn createdAt = dateTime().nullable()();
}

@DriftDatabase(tables: [Creations])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'app_db');
  }
}