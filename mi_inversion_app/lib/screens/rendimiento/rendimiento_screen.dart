import 'package:flutter/material.dart';
import 'package:mi_inversion_app/screens/rendimiento/tabla_screen.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import '../../../main.dart';


import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class rendimientoPage extends StatefulWidget {

  final String nombre;
  final int tasa, duracion, invmin, invmax;

  const rendimientoPage({ Key? key , required this.nombre, required this.tasa, required this.duracion, required this.invmin, required this.invmax}) : super(key: key);

  @override
  _rendimientoPage createState() => _rendimientoPage();
}


class _rendimientoPage extends State<rendimientoPage> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  late  DateTime date;
  
  Future pickDate(BuildContext context) async{
    final initialDate =DateTime.now();
    final newDate = await showDatePicker(context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate:  DateTime(DateTime.now().year + 5)
      );

      if( newDate == null) return;

      setState(() => date = newDate);
  }
  


  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    

    return MaterialApp(
      title: 'Fecha',
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).push( new MaterialPageRoute( builder: (BuildContext context) => new MyHomePage(),))),
          title:  Text(widget.nombre),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.only(top: 36,left: 12.0,right: 12.0,bottom: 12.0),
            children: <Widget>[

              
              
              ElevatedButton(
              child: Text('Pick a date'),
              onPressed: () {
                pickDate(context);
              },
            ),
               new Padding(padding: new EdgeInsets.only(top: 20.0),),

              Container(
                height: 50,
                child: new TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || int.parse(value) > widget.invmax || widget.invmin > int.parse(value)) {
                      return 'El monto es invalido';
                    }
                    return null;
                  },
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                        border: OutlineInputBorder(),
                    labelText: 'Monto',
                    icon: new Icon(Icons.attach_money),
                  ),
                ),
              ),
              
               new Padding(padding: new EdgeInsets.only(top: 20.0),),

              

             new Padding(padding: new EdgeInsets.only(top: 44.0),),
              Container(
                height: 50,
                child: new ElevatedButton(
                  onPressed: (){
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => tablaPage(
                        nombre: widget.nombre,
                        tasa: widget.tasa,
                        duracion: widget.duracion,
                        date: date,
                        monto : int.parse(_controller.text)
                      )),
                    );        


                    ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                    } 
     
                  },
                  child: new Text(
                    'Generar tabla',
                    style: new TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.blue,
                        ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
