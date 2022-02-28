import 'package:anotacoes/helper/Helper.dart';
import 'package:flutter/material.dart';

class Anotacao {
  late int id ;
  late String titulo;
  late String descricao;
  late String data;


  Anotacao(this.titulo,this.descricao,this.data){}

  Anotacao.fromMap(Map map){

     this.id = map[Helper.id];
     this.titulo =map[Helper.titulo];
     this.descricao = map[Helper.descrcao];
     this.data = map[Helper.data];
  }

  Map toMap(){
     Map<String,dynamic> map = {
       "titulo" : this.titulo,
       "descricao"  : this.descricao,
       "data" : this.data
     };

     return map;
  }

}