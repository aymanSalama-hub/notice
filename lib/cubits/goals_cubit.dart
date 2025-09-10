import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notes_app/cubits/goals_state.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GoalsCubit extends Cubit<GoalsState> {
  GoalsCubit() : super(InitailState());

  static GoalsCubit get(context) => BlocProvider.of<GoalsCubit>(context);

  var addTextController = TextEditingController();

  initSql() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'goals.db');

    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Goals (id INTEGER PRIMARY KEY, name TEXT)',
        );
      },
    );
  }

  List<Map> goalsList = [];

  getData() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'goals.db');
    Database database = await openDatabase(path);

    await database
        .rawQuery('SELECT * FROM Goals')
        .then((value) {
          goalsList = value;
          emit(GetDataSccess());
        })
        .catchError((errr) {
          emit(GetDataFaliure());
          print(errr.toString());
        });

    database.close();
  }

  inserData(String name) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'goals.db');
    Database database = await openDatabase(path);

    await database
        .rawInsert('INSERT INTO Goals(name) VALUES(?)', [name])
        .then((value) {
          emit(InsertDataSccess());
        })
        .catchError((error) {
          emit(InsertDataFaliure());
          print(error.toString());
        });

    database.close();
  }

  removeData(id) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'goals.db');
    Database database = await openDatabase(path);

    await database
        .rawDelete('DELETE FROM Goals WHERE id = ?', [id])
        .then((value) {
          emit(RemoveDataSccess());
        })
        .catchError((error) {
          emit(RemoveDataFaliure());
          print(error.toString());
        });
    database.close();
  }

  updateData(id, name) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'goals.db');
    Database database = await openDatabase(path);
    await database
        .rawUpdate('UPDATE Goals SET name = ? WHERE id = ?', [name, id])
        .then((value) {
          emit(UpdateDataSccess());
        })
        .catchError((error) {
          emit(UpdateDataFaliure());
          print(error.toString());
        });
    database.close();
  }
}
