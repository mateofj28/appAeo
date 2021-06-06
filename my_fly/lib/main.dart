import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      theme: ThemeData.light(),
      home: MyHomePage(title: 'Home'),
    );
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

  String _admin = "root";
  bool signRoot = false;
  bool startSign = false;
  bool notShowPass = true;

  //flutter run -d chrome --web-port 51094
  //Solicita iniciar seccion o registrarse --> AlertDialo
  //metodo iniciar session

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
                      MaterialStateProperty.all<Color>(Colors.blue[900]),
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
                      MaterialStateProperty.all<Color>(Colors.green[900]),
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
                  child: Column(children: [
                    Text("Header drawer", style: TextStyle(fontSize: 10)),
                    SizedBox(height: 10),
                    Text("Subtitle"),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed: () {}, child: Text("presioname"))
                  ])),
              decoration: BoxDecoration(color: Colors.indigo)),
          if (startSign == false && signRoot == true)
            ListTile(
                title: Text("Gestionar itinerario"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GestionarItinerario()));
                }),
          if (startSign == false && signRoot == true)
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
          if (startSign == false && signRoot == true)
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
            height: 500.0,
            child: FutureBuilder<List<ViewVuelo>>(
              future: findVuelos(), // async work
              builder: (BuildContext context,
                  AsyncSnapshot<List<ViewVuelo>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading....');
                  default:
                    return Text('Result: ${snapshot.data[0].id}');
                  /*if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Text('Error: ${snapshot.error}');
                    } else {
                      
                    }*/
                }
              },
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

  Future<List<ViewVuelo>> findVuelos() async {
    ViewVuelo vuelo;
    List<ViewVuelo> arrayViewVuelos;

    final response =
        await http.get(Uri.parse('http://localhost:8080/api/vuelo'));

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      print('${data[0]['id']}');
    }

    print('$data');

    for (var i in data) {
      vuelo = new ViewVuelo(i['id'], i['itinerario']['destino'], i['precio']);
      print('${vuelo.destino}, ${vuelo.id}, ${vuelo.precio}');
      arrayViewVuelos.add(vuelo);
    }
    print('todo esta bien!');
    return arrayViewVuelos;
  }

  void gestionarDetalleSilla() {
    //Eliminar la actual
    Navigator.pop(context);
    //dirigirse a otra ventana
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ObtenerDetalleSillaVuelo()));
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
                        /**crear el metodo future
                         * crear el objeto con todos los datos
                         * usar el metodo
                         * verificar que si quedó guardado
                         */
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

  /* crear card
  Widget _card(String title, IconData icon, String price) => Container(
      child: SizedBox(
          height: 200,
          width: 220,
          child: Card(
              elevation: 8,
              child: Column(children: [
                ListTile(title: Text('$title')),
                Icon(icon, size: 50),
                ListTile(title: Text('$price')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ObtenerDetalleSillaVuelo()));
                    },
                    child: Text("Comprar"))
              ]))));
*/
/**
 */
}
