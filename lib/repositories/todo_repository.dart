import 'package:todo_list_database/db/dbhelper.dart';
import 'package:todo_list_database/models/todo.dart';

class TodoRepository {
  final DBHelper _dbHelper; // = DBHelper();
  TodoRepository(this._dbHelper);

  Future<bool> addTodo(Todo tarefa) async{
    try {
      var db = await _dbHelper.getDB();
      var idInserido = await db.insert('tarefa', tarefa.toMap());
      print('id inserido: $idInserido');
      return idInserido > 0;
    } catch (e) {
      return false;
    }
  }

  Future<List<Todo>> getTodo() async {
    try {
      await Future.delayed(Duration(seconds: 2));

      var db = await _dbHelper.getDB();
      var dados = await db.query('tarefa');
      var listaTodo = dados.map((e) => Todo.fromMap(e)).toList();
      
      return listaTodo ?? [];
    } catch (e) {
      throw 'Erro ao recuperar tarefas';
    }
  }

  Future<bool> updateTodo(Todo tarefa) async {
    try {
      var db = await _dbHelper.getDB();
      var retorno = await db.update('tarefa', tarefa.toMap(), where: 'id = ?', whereArgs: [tarefa.id]);
      return retorno > 0;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTodo(int id) async {
    try {
      var db = await _dbHelper.getDB();
      var retorno = await db.delete('tarefa', where: 'id = ?', whereArgs: [id]);
      return retorno > 0;
    } catch (e) {
      return false;
    }
  }
}