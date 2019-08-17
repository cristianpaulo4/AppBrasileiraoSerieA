import 'dart:convert';
import 'dart:ui' as prefix0;
import 'package:app_jogo/Aposta.dart';
import 'package:app_jogo/dadosJogo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix1;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

String nome = 'sem';
String rod = '1';

void main() => runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(primarySwatch: Colors.teal),
      routes: {
        'Aposta':(context)=>Aposta()
      },
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rodadas: $rod"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                int x = int.parse(rod);
                if (x > 1) {
                  rod = (x - 1).toString();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                int x = int.parse(rod);
                if (x < 38) {
                  rod = (x + 1).toString();
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: listar(),
        builder: (c, dados) {
          if (dados.hasError) {
            return Container(
              child: Center(
                child: Icon(
                  Icons.error_outline,
                  size: 150,
                  color: Colors.black45,
                ),
              ),
            );
          }
          if (dados.hasData) {
            //return Iten(itens: dados.data);
            return criar(context, dados.data);
          } else {
            int x = int.parse(rod);
            rod = (x + 1).toString();

            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,       
    
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(onPressed: (){},icon: Icon(Icons.ac_unit),color: Colors.white,), 
              IconButton(onPressed: (){},icon: Icon(Icons.ac_unit),color: Colors.white,), 
              IconButton(onPressed: (){},icon: Icon(Icons.ac_unit),color: Colors.white,), 
              IconButton(onPressed: (){},icon: Icon(Icons.ac_unit),color: Colors.white,), 
              IconButton(onPressed: (){},icon: Icon(Icons.ac_unit),color: Colors.white,), 
              IconButton(onPressed: (){},icon: Icon(Icons.ac_unit),color: Colors.white,), 
            ],
          )
         
        



      ),
    );
  }
}

// pegando dados dos jogos
Future<Map> listar() async {
  http.Response res = await http.get(
      "http://jsuol.com.br/c/monaco/utils/gestor/commons.js?callback=simulador_dados_jsonp&file=commons.uol.com.br/sistemas/esporte/modalidades/futebol/campeonatos/dados/2019/30/dados.json");
  String resultado = res.body.toString();
  resultado = resultado.substring(22, resultado.length - 3);
  return json.decode(resultado);
}

// novo
Widget criar(BuildContext context, Map Item) {
  Map itens = Item;
  String rodada;
  var time1, time2;
  var jogo;
  String placar1, placar2;

  return ListView.builder(
    itemCount: 10,
    itemBuilder: (x, i) {
      rodada = itens['fases']["2878"]['jogos']['rodada'][rod][i];
      jogo = itens['fases']['2878']['jogos']['id'][rodada];
      time1 = itens['equipes'][jogo['time1']];
      time2 = itens['equipes'][jogo['time2']];    
      placar1 = jogo['placar1'] == null ? '-' : jogo['placar1'];
      placar2 = jogo['placar2'] == null ? '-' : jogo['placar2'];
      // dados da partida
      dadosJogo t1 = new dadosJogo();
      dadosJogo t2 = new dadosJogo();

      // dados time 1
      t1.setTime(time1['nome-comum']);
      t1.setBrasao(time1['brasao']);
      t1.setPlacar(placar1);
      t1.setData(jogo['data']==null?'Não definido!':jogo['data']);
      t1.setHora(jogo['horario']==''?'Não definido!': jogo['horario']);
      t1.setLocal(jogo['local']==''?'Não definido!':jogo['local']);
      

      // dados time 2
      t2.setTime(time2['nome-comum']);
      t2.setBrasao(time2['brasao']);
      t2.setPlacar(placar2);
     

      return Column(
        children: <Widget>[
          Container(
            height: 80,
            child: RaisedButton(
              color: Colors.white,
              onPressed: () {
                _alerta(context, t1, t2);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: Center(
                        child: Text(time1['sigla'],
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                      ),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    child: Image.network(time1['brasao']),
                  ),
                  Text(
                    "  " + placar1 + " X " + placar2 + "  ",
                    style: TextStyle(
                        fontSize: 25, color: Theme.of(context).primaryColor),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    child: Image.network(time2['brasao']),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: Center(
                        child: Text(
                          time2['sigla'],
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.black45,
            height: 3,
          )
        ],
      );
    },
  );
}

// alerta
_alerta( BuildContext context, dadosJogo t1,dadosJogo t2,){
  return showDialog(
      context: context,   
        child: SingleChildScrollView(
        child: AlertDialog(
        content: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                                
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Image.network(t1.getBrasao()),
                        Text("\n"+t1.getTime())
                      ],
                    ),
                  ),
                ),
                Text(
                  t1.getPlacar() + "  X  " + t2.getPlacar(),
                  style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),

                Expanded(
                  child: Container(
                    child:  Column(
                      children: <Widget>[
                        Image.network(t2.getBrasao()),
                        Text("\n"+t2.getTime())
                      ],
                    ),
                  ),
                )
              ],
            ),

            Divider(color: Colors.black45,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[                
                Text("Local: "+t1.getLocal().toString()),
                Text("Data: "+t1.getData()),
                Text("Hora: "+t1.getHora()),            
              ],
            ),

             Divider(color: Colors.black45,),
             Text(t1.getPlacar()=='-'?'Você pode apostar!':'Você não pode mais apostar!', style: TextStyle(fontSize: 25,),),

             if(t1.getPlacar()=='-'?true:false)
          
             Padding(
                padding: EdgeInsets.only(top: 40),
                child: ClipRRect(
               borderRadius: BorderRadius.circular(50),
               child: Container( 
                 height: 50,
                 width: 330,
                 child: RaisedButton(
                   color: Theme.of(context).primaryColor,
                   onPressed: (){                    
                     Navigator.popAndPushNamed(context, 'Aposta');
                   },
                   child: Text("Apostar", style: TextStyle(color: Colors.white, fontSize: 20),),
                 )
               ),
             ),
             )
          
         
          ],
        ),
        actions: <Widget>[
          FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"),)
        ],
      ),
        )
      
      );
}
