import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_fly/GestionarItinerario.dart';
import 'package:my_fly/GestionarVuelo.dart';
import 'package:my_fly/ObtenerDetalleSillaVuelo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My fly',
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
  TextEditingController txtCedula = new TextEditingController();
  TextEditingController txtCorreo = new TextEditingController();
  TextEditingController txtContrasena = new TextEditingController();
  TextEditingController txtCorreoNombre = new TextEditingController();

  String _admin = "root";
  String _passAdmin = '';
  String _user = "mateo";
  String _pass = "1234";
  bool signRoot = false;
  bool signUser = true;

  //flutter run -d chrome --web-port 51094
  //Solicita iniciar seccion o registrarse --> AlertDialo
  //metodo iniciar session
  void signUp(String user, String pass) {
    
    if (user == _user && pass == _pass) {
      //mostrar datos del usuario, los vuelos, gestionar sus datos y sus historiales

    } else if (user == _admin && pass == _passAdmin) {
      //mostrar datos del usuario, los vuelos, gestionar sus datos y sus historiales
      signRoot = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("el valor es: $signRoot");
    print(signRoot == false);

    return Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: <Widget>[
          if (signRoot == false)
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
          if (signRoot == false)
            Container(
              padding: EdgeInsets.all(6.0),
              width: 130.0,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green[900]),
                  ),
                  onPressed: registrarUsu,
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
                      ElevatedButton(
                          onPressed: () {}, child: Text("presioname"))
                    ])),
                decoration: BoxDecoration(color: Colors.indigo)),
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
            if (signRoot == false)
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
                    signRoot = false;
                  });
                  Navigator.pop(context);
                }),
          ],
        ))),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              height: 400.0,
              decoration: BoxDecoration(color: Colors.blue[50]),
              child: Center(
                child: Column(
                  //espacio pequeño y apropiado
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('title',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navLargeTitleTextStyle),
                    Text('descripcion', style: TextStyle(fontSize: 20.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _card("España, madrid",
                            Icons.account_balance_wallet_sharp, "100"),
                        _card("Francia, paris", Icons.access_alarm_outlined,
                            "1200"),
                        _card("Italia, roma", Icons.zoom_in_rounded, "800"),
                        _card("Colombia, barranquilla", Icons.adb_sharp, "90"),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
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
          return CupertinoAlertDialog(
            title: Text('Iniciar sesión'),
            content: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                    controller: txtCorreoNombre,
                    placeholder: 'Correo',
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: CupertinoColors.inactiveGray),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                      controller: txtContrasena,
                      placeholder: 'Contraseña',
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: CupertinoColors.inactiveGray)),
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Salir')),
              CupertinoDialogAction(
                  onPressed: () {
                    setState(() {
                      signUp(txtCorreoNombre.text, txtContrasena.text);
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text('Iniciar sesion'))
            ],
          );
        });
  }

  Future<void> registrarUsu() async {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Registrarse'),
            content: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                    controller: txtNombre,
                    placeholder: 'Nombre completo',
                    keyboardType: TextInputType.number,
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
                      controller: txtCorreo,
                      placeholder: 'Correo',
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: CupertinoColors.inactiveGray)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                      controller: txtContrasena,
                      placeholder: 'Contraseña',
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: CupertinoColors.inactiveGray)),
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Salir')),
              CupertinoDialogAction(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                      iniciarSesion();
                      //metodo registrar con objeto creado
                    });
                  },
                  child: Text('Registrarse'))
            ],
          );
        });
  }

  /* crear card*/
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

/**
    ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[

    /**aqui se definen los items del drawer */
    /**primero el header */


    //luego el body


    ]
    )
 */
}
