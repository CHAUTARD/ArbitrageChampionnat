import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DataClassName('Player')
class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get letter => text().withLength(min: 1, max: 2)();
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
  IntColumn get equipe1Id => integer().references(Equipes, #id)();
  IntColumn get equipe2Id => integer().references(Equipes, #id)();
  IntColumn get niveau => intEnum<Niveau>()();
  DateTimeColumn get date => dateTime()();
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

@DataClassName('Manche')
class Manches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partieId => integer().references(Parties, #id)();
  IntColumn get mancheNumber => integer().withDefault(const Constant(0))(); // Added this column
  IntColumn get scoreEquipe1 => integer()();
  IntColumn get scoreEquipe2 => integer()();
}


@DriftDatabase(tables: [Players, Equipes, Rencontres, Parties, Manches])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3; // Incremented schema version

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
           // m.addColumn(parties, parties.winner);
        }
        if (from < 3) {
          await m.addColumn(manches, manches.mancheNumber);
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
