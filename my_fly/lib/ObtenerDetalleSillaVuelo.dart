import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ObtenerDetalleSillaVuelo extends StatefulWidget {
  @override
  ObtenerDetalleSillaVueloState createState() =>
      ObtenerDetalleSillaVueloState();
}

class ObtenerDetalleSillaVueloState extends State<ObtenerDetalleSillaVuelo> {

  Color color = Color(0xff00a8dd) ;


  Widget silla(String numero, Color color) {
    return Container(
        width: 5.0,
        height: 50.0,
        margin: EdgeInsets.all(30.0),
        decoration: BoxDecoration(          
          borderRadius: BorderRadius.circular(20.0)),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: color
          ),          
          onPressed: showAlertDialog,
          child: Text('$numero')
        ));
  }

  Future<void> showAlertDialog() async{
    return showDialog<void>(
        context: context,
        builder: (context){
          return CupertinoAlertDialog(
            title: Text('Generar reserva'),
            content:  Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                    placeholder: 'Numero de la tarjeta',
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: CupertinoColors.inactiveGray
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                      placeholder: 'Nombre y Apellido',
                      style: TextStyle(
                          color: CupertinoColors.inactiveGray
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                      placeholder: 'Codigo de segurida' ,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: CupertinoColors.inactiveGray
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                    placeholder: 'Numero de cedula',
                    keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: CupertinoColors.inactiveGray
                      )
                  ),
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text('Salir')
              ),
              CupertinoDialogAction(
                  onPressed: (){
                    setState(() {
                      Navigator.of(context).pop();
                      color = Color(0xffffa800);
                    });
                  },
                  child: Text('Reservar')
              ),
            ],
          );
        });
  }



  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selección silla")),
      body: SingleChildScrollView(
        child: Center(
            child: Container(
                margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                width: 300.0,
                height: 900.0,
                decoration: BoxDecoration(color: Colors.green),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        silla('1', Color(0xffff0000)),
                        silla('2', color),
                      ]
                    ),
                    TableRow(
                      children: [
                        silla('3',Color(0xffffa800)),
                        silla('4',Color(0xff00a8dd)),
                      ]
                    ),
                    TableRow(
                      children: [
                        silla('5', Color(0xff00a8dd)),
                        silla('6', Color(0xff00a8dd)),
                      ]
                    ),
                  ],
                ),
                )),
      ),
    );
  }
}
