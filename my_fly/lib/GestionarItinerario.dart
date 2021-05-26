import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:my_fly/model/Aeropuerto.dart';
import 'package:my_fly/model/Ciudad.dart';
import 'package:my_fly/model/Pais.dart';
import 'package:my_fly/view/ViewItinerario.dart';

import 'model/Itinerario.dart';

class GestionarItinerario extends StatefulWidget {
  @override
  _CState createState() => _CState();
}

class _CState extends State<GestionarItinerario> {
  List<String> ciudades = [];
  List<dynamic> dataCiudades = [];
  List<dynamic> dataPuertoSalida = [], dataPuertoLlegada = [];
  List<String> arrayPuertoSalida = [], arrayPuertoLlegada = [];
  List<String> aeropuertos = [];
  List<ViewItinerario> arrayItinerarios = [];

  DateTime dateFechaSalida, dateFechaLlegada;
  int idPuertoLlegada, idPuertoSalida;
  String valorOrigen = "Selecionar Origen", valorDestino = "Selecionar Destino";
  String puertoSalida = "Seleccionar aeropuerto",
      puertoLlegada = "Seleccionar aeropuerto";
  String fechaSalida = "", fechaLlegada = "";
  String horaSalida = "";
  String horaLlegada = "";

  Future<dynamic> getPuerto(int id) async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/aeropuerto/id?id=$id'));
    var data = json.decode(response.body);
    return data;
  } 

  
  guardarIti(
      int idOrigen,
      idDestino,
      String origen,
      DateTime fechaSalida,
      String horaSalida,
      String destino,
      DateTime fechaLlegada,
      String horaLlegada) async {
    dynamic puertoSalidaMap = await getPuerto(idOrigen);
    dynamic puertoLlegadaMap = await getPuerto(idDestino);


    Pais paisOrigen = new Pais(puertoSalidaMap['ciudad']['pais']['id'],
        puertoSalidaMap['ciudad']['pais']['nombre']);

    Pais paisDestino = new Pais(puertoLlegadaMap['ciudad']['pais']['id'],
        puertoLlegadaMap['ciudad']['pais']['nombre']);

    Ciudad ciudadOrigen = new Ciudad(puertoSalidaMap['ciudad']['id'],
        puertoSalidaMap['ciudad']['nombre'], paisOrigen);

    Ciudad ciudadDestino = new Ciudad(puertoLlegadaMap['ciudad']['id'],
        puertoLlegadaMap['ciudad']['nombre'], paisDestino);

    Aeropuerto puertoOrigen = new Aeropuerto(
        puertoSalidaMap['id'], puertoSalidaMap['nombre'], ciudadOrigen);

    Aeropuerto puertoDestino = new Aeropuerto(
        puertoSalidaMap['id'], puertoSalidaMap['nombre'], ciudadDestino);

    Itinerario iti = new Itinerario(origen, puertoOrigen, fechaSalida,
        horaSalida, destino, puertoDestino, fechaLlegada, horaLlegada);


    final body = json.encode({
      "origen": iti.origen,
      "puertoOrigen": {
        "id": iti.puertoOrigen.id,
        "nombre": iti.puertoOrigen.nombre,
        "ciudad": {
          "id": iti.puertoOrigen.ciudad.id,
          "nombre": iti.puertoOrigen.ciudad.nombre,
          "pais": {
            "id": iti.puertoOrigen.ciudad.pais.id,
            "nombre": iti.puertoOrigen.ciudad.pais.nombre
          }
        }
      },
      "fechaSalida": DateFormat('y-MM-d').format(iti.fechaSalida),
      "horaSalida": iti.horaSalida,
      "destino": iti.destino,
      "puertoDestino": {
        "id": iti.puertoDestino.id,
        "nombre": iti.puertoDestino.nombre,
        "ciudad": {
          "id": iti.puertoDestino.ciudad.id,
          "nombre": iti.puertoDestino.ciudad.nombre,
          "pais": {
            "id": iti.puertoDestino.ciudad.pais.id,
            "nombre": iti.puertoDestino.ciudad.pais.nombre
          }
        }
      },
      "fechaLlegada": DateFormat('y-MM-d').format(iti.fechaLlegada),
      "horaLlegada": iti.horaLlegada,
    });

    final response = await http.post(
        Uri.parse('http://localhost:8080/api/itinerario'),
        body: body,
        headers: {
          'Content-Type': 'application/json',
        });

    print(response.statusCode);
    var data = json.decode(response.body);
    ViewItinerario viewIti = new ViewItinerario(
        data['id'],
        data['origen'],
        data['puertoOrigen']['nombre'],
        DateFormat('y-MM-d').format(DateTime.parse(data['fechaSalida'])),
        data['horaSalida'],
        data['destino'],
        data['puertoDestino']['nombre'],
        DateFormat('y-MM-d').format(DateTime.parse(data['fechaLlegada'])),
        data['horaLlegada']);
    arrayItinerarios.add(viewIti);
    setState(() {
      
    });
  }

  void transformarJson(List<dynamic> lista, int id) {
    List<String> listaRellenar = [];
    for (int i = 0; i < lista.length; i++) {
      listaRellenar.add(lista[i]['nombre'].toString());
    }

    if (id == 1) {
      arrayPuertoLlegada = listaRellenar;
    }

    if (id == 2) {
      ciudades = listaRellenar;
    }

    //aca estan los puertos que se usan en el drop
    arrayPuertoSalida = listaRellenar;
    setState(() {});
  }

  Future getItinerarios() async {
    ViewItinerario viewItinerario;
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/itinerario'));
    var data = json.decode(response.body);
    print("$data");
    for (var i in data) {
      print(" el aeropuerto fue: ${i['puertoOrigen']['nombre']}");

      viewItinerario = new ViewItinerario(
          i['id'],
          i['origen'],
          i['puertoOrigen']['nombre'],
          DateFormat('y-MM-d').format(DateTime.parse(i['fechaSalida'])),
          i['horaSalida'],
          i['destino'],
          i['puertoDestino']['nombre'],
          DateFormat('y-MM-d').format(DateTime.parse(i['fechaLlegada'])),
          i['horaLlegada']);

      print("el objeto view: ${viewItinerario.id}, ${viewItinerario.source}");
      arrayItinerarios.add(viewItinerario);
    }

    print("tamaño de la lista es: ${arrayItinerarios.length}");
    print("${arrayItinerarios[0].source}");
    setState(() {
      
    });    
  }

  int getIdObject(String value, List<dynamic> lista) {
    int id;
    for (int i = 0; i < lista.length; i++) {
      if (lista[i]['nombre'] == value) {
        id = lista[i]['id'];
      }
    }
    return id;
  }

  Future getDataAero(int id, int key) async {
    var h = http.Client();

    final response = await h.get(
        Uri.parse('http://localhost:8080/api/aeropuerto?id=$id'),
        headers: {
          "Accept": "application/json",
          //"Access-Control-Allow-Origin": "*"
        });

    List<dynamic> data = json.decode(response.body);

    if (key == 1) {
      dataPuertoLlegada = data;
    }

    dataPuertoSalida = data;
    /*se transforma la info en objeto y se agregan a la lista de puertos
    salida como llegada*/
    transformarJson(data, key);
  }

  Future getDataCity(String url) async {
    var h = http.Client();
    final response = await h.get(Uri.parse(url), headers: {
      "Accept": "application/json",
    });
    List<dynamic> data = json.decode(response.body);
    dataCiudades = data;
    transformarJson(data, 2);
  }

  @override
  void initState() {
    super.initState();
    //obtener las ciudades
    getDataCity('http://localhost:8080/api/ciudad');
    getItinerarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Gestionar Itinerario')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 920.00,
                height: 1000.0,
                //decoration: BoxDecoration(color: Colors.green),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text('Crear Itinerario',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navLargeTitleTextStyle),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        'Anexa todos los datos para poder llevar acabo el registro \ny cuando estes listo ¡Registralos!.',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .pickerTextStyle),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    padding: EdgeInsets.all(30.0),
                    margin: EdgeInsets.only(right: 260.0),
                    child: Text('Datos de salida',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navLargeTitleTextStyle),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (ciudades.length > 0)
                          Container(
                            width: 270.00,
                            height: 40.0,
                            child: DropdownButton(
                              hint: Text('$valorOrigen'),
                              dropdownColor: Colors.white,
                              elevation: 5,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36.0,
                              onChanged: (value) {
                                setState(() {
                                  valorOrigen = value;
                                  puertoSalida = "Seleccionar Aeropuerto";
                                  //traer el id de la ciudad
                                  int id = getIdObject(value, dataCiudades);
                                  //a partir del id ciudad se trae el aeropuerto
                                  getDataAero(id, 0);
                                });
                              },
                              items: ciudades
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList(),
                            ),
                          )
                        else
                          CircularProgressIndicator(),
                        CupertinoButton(
                            child: Text("Seleccionar fecha"),
                            onPressed: () {
                              //widget fecha salida
                              CupertinoRoundedDatePicker.show(context,
                                  fontFamily: "Mali",
                                  textColor: Colors.black,
                                  background: Colors.white,
                                  borderRadius: 30,
                                  initialDatePickerMode: CupertinoDatePickerMode
                                      .date, onDateTimeChanged: (newDate) {
                                setState(() {
                                  dateFechaSalida = newDate;
                                  fechaSalida =
                                      DateFormat('y-MM-d').format(newDate);
                                });
                              });
                            },
                            color: Colors.deepPurple),
                        Container(
                            width: 130.0,
                            height: 45.0,
                            child: Center(child: Text('$fechaSalida')))
                      ]),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 270.00,
                          height: 55.0,
                          child: DropdownButton(
                            hint: Text('$puertoSalida'),
                            dropdownColor: Colors.white,
                            elevation: 5,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 36.0,
                            onChanged: (value) {
                              setState(() {
                                puertoSalida = value;

                                idPuertoSalida =
                                    getIdObject(value, dataPuertoSalida);
                                print(
                                    "el aeropuerto de salida es $idPuertoSalida");
                              });
                            },
                            items: arrayPuertoSalida
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                          ),
                        ),
                        CupertinoButton(
                            onPressed: () {
                              CupertinoRoundedDatePicker.show(context,
                                  textColor: Colors.black,
                                  background: Colors.white,
                                  borderRadius: 30,
                                  initialDatePickerMode: CupertinoDatePickerMode
                                      .time, onDateTimeChanged: (newDate) {
                                setState(() {
                                  horaSalida =
                                      DateFormat('hh:mm a').format(newDate);
                                });
                              });
                            },
                            color: Colors.blue,
                            child: Text('Seleccionar hora')),
                        Container(
                            width: 130.0,
                            height: 45.0,
                            child: Center(child: Text('$horaSalida')))
                      ]),
                  SizedBox(
                    height: 90.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(30.0),
                    margin: EdgeInsets.only(right: 260.0),
                    child: Text('Datos de Llegada',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navLargeTitleTextStyle),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (ciudades.length > 0)
                          Container(
                            width: 270.00,
                            height: 40.0,
                            child: DropdownButton(
                              hint: Text('$valorDestino'),
                              dropdownColor: Colors.white,
                              elevation: 5,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36.0,
                              onChanged: (value) {
                                setState(() {
                                  valorDestino = value;
                                  puertoLlegada = "Seleccionar Aeropuerto";
                                  getDataAero(
                                      getIdObject(value, dataCiudades), 1);
                                });
                              },
                              items: ciudades
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList(),
                            ),
                          )
                        else
                          CircularProgressIndicator(),
                        CupertinoButton(
                            child: Text("Seleccionar fecha"),
                            onPressed: () {
                              CupertinoRoundedDatePicker.show(context,
                                  fontFamily: "Mali",
                                  textColor: Colors.black,
                                  background: Colors.white,
                                  borderRadius: 30,
                                  initialDatePickerMode: CupertinoDatePickerMode
                                      .date, onDateTimeChanged: (newDate) {
                                setState(() {
                                  dateFechaLlegada = newDate;
                                  fechaLlegada =
                                      DateFormat('y-MM-d').format(newDate);
                                });
                              });
                            },
                            color: Colors.deepPurple),
                        Container(
                            width: 130.0,
                            height: 45.0,
                            child: Center(child: Text('$fechaLlegada')))
                      ]),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 270.00,
                          height: 55.0,
                          child: DropdownButton(
                            hint: Text('$puertoLlegada'),
                            dropdownColor: Colors.white,
                            elevation: 5,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 36.0,
                            onChanged: (value) {
                              setState(() {
                                puertoLlegada = value;
                                idPuertoLlegada =
                                    getIdObject(value, dataPuertoLlegada);
                                print(
                                    "el aeropuerto de llegada es $idPuertoLlegada");
                              });
                            },
                            items: arrayPuertoLlegada
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                          ),
                        ),
                        CupertinoButton(
                            onPressed: () {
                              CupertinoRoundedDatePicker.show(context,
                                  textColor: Colors.black,
                                  background: Colors.white,
                                  borderRadius: 30,
                                  initialDatePickerMode: CupertinoDatePickerMode
                                      .time, onDateTimeChanged: (newDate) {
                                setState(() {
                                  horaLlegada =
                                      DateFormat('hh:mm a').format(newDate);
                                });
                              });
                            },
                            color: Colors.blue,
                            child: Text('Seleccionar hora')),
                        Container(
                            width: 130.0,
                            height: 45.0,
                            child: Center(child: Text('$horaLlegada')))
                      ]),
                  SizedBox(height: 60.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          color: Colors.lime,
                          child: Text('Registrar'),
                          onPressed: () {
                            setState(() {
                              guardarIti(
                                  idPuertoSalida,
                                  idPuertoLlegada,
                                  valorOrigen,
                                  dateFechaSalida,
                                  horaSalida,
                                  valorDestino,
                                  dateFechaLlegada,
                                  horaLlegada);
                            });
                          },
                        ),
                        CupertinoButton(
                          color: Colors.amberAccent,
                          child: Text('Editar'),
                          onPressed: () {},
                        )
                      ])
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100.0, right: 100.0),
                child: Container(
                  width: 1200.0,
                  height: 500.0,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                            child: (arrayItinerarios.length >= 0)
                                ? buildTable()
                                : CircularProgressIndicator())),
                  ),
                ),
              ),
              SizedBox(height: 50.0)
            ],
          ),
        ));
  }

  DataTable buildTable() => DataTable(
          columns: [
            DataColumn(label: Text('id')),
            DataColumn(label: Text('Origen')),
            DataColumn(label: Text('Aeropuerto.dart')),
            DataColumn(label: Text('Fecha salida')),
            DataColumn(label: Text('Hora salida')),
            DataColumn(label: Text('Destino')),
            DataColumn(label: Text('Aeropuerto.dart')),
            DataColumn(label: Text('Fecha salida')),
            DataColumn(label: Text('Hora salida')),
          ],
          rows: arrayItinerarios
              .map((e) => DataRow(cells: [
                    DataCell(
                      Text('${e.id}'),
                    ),
                    DataCell(
                      Text('${e.source}'),
                    ),
                    DataCell(
                      Text('${e.namePort}'),
                    ),
                    DataCell(
                      Text('${e.starDate}'),
                    ),
                    DataCell(
                      Text('${e.startTime}'),
                    ),
                    DataCell(
                      Text('${e.destiny}'),
                    ),
                    DataCell(
                      Text('${e.namePortEnd}'),
                    ),
                    DataCell(
                      Text('${e.endDate}'),
                    ),
                    DataCell(
                      Text('${e.endTime}'),
                    ),
                  ]))
              .toList());
}
