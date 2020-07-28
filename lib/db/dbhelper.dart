import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  Database _db;
  static DBHelper _instancia = DBHelper._interno(); 
  factory DBHelper() => _instancia;
  DBHelper._interno();

  Future<Database> getDB() async {
    if (_db == null){
      var _directory = await getApplicationDocumentsDirectory();
      var _path = join(_directory.path, 'todo_list.db');
      _db = await openDatabase(_path, version: 1, onCreate: _onCreate);
    }
    return _db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      create table tarefa(
        id integer primary key autoincrement,
        nome text not null,
        concluido integer not null default 0
      );
      '''
    );
  }
}