import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

/*class GestionarItinerario extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Page();
  }
}*/

class GestionarItinerario extends StatefulWidget {
  @override
  _CState createState() => _CState();
}

class _CState extends State<GestionarItinerario> {
  List<String> lista = ["España", "Francia"];
  List<String> aeropuertos = ['Aero_uno', 'Aero_dos'];
  List<String> paices = [];

  String valorOrigen = "Origen";
  String aeropuerto = "Aeropuerto";
  String valorDestino = "Destino";
  String fechaSalida = "";
  String horaSalida = "";
  String fechaLlegada = "";
  String horaLlegada = "";

  void transformarJson(List<dynamic> lista) {
    List<String> pais = [];

    for (int i = 0; i < lista.length; i++) {
      this.paices.add(lista[i]['nombre'].toString());
      //print(lista[i]['nombre']);
      pais.add(lista[i]['nombre'].toString());
    }

    print("el dato es: ${this.paices}");
    setState(() {            
    });
  }

  Future traerPaices() async {
    var h = http.Client();

    final response =
        await h.get(Uri.parse('http://192.168.1.12/restful_php/'), headers: {
      "Accept": "application/json",
      //"Access-Control-Allow-Origin": "*"
    });

    List<dynamic> data = json.decode(response.body);
    print("el dato fue : ${data[0]['nombre']}");
    transformarJson(data);
  }

  @override
  void initState() {
    super.initState();
    traerPaices();
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
                        if (paices.length > 0)
                          Container(
                          width: 190.00,
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
                              });
                            },
                            items: paices
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
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
                                  fechaSalida =
                                      DateFormat('EEE, M/d/y').format(newDate);
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
                          width: 190.00,
                          height: 40.0,
                          child: DropdownButton(
                            hint: Text('$aeropuerto'),
                            dropdownColor: Colors.white,
                            elevation: 5,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 36.0,
                            onChanged: (value) {
                              setState(() {
                                aeropuerto = value;
                              });
                            },
                            items: aeropuertos
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
                        if (paices.length > 0)
                          Container(
                          width: 190.00,
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
                              });
                            },
                            items: paices
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
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
                                      DateFormat('EEE, M/d/y').format(newDate);
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
                          width: 190.00,
                          height: 40.0,
                          child: DropdownButton(
                            hint: Text('$aeropuerto'),
                            dropdownColor: Colors.white,
                            elevation: 5,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 36.0,
                            onChanged: (value) {
                              setState(() {
                                aeropuerto = value;
                              });
                            },
                            items: aeropuertos
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
                          onPressed: () {},
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
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('1')),
                            DataCell(Text('España')),
                            DataCell(Text('EROPAR')),
                            DataCell(Text('27/09/2000')),
                            DataCell(Text('01:22 PM')),
                            DataCell(Text('francia')),
                            DataCell(Text('only')),
                            DataCell(Text('29/09/2020')),
                            DataCell(Text('11:32 PM')),
                          ])
                        ]),
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
