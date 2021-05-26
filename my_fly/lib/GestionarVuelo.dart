import 'package:flutter/material.dart';
//libreria http para realizar consultas a internet
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'model/ParseJson.dart';

class GestionarVuelo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestionarAvionState();
  }
}

Future obtenerU() async {
  print("se ejecutó");

  //indicar que el http es cliente
  var httpClient = http.Client();

  Uri request = Uri.parse('http://localhost/restful_php/');
  //has una peticion http
  http.Response response = await httpClient.get(request, headers: {'Content-type':'application/json'});
  Map parseData = await json.decode(response.body);

  print('el nombre es: ${parseData['nombre']}');

  //final resp = await http.get(Uri.parse('http://reqres.in/api/users'));

  /*obtengo el json
  var list = await json.decode(resp.body).cast<Map<String, dynamic>>();

  //transforma Json a modelo
  lista =
      await list.map<Response>((json) => new Response.fromJson(json)).toList();

  print('este es el dato ${lista[0].page}');
  

  return Future.delayed(Duration(seconds: 1), () => 'Hola mundo');
  */
}

class GestionarAvionState extends StatefulWidget {
  GestionarAvionState({Key key}) : super(key: key);

  @override
  _GestionarAvionStateState createState() => _GestionarAvionStateState();
}

class _GestionarAvionStateState extends State<GestionarAvionState> {
  @override
  Widget build(BuildContext context) {
    
    throw UnimplementedError();
  }
}

 


  