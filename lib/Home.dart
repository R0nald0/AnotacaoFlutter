import 'package:anotacoes/helper/Helper.dart';
import 'package:anotacoes/model/Anotacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HomeState();
}


class HomeState extends State<Home>{


  TextEditingController _controllerTitulo = TextEditingController();
  TextEditingController _controllerDescricacao =TextEditingController();
  var db = Helper();
  List _anotacoes = [];
  String _salvarAtualizar ="";
  String _titulo="";
  Map<String,dynamic> anoRem = Map();



 _formatarData(String data){

   initializeDateFormatting("pt_BR");
    
  // var Fotmata = DateFormat.yMMMMd("pt_BR");
   DateTime dateTime = DateTime.parse(data);
   String dataConvertida =DateFormat.yMd("pt_BR").format(dateTime);
    return dataConvertida;
 }

  _salvarAnotacaoSnack( index,Anotacao ultimaAnotacaoRemovida) async{
    Anotacao anotacao = Anotacao(
        ultimaAnotacaoRemovida.titulo,
        ultimaAnotacaoRemovida.descricao,
        ultimaAnotacaoRemovida.data
    );

    _anotacoes.insert(index,anotacao);
    int i = await db.salvarDados(anotacao);
    _listaAnototacaoRecup();
  }

 @override
  void initState() {
   super.initState();
    _listaAnototacaoRecup();
 }

 @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar:  AppBar(
          title: Text("Minhas Anotações"),
          backgroundColor: Colors.green,
        ),

        drawer: Drawer(
           child: Container(
              child: Column(
                children: <Widget>[
                    UserAccountsDrawerHeader(
                        currentAccountPicture: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network("https://imgproxy.ojc.com.br/insecure/fit/800/414/ce/0/plain/https%3A%2F%2Fopopular.com.br%2Fpolopoly_fs%2F1.976529.1564753782%21%2Fimage%2Fimage.jpg_gen%2Fderivatives%2Flandscape_800%2Fimage.jpg")
                        ),
                        accountName:Text("Miau da Silva"),
                        accountEmail:Text("miau@yahoo.com")
                    ),

                  ListTile(
                      title: Text("Incio"),
                      leading: Icon(Icons.home),
                  )
                ]
              ),
           ),
        ),

        body:Container(
          padding: EdgeInsets.all(4),
          child: Expanded(
            child: ListView.builder(
                itemCount: _anotacoes.length,
                itemBuilder: (context,index){

                     final anotacao = _anotacoes[index];

                     return dismissible(anotacao, index, context);

                }
            ),
          ),
        ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add
        ),
        elevation: 10,
        backgroundColor: Colors.green,
        onPressed: (){
               mostrarDialog(context);
        },
      ),


    );

  }

  dismissible(Anotacao anotacao,int index,context){
    return Dismissible(
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
        background: Container(
          color: Colors.green,
          padding: EdgeInsets.all(16),
          child: Row( crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget> [
              Icon(Icons.mode_edit,color: Colors.white70,),
              Text("   Editar")
            ],
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          padding: EdgeInsets.all(16),
          child: Row(mainAxisAlignment:MainAxisAlignment.end,
            children: <Widget>[
              Text("Deletar    "),
              Icon(
                Icons.delete,color: Colors.white,)
            ],
          ),
        ),

        onDismissed: (direction){
          if(direction == DismissDirection.startToEnd){
            return mostrarDialog(context,anotacao: anotacao);
          }else if(direction == DismissDirection.endToStart){

            //obter a anotaçao removida///
            Anotacao anotacaoDel= _anotacoes[index];

            print("removida :" + anotacaoDel.id.toString());
            apagarAnotacao(anotacao);

            final snackBar =SnackBar(
              content: Text("Anotação Removida" ),
              action: SnackBarAction(
                label: "Desfazer",
                onPressed:(){

                  setState(() {
                    _salvarAnotacaoSnack(index, anotacaoDel);
                    print("reeinserido :" + anotacaoDel.toString());
                  });

                } ,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          };
        },
        child: _listCard(anotacao)
    );
  }

  _listCard(Anotacao anotacao){
     return Card(
      child: ListTile(
        title: Text("Titulo: ${anotacao.titulo}"),
        subtitle: Text(" Data: ${_formatarData(anotacao.data)} \n\n "
            "Descrição: ${anotacao.descricao}" ),
        trailing:  Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
                onPressed: (){
                  return mostrarDialog(context,anotacao: anotacao);
                },
                icon: Icon(
                  Icons.edit,color: Colors.green,
                )
            )
          ],
        ),
      ),
    );
  }

_editarNota(context){

   return AlertDialog(

     title:Text("Editar Nota"),
     content: SingleChildScrollView(
       child: Column(
         mainAxisSize: MainAxisSize.min,
         children: <Widget>[
           TextField(
             controller: _controllerTitulo,
             decoration: InputDecoration(
               labelText:"Título",
             ),
             autofocus: true,
           ),

           TextField(
             decoration: InputDecoration(
               labelText: "Descriçao",
             ),
           ),
         ],
       ),
     ),

     actions: <Widget>[
       Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[

             TextButton(
                 onPressed: (){},
                 child:Text("Atualizar")
             ),
              TextButton(
                  onPressed: (){
                     Navigator.pop(context);
                  },
                  child: Text("Cancelar")
              ),

          ],
       ),
     ],
   );

}

  mostrarDialog( context,{Anotacao? anotacao}){
      if(anotacao == null ){
         _controllerTitulo.text ="";
         _controllerDescricacao.text ="";
          _salvarAtualizar="Salvar";
          _titulo="Título";

      }  else{
        _controllerTitulo.text = "${anotacao.titulo}";
        _controllerDescricacao.text ="${anotacao.descricao}";
        _salvarAtualizar="Atualizar";
        _titulo="Editar Descrição: ${anotacao.titulo}";

      }

     showDialog(
         context: context,
         builder: (context){
           return AlertDialog(
             title: Text("${_titulo}"),
             content:
             Container(
               child: SingleChildScrollView(

                 padding: EdgeInsets.all(10),
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: <Widget>[

                     TextField(
                       controller: _controllerTitulo,
                       autofocus: true,
                       decoration: InputDecoration(
                           label: Text("Titulo"),
                           hintText: "Escreva o Título..",
                           focusColor: Colors.green
                       ),
                     ),
                     TextField(
                       controller: _controllerDescricacao,
                       decoration: InputDecoration(
                           labelText: "Descrição",
                           hintText: "Escreva a descrição...."
                       ),
                     ),
                   ],
                 ),

               ),
             ),
             actions: <Widget>[

               Row(mainAxisAlignment: MainAxisAlignment.end,
                 children: <Widget>[

                   TextButton(
                       onPressed: (){
                         Navigator.pop(context);
                        return  _listaAnototacaoRecup();
                       },
                       child: Text("Cancelar")
                   )
                   ,TextButton(
                       onPressed: (){
                         _criarAtualizarAnotacao(anotacaoAtl: anotacao);
                         Navigator.pop(context);
                       },
                       child: Text("${_salvarAtualizar}")
                   ),

                 ],
               )
             ],

           );
         }
     );
  }

  _listaAnototacaoRecup() async {
     List anotacaoeRecuperad = await db.Select();
     List <Anotacao>? listaTemporaria= [];

     for(var item in anotacaoeRecuperad ){
         Anotacao _anotacao =   Anotacao.fromMap(item);
         listaTemporaria.add(_anotacao);
     }
     print(" teste :  " + _anotacoes.toString());

     setState(() {
          _anotacoes = listaTemporaria!;
     });

     listaTemporaria = [];
     return _anotacoes;
 }

 _criarAtualizarAnotacao({Anotacao? anotacaoAtl}) async {

   String titulo = _controllerTitulo.text;
   String descricao = _controllerDescricacao.text;
   String dataAtual = DateTime.now().toString();

    if(anotacaoAtl == null){
      Anotacao anotacao = await Anotacao(titulo,descricao,dataAtual);
      int res = await db.salvarDados(anotacao) ;


    }else{
      anotacaoAtl.titulo=titulo;
      anotacaoAtl.descricao=descricao;
      anotacaoAtl.data =DateTime.now().toString();

      int res =  await db.atualizatAnotcao(anotacaoAtl);
      print(" ATUALIZAR :" + res.toString());
    }

      _controllerTitulo.clear();
      _controllerDescricacao.clear();
      _listaAnototacaoRecup();

 }

 apagarAnotacao(Anotacao anotacao) async{


   int retorno = await db.deleteAnocao(anotacao);
   print(" ATUALIZAR :" + retorno.toString());
   _listaAnototacaoRecup();

 }

 _dismissbleDelet(final  index){



 }

}