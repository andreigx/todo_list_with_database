import 'package:flutter/material.dart';

class Todo {
  int id;
  String nome;
  bool concluido;


  Todo({this.id, @required this.nome, this.concluido,});

  Todo.fromMap(Map<String, dynamic> map){
    id = map['id'];
    nome = map['nome'];
    concluido = map['concluido'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'nome': nome,
      'concluido': concluido ?? false ? 1 : 0
    };
  }
  
}