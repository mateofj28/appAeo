import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_fly/GestionarItinerario.dart';
import 'package:my_fly/GestionarVuelo.dart';
import 'package:my_fly/ObtenerDetalleSillaVuelo.dart';
import 'package:http/http.dart' as http;
import 'package:my_fly/view/ViewVuelo.dart';

import 'model/Pasajero.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirCol',
      theme: ThemeData(primaryColor: Color(0xFFFFCE2C)),
      home: MyHomePage(title: 'Home'),
    );
  }
}

// ignore: must_be_immutable
class CardItem extends StatefulWidget {
  ViewVuelo vuelo;

  CardItem(this.vuelo);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ObtenerDetalleSillaVuelo(widget.vuelo.id)));
      },
      child: Container(
        width: 150.0,
        child: Card(
            elevation: 10.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('icono'),
                Text('${widget.vuelo.destino}'),
                Text('${widget.vuelo.precio}'),
              ],
            )),
      ),
    );
  }
}

// ignore: must_be_immutable
class ListCard extends StatefulWidget {
  List<ViewVuelo> listaVuelos;
  ListCard(this.listaVuelos);

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(20),
        itemCount: widget.listaVuelos.length,
        itemBuilder: (BuildContext context, int index) {
          return CardItem(widget.listaVuelos[index]);
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController txtNombre = new TextEditingController();
  TextEditingController txtApellido = new TextEditingController();
  TextEditingController txtCedula = new TextEditingController();
  TextEditingController txtTelefono = new TextEditingController();
  TextEditingController txtCorreo = new TextEditingController();
  TextEditingController txtContrasena = new TextEditingController();
  List<ViewVuelo> arrayVuelos = [];

  var nameUser = '', mailUser = '';

  String _admin = "root";
  bool signRoot = false;
  bool startSign = false;
  bool notShowPass = true;

  @override
  // ignore: must_call_super
  void initState() {
    findVuelos();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> _fill = <Color>[
      Colors.grey[200],
      Color(0xFFf8fbf8),
      Colors.white
    ];

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: <Widget>[
        if (startSign == false)
          Container(
            padding: EdgeInsets.all(6.0),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFFF4762)),
                ),
                onPressed: () {
                  iniciarSesion();
                },
                child: Text('Iniciar sesión')),
          ),
        if (startSign == false)
          Container(
            padding: EdgeInsets.all(6.0),
            width: 130.0,
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF64AAFF)),
                ),
                onPressed: showDialoSave,
                child: Text('Registrarse')),
          ),
      ]),
      drawer: Drawer(
          child: SingleChildScrollView(
              child: Column(
        children: [
          DrawerHeader(
              child: Container(
                  width: double.maxFinite,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.account_circle),
                        Text("Hello $nameUser", style: TextStyle(fontSize: 20)),
                        Text('$mailUser'),
                        //ElevatedButton(onPressed: () {}, child: Text("presioname"))
                      ])),
              decoration: BoxDecoration(color: Color(0xFFFFCE2C))),
          if (signRoot == true)
            ListTile(
                title: Text("Gestionar itinerario"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GestionarItinerario()));
                }),
          if (signRoot == true)
            ListTile(
                title: Text("Gestionar vuelo"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GestionarVuelo()));
                }),
          ListTile(
              title: Text("Gestionar mis datos"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GestionarItinerario()));
              }),
          if (startSign == true)
            ListTile(
                title: Text("Historial"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GestionarItinerario()));
                }),
          ListTile(
              title: Text("Cerrar sesión"),
              onTap: () {
                setState(() {
                  startSign = false;
                  signRoot = false;
                });
                Navigator.pop(context);
              }),
        ],
      ))),
      body: SafeArea(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text('Hola mundo',
                style: CupertinoTheme.of(context)
                    .textTheme
                    .actionTextStyle
                    .copyWith(fontSize: 20)),
          ),
          Container(
            width: 700.0,
            height: 300.0,
            child: Center(
              child: (arrayVuelos.length != 0)
                  ? ListCard(arrayVuelos)
                  : CircularProgressIndicator(),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF649166),
              //  border: Border.fromBorderSide(BorderSide(style: BorderStyle.solid,width: 3.0,color: Color(0xFFF8F1F1))),
              borderRadius: BorderRadius.all(Radius.circular(30)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _fill,
                stops: [0.1, 0.5, 0.9],
              ),
            ),
          )
        ],
      )),
    );
  }

  Future findVuelos() async {
    ViewVuelo vuelo;

    final response =
        await http.get(Uri.parse('http://localhost:8080/api/vuelo'));

    var data = json.decode(response.body);

    for (var i in data) {
      vuelo = new ViewVuelo(i['id'], i['itinerario']['destino'], i['precio']);
      arrayVuelos.add(vuelo);
    }
    setState(() {});
  }

  Future<void> iniciarSesion() async {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: CupertinoAlertDialog(
              title: Text('Iniciar sesión'),
              content: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      controller: txtCorreo,
                      placeholder: 'Correo',
                      style: TextStyle(color: CupertinoColors.inactiveGray),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                        obscureText: notShowPass,
                        controller: txtContrasena,
                        placeholder: 'Contraseña',
                        style: TextStyle(color: CupertinoColors.inactiveGray)),
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                    onPressed: () {
                      setState(() {
                        txtCorreo.text = "";
                        txtContrasena.text = "";
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text('Salir')),
                CupertinoDialogAction(
                    onPressed: () {
                      setState(() {
                        if (txtCorreo.text == _admin) {
                          startSign = true;
                          signRoot = true;
                          txtCorreo.text = "";
                          txtContrasena.text = "";
                          print("Inicio sesion el admin");
                        } else {
                          getPasajero(txtCorreo, txtContrasena);
                        }
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text('Iniciar sesion'))
              ],
            ),
          );
        });
  }

  Future<void> showDialoSave() async {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: CupertinoAlertDialog(
              title: Text('Registrarse'),
              content: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      controller: txtNombre,
                      placeholder: 'Nombre',
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: CupertinoColors.inactiveGray),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      controller: txtApellido,
                      placeholder: 'Apellido',
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: CupertinoColors.inactiveGray),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                        controller: txtCedula,
                        placeholder: 'Cedula',
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: CupertinoColors.inactiveGray)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                        controller: txtTelefono,
                        placeholder: 'Teléfono',
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: CupertinoColors.inactiveGray)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                        controller: txtCorreo,
                        placeholder: 'Correo',
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: CupertinoColors.inactiveGray)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                        controller: txtContrasena,
                        placeholder: 'Contraseña',
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: TextStyle(color: CupertinoColors.inactiveGray)),
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                    onPressed: () {
                      setState(() {
                        txtCorreo.text = "";
                        txtContrasena.text = "";
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text('Salir')),
                CupertinoDialogAction(
                    onPressed: () {
                      setState(() {
                        Pasajero pasajero = new Pasajero(
                            txtCedula.text,
                            txtNombre.text,
                            txtApellido.text,
                            txtTelefono.text,
                            txtCorreo.text,
                            txtContrasena.text);

                        savePasajero(pasajero);
                        txtCorreo.text = "";
                        txtContrasena.text = "";
                        iniciarSesion();
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text('Registrarse'))
              ],
            ),
          );
        });
  }

  /** metodo traer el objeto*/
  Future getPasajero(
      TextEditingController correo, TextEditingController contrasena) async {
    var uri = 'http://localhost:8080/api/pasajero?correo=${correo.text}';

    final response = await http.get(Uri.parse(uri));

    var data = json.decode(response.body);

    if (data['correo'] == correo.text && data['password'] == contrasena.text) {
      setState(() {
        signRoot = false;
        startSign = true;
        nameUser = data['nombre'];
        mailUser = data['correo'];
        txtCorreo.text = "";
        txtContrasena.text = "";
        print("Inicio sesion el usuario");
      });
    } else {
      var snackBar = SnackBar(
        content: Text('¡El usuario no existe!'),
      );
      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print("Error al iniciar sesion");
    }
  }

  /**metodo asincrono guardar pasajero */
  Future savePasajero(Pasajero pasajero) async {
    String url = 'http://localhost:8080/api/pasajero';
    final String body = json.encode({
      "cedula": pasajero.cedula,
      "nombre": pasajero.nombre,
      "apellido": pasajero.apellido,
      "telefono": pasajero.telefono,
      "correo": pasajero.correo,
      "contraseña": pasajero.contrasena
    });

    final response = await http.post(Uri.parse(url), body: body, headers: {
      'Content-Type': 'application/json',
    });

    var data = json.decode(response.body);
    print('${data['id']}');
  }
}
