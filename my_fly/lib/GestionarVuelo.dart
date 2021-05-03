import 'package:flutter/material.dart';
//libreria http para realizar consultas a internet
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'model/ParseJson.dart';

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
  List<String> aviones = ['One-avi', 'Two-avi', 'One-spir', 'Three-air'];
  List<int> precios = [500, 900, 1000, 4000, 8000, 10000];
  List<String> itinerarios = ['itinerario 1', 'itinerario 2', 'itinerario 3'];
  String selecionAvion = "Seleccionar el avion";
  String selecionPrecios = "Seleccionar el precio";
  String seleccionarIti = 'Seleccionar Itinerario';
  Future<String> res;
  int id = 1;

  @override
  void initState() {
    super.initState();
    print('inicio el programa');
    obtenerU();
  }

  void tarea() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestionar vuelo')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              containerOne(),
              containerTwo(
                  width: 400.0,
                  height: 500.0,
                  margin: 50.0,
                  child: Column(children: [
                    SizedBox(
                      height: 160.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$id', style: TextStyle(fontSize: 20.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 190.0,
                        height: 40.0,
                        child: DropdownButton(
                          hint: Text('$selecionAvion'),
                          dropdownColor: Colors.grey,
                          elevation: 5,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36.0,
                          onChanged: (value) {
                            setState(() {
                              selecionAvion = value;
                            });
                          },
                          items: aviones
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 190.0,
                        height: 40.0,
                        child: DropdownButton(
                          hint: Text('$seleccionarIti'),
                          dropdownColor: Colors.green[50],
                          elevation: 5,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36.0,
                          onChanged: (value) {
                            setState(() {
                              seleccionarIti = value;
                            });
                          },
                          items: itinerarios
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200.0,
                        height: 40.0,
                        child: DropdownButton(
                          hint: Text('$selecionPrecios'),
                          dropdownColor: Colors.grey,
                          elevation: 5,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36.0,
                          onChanged: (value) {
                            setState(() {
                              selecionPrecios = value.toString();
                            });
                          },
                          items: precios
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text('$e')))
                              .toList(),
                        ),
                      ),
                    )
                  ]))
            ]),
            Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: Container(
                      width: 670.00,
                      height: 400.00,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 4.0),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Center(
                        child: FutureBuilder(
                          future: res,
                          builder: (context, snapShot) {
                            if (snapShot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();

                              /*return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'Itinerario',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Avion',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Precio',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  ],
                                  rows: snapShot.data.map<DataRow>((e) {
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text('${e.page}')),
                                        DataCell(Text('${e.perPage}')),
                                        DataCell(Text('${e.total}')),
                                      ],
                                    );
                                  }).toList(),
                                  ),                                
                                );
                              */

                            } else {
                              return Text('ocurrio un ${snapShot.data}');
                            }
                          },
                        ),
                      )),
                )),
          ],
        ),
      ),
    );
  }

  void guardarDatos() {}

  Widget containerOne() {
    return Container(
        margin: EdgeInsets.all(50.0),
        width: 420.0,
        height: 440.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            containerTwo(
                width: 240.0,
                height: 70.0,
                margin: 10.0,
                child: Text(
                    'Aqui podras almacenar los vuelos que ofrecera la Aerolinia.',
                    style: TextStyle(fontSize: 20.0))),
            containerTwo(
                width: 300.0,
                height: 60.0,
                margin: 10.0,
                child: Text(
                    'Deposita todos los datos del vuelo en el formulario.')),
            Row(children: [
              containerTwo(
                  width: 200.0,
                  height: 30.0,
                  margin: 5.0,
                  child: ElevatedButton(
                      onPressed: () => insertarVuelo("vuelo"),
                      child: Text('Guardar'))),
              containerTwo(
                  width: 200.0,
                  height: 30.0,
                  margin: 5.0,
                  child: ElevatedButton(
                      onPressed: () => modificarVuelo("vuelo"),
                      child: Text('Actualizar'))),
            ])
          ],
        ));
  }

  void insertarVuelo(String vuelo) {
    setState(() {
      id++;
    });
  }

  void modificarVuelo(String vuelo) {}

  Widget containerTwo(
      {double width, double height, Color color, double margin, Widget child}) {
    return Container(
        margin: EdgeInsets.all(margin),
        width: width,
        height: height,
        decoration: BoxDecoration(color: color),
        child: child);
  }
}
