import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DataClassName('Player')
class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get letter => text().withLength(min: 1, max: 1)();
  TextColumn get name => text()();
  IntColumn get equipeId => integer().references(Equipes, #id)();
}

@DataClassName('Equipe')
class Equipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

enum Niveau { departemental, regional, national }

@DataClassName('Rencontre')
class Rencontres extends Table {
  IntColumn get id => integer().autoIncrement()();
  @ReferenceName('equipe1')
  IntColumn get equipe1Id => integer().references(Equipes, #id)();
  @ReferenceName('equipe2')
  IntColumn get equipe2Id => integer().references(Equipes, #id)();
  IntColumn get niveau => intEnum<Niveau>()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get scoreAcquit => boolean().withDefault(const Constant(false))();
}

@DataClassName('Partie')
class Parties extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get rencontreId => integer().references(Rencontres, #id)();
  IntColumn get partieNumber => integer()();
  @ReferenceName('j1e1')
  IntColumn get joueur1Equipe1Id => integer().references(Players, #id)();
  @ReferenceName('j2e1')
  IntColumn get joueur2Equipe1Id => integer().nullable().references(Players, #id)();
  @ReferenceName('j1e2')
  IntColumn get joueur1Equipe2Id => integer().references(Players, #id)();
  @ReferenceName('j2e2')
  IntColumn get joueur2Equipe2Id => integer().nullable().references(Players, #id)();
  @ReferenceName('arbitre')
  IntColumn get arbitreId => integer().nullable().references(Players, #id)();
  BoolColumn get isPlayed => boolean().withDefault(const Constant(false))();
  IntColumn get winner => integer().nullable()(); // 1 or 2
}

@DataClassName('Score')
class Scores extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partieId => integer().references(Parties, #id)();
  IntColumn get setNumber => integer()();
  IntColumn get scoreEquipe1 => integer()();
  IntColumn get scoreEquipe2 => integer()();
}

@DriftDatabase(tables: [Players, Equipes, Rencontres, Parties, Scores])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        // Recreate all tables
        for (final table in allTables) {
          await m.deleteTable(table.actualTableName);
          await m.createTable(table);
        }
      },
       beforeOpen: (details) async {
        if (details.wasCreated) {
          // Create default data
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
