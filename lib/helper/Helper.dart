
import 'package:anotacoes/model/Anotacao.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/*
class Helper{
  static final String nomeDaTabela = "anotacao";

  // PADRAO DE PROJETO SINGLETON
  static final Helper _anotacaoHelper = Helper._internal();
  late Database _db ;

  factory Helper(){return _anotacaoHelper;}

   Helper._internal(){}

  get db async{

    if( _db  != null){
       return _db;
    }else{
      _db = await InicializarBD();
      return _db;
     }
  }


  _onCreate(db,version )async{

     String sql = "CREATE TABLE ${nomeDaTabela}("
         "id INTEGER PRIMARY KEY AUTOINCREMENT,"
         "titulo VARCHAR,"
         "descricao TEXT ,"
         "data DATETIME "
         ")";//CREATE TABL FIM
     await db.execute(sql);

     print(" DB " + db.toString());
     return db;
  }



  InicializarBD() async{

    final caminhoBancodeDados = await getDatabasesPath();
    final localBancoDeDados = join(caminhoBancodeDados,"banco_minhas_anotacoes.db");
    print("LOCAL" + localBancoDeDados);


    var db =await openDatabase(localBancoDeDados,version: 1,onCreate:_onCreate );

    return db;
  }

 Future<int> InserirAnotacao(Anotacao anotacao) async{

    var bancoDeDados = await  db;
    int resultado = await bancoDeDados.insert(nomeDaTabela, anotacao.toMap());
    return resultado;

  }

}


 */



class Helper {
  late Database _db;
  static final String nomeTabela = "anotacao";
  static final String titulo = "titulo";
  static final String id = "id";
  static final String data = "data";
  static final String descrcao = "descricao";


  static final Helper _anotacaoHelper = Helper._internal();
  factory Helper(){return _anotacaoHelper;}
  Helper._internal();

  get db async{
     if(  InicializarBD() == null){
        _db =  await InicializarBD();
        var a = Helper();
        var b = Helper();
        print("TESTE " + identical(a, b).toString());
     }else{

       return InicializarBD();
     }
  }

  InicializarBD() async{

    final caminhoBancodeDados = await getDatabasesPath();
    final localBancoDeDados = join(caminhoBancodeDados,"banco_minhas_anotacoes.db");
    print("LOCAL" + localBancoDeDados);

    var db =await openDatabase(localBancoDeDados,version: 1,onCreate:_onCreate );

    print("RESILTADO : "+ db.toString());
     return db;
  }

  _onCreate(db,versao)async {

          String sql = "CREATE TABLE ${nomeTabela}("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "titulo VARCHAR,"
              "descricao TEXT ,"
              "data DATETIME "
              ")";//CREATE TABL FIM
           db.execute(sql);

  }

   Future<int> salvarDados(Anotacao anotacao) async{
      var bd = await db;

    int id = await bd.insert(nomeTabela,anotacao.toMap());
    print("Resultado : " + id.toString());

     return id;

  }

  Select() async{
    Database bd =await db;
    String sql ="SELECT * FROM ${nomeTabela} ORDER BY data DESC";

    List anotacoes = await bd.rawQuery(sql) ;

     return anotacoes;
  }

  atualizatAnotcao(Anotacao anotacao) async{
       var bd = await db;

        return await bd.update(
            nomeTabela,
          anotacao.toMap(),
          where: "id=?",
          whereArgs: [anotacao.id]
        );
  }


  deleteAnocao(Anotacao anotacao) async{
    var bd = await db;

    return await bd.delete(
        nomeTabela,
      where: "id = ?",
      whereArgs: [anotacao.id]
    );

  }

}