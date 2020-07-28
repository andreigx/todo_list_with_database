import 'package:flutter/material.dart';
import 'package:todo_list_database/db/dbhelper.dart';
import 'package:todo_list_database/models/todo.dart';
import 'package:todo_list_database/repositories/todo_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoRepository _todoTasks;
  final taskController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _addNewTodo() async {
    var salvou = await _todoTasks.addTodo(Todo(nome: taskController.text));

    if (salvou) {
      taskController.text = '';
      _showSnackBar('Inserido com sucesso', Colors.green);
    } else {
      _showSnackBar('Ocorreu um erro [INSERT]', Colors.red);
    }
  }

  void _showSnackBar(String texto, Color cor) {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$texto'),
          backgroundColor: cor,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        )
      );
  }

  @override
  void initState() {
    super.initState();
    _todoTasks = TodoRepository(DBHelper());    
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
      ),
      key: _scaffoldKey,
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  flex: 7,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tarefa'
                    ),
                    controller: taskController,
                  )
                ),
                SizedBox(width: 8,),
                Flexible(
                  flex: 3,
                  child: RaisedButton(
                    onPressed: () async {
                      if (taskController.text.isNotEmpty){
                        await _addNewTodo();
                        setState(() { });
                      } else {
                        _showSnackBar('Digite uma tarefa para inserir', Colors.red);
                      }
                    },
                    child: Text('Adicionar'),
                    color: Colors.white,
                    textColor: Colors.black,
                  )
                )
              ],
            ),
            SizedBox(height: 8,),
            FutureBuilder<List<Todo>>(
              future: _todoTasks.getTodo(),
              initialData: null,
              builder: (context, snapshot) {
                 if (!snapshot.hasData && !snapshot.hasError) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (!snapshot.hasData && snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }
                return Flexible(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index].nome),
                        trailing: Checkbox(
                          value: snapshot?.data[index].concluido, 
                          onChanged: (valor) async {
                            snapshot?.data[index].concluido = valor;
                            var done = await _todoTasks.updateTodo(snapshot?.data[index]);
                            setState(() { });
                            if (done) {
                              _showSnackBar('Atualizado', Colors.green);
                            } else {
                              _showSnackBar('Ocorreu um erro [UPDATE]', Colors.red);
                            }
                          }
                        ),
                        onLongPress: () async {
                          var done = await _todoTasks.deleteTodo(snapshot?.data[index].id);
                          setState(() { });
                          if (done) {
                            _showSnackBar('Excluído com sucesso', Colors.green);
                          } else {
                            _showSnackBar('Ocorreu um erro [DELETE]', Colors.red);
                          }
                        },
                      );
                    }
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
