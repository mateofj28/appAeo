import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
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

  Itinerario itinerario;
  int idPuertoLlegada, idPuertoSalida;
  String valorOrigen = "Selecionar Origen", valorDestino = "Selecionar Destino";
  String puertoSalida = "Seleccionar aeropuerto",
      puertoLlegada = "Seleccionar aeropuerto";
  String fechaSalida = "", fechaLlegada = "";
  String horaSalida = "";
  String horaLlegada = "";

  void transformarJson(List<dynamic> lista, int id) {
    List<String> listaRellenar = [];
    for (int i = 0; i < lista.length; i++) {
      listaRellenar.add(lista[i]['nombre'].toString());
    }

    print("el objeto es: ${listaRellenar}");

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

  Future getItinerarios() async{
    final response = await http.get(Uri.parse('http://localhost:8080/api/itinerario'));
    var data = json.decode(response.body);
    for(var i in data){
     ViewItinerario viewItinerario = new ViewItinerario(i['id'],
         i['origen'], i['puertoOrigen']['nombre'], i['fechaSalida'], i['horaSalida'], i['destino'],
         i['puertoDestino']['nombre'], i['fechaLlegada'], i['horaLlegada']);
     arrayItinerarios.add(viewItinerario);
    }
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
    print("el aeropuerto fue: ${data[0]['id']}, ${data[0]['nombre']}");
    
    if (key == 1) {
      dataPuertoLlegada = data;
      print("el puerto fue: -> $dataPuertoLlegada");
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
    print("las ciudades obtenidas fueron: ${dataCiudades}");
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
                            itinerario = new Itinerario(
                                valorOrigen,
                                idPuertoSalida,
                                fechaSalida,
                                horaSalida,
                                valorDestino,
                                idPuertoLlegada,
                                fechaLlegada,
                                horaLlegada);

                            print(
                                "el objeto que registro fue ${itinerario.getOrigen()}, ${itinerario.getAeroPuerto()}");
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
              Container(
                  width: double.maxFinite,
                  height: 50.0,
                  child: Center(
                    child: DataTable(
                        sortColumnIndex: 0,
                        sortAscending: true,
                        columns: [
                          DataColumn(label: Text('id')),
                          DataColumn(label: Text('Origen')),
                          DataColumn(label: Text('Aeropuerto')),
                          DataColumn(label: Text('Fecha salida')),
                          DataColumn(label: Text('Hora salida')),
                          DataColumn(label: Text('Destino')),
                          DataColumn(label: Text('Aeropuerto')),
                          DataColumn(label: Text('Fecha salida')),
                          DataColumn(label: Text('Hora salida')),
                        ],
                        rows: arrayItinerarios.map((e) => DataRow(
                            cells: [
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
                              )
                            ]
                        ))),
                  )),
              SizedBox(height: 60.0)
            ],
          ),
        ));
  }
}

/*
* TextButton() es un boton de texto tipo material
*
Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Datos de salida'),
              Container(
                  width: 180.00,
                  height: 30.0,
                  decoration: BoxDecoration(color: Colors.pink)),
              Row(
                children: [
                  CupertinoButton(
                      child: Text("Seleccionar fecha"),
                      onPressed: () {
                        CupertinoRoundedDatePicker.show(context,
                            fontFamily: "Mali",
                            textColor: Colors.black,
                            background: Colors.white,
                            borderRadius: 30,
                            initialDatePickerMode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (newDate) {
                          setState(() {
                            fechaSalida =
                                DateFormat('EEE, M/d/y').format(newDate);
                          });
                        });
                      },
                      color: Colors.deepPurple),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text('$fechaSalida'),
                  )
                ],
              ),
              Row(
                children: [
                  CupertinoButton(
                      onPressed: () {
                        CupertinoRoundedDatePicker.show(context,
                            fontFamily: "Mali",
                            textColor: Colors.black,
                            background: Colors.white,
                            borderRadius: 30,
                            initialDatePickerMode: CupertinoDatePickerMode.time,
                            onDateTimeChanged: (newDate) {
                          setState(() {
                            horaSalida = DateFormat('hh:mm a').format(newDate);
                          });
                        });
                      },
                      color: Colors.blue,
                      child: Text('Seleccionar hora')),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text('$horaSalida'),
                  )
                ],
              ),
              Container(
                  width: 180.00,
                  height: 30.0,                  
                  child: Expanded(
                    child: DropdownButton(
                      hint: Text('Origen'),
                      dropdownColor: Colors.white,
                      elevation: 5,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      onChanged: (value) {
                        setState(() {});
                      },
                      items: lista
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                    ),
                  )),
              Text('Datos de llegada'),
              Container(
                  width: 180.00,
                  height: 30.0,
                  decoration: BoxDecoration(color: Colors.pink)),
              Row(
                children: [
                  CupertinoButton(
                      child: Text("Seleccionar fecha"),
                      onPressed: () {
                        CupertinoRoundedDatePicker.show(context,
                            fontFamily: "Mali",
                            textColor: Colors.black,
                            background: Colors.white,
                            borderRadius: 30,
                            initialDatePickerMode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (newDate) {
                          setState(() {
                            fechaLlegada =
                                DateFormat('EEE, M/d/y').format(newDate);
                          });
                        });
                      },
                      color: Colors.deepPurple),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text('$fechaLlegada'),
                  )
                ],
              ),
              Row(
                children: [
                  CupertinoButton(
                      onPressed: () {
                        CupertinoRoundedDatePicker.show(context,
                            fontFamily: "Mali",
                            textColor: Colors.black,
                            background: Colors.white,
                            borderRadius: 30,
                            initialDatePickerMode: CupertinoDatePickerMode.time,
                            onDateTimeChanged: (newDate) {
                          setState(() {
                            horaLlegada = DateFormat('hh:mm a').format(newDate);
                          });
                        });
                      },
                      color: Colors.blue,
                      child: Text('Seleccionar hora')),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('$horaLlegada'),
                  )
                ],
              ),
              Container(
                  width: 180.00,
                  height: 40.0,                  
                  child: DropdownButton(
                      hint: Text('Destino'),
                      dropdownColor: Colors.white,
                      elevation: 5,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      onChanged: (value) {
                        setState(() {});
                      },
                      items: lista
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),                    
                  )),
            ],
          ),
          Column(
            children: [
              Text('Crear Itinerario',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle),
              Text('Anexa todos los datos para poder llevar acabo el registro',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .pickerTextStyle),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                CupertinoButton(
                  child: Text('Guardar'),
                  onPressed: () {},
                ),
                CupertinoButton(
                  child: Text('Editar'),
                  onPressed: () {},
                )
              ])
            ],
          ),
        ],
      )




* */
