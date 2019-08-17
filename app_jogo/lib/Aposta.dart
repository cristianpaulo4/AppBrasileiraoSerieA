import 'package:flutter/material.dart';


class Aposta extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bolão Disponíveis"),
      ),

      body: ListView(
        children: <Widget>[
          Card(
            child: Text("R\$: 2,00", style: TextStyle(fontSize: 50),),
          ),
          Card(
            child: Text("R\$: 5,00", style: TextStyle(fontSize: 50),),
          ),
          Card(
            child: Text("R\$:10,00", style: TextStyle(fontSize: 50),),
          ),
        ],
      ),
      
    );
  }
}