import 'package:flutter/material.dart';
import 'package:mi_inversion_app/controllers/databasehelpers.dart';
import 'package:mi_inversion_app/main.dart';

import 'dart:convert';
import '../../../main.dart';


import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class addPage extends StatefulWidget {
  const addPage({ Key? key }) : super(key: key);

  @override
  _addPageState createState() => _addPageState();
}

class _addPageState extends State<addPage> {

  final _formKey = GlobalKey<FormState>();


  DataBaseHelper databaseHelper = new DataBaseHelper();


  final TextEditingController _nameController = new TextEditingController();  
  final TextEditingController _invminController = new TextEditingController();
  final TextEditingController _invmaxController = new TextEditingController();
  final TextEditingController _tasaController = new TextEditingController();
  final TextEditingController _duracionController = new TextEditingController();




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agregar Plan',
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).push( new MaterialPageRoute( builder: (BuildContext context) => new MyHomePage(),))),
          title:  Text('Agregar Plan'),
        ),
        body: Form(
          key: _formKey,

          child: ListView(
            padding: const EdgeInsets.only(top: 36,left: 12.0,right: 12.0,bottom: 12.0),
            children: <Widget>[

              
              
              Container(
                height: 50,
                child: new TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese un nombre';
                    }
                    return null;
                  },

                  controller: _nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                        border: OutlineInputBorder(),
                    labelText: 'Nombre',
                    icon: new Icon(Icons.person),
                  ),
                ),
              ),
               new Padding(padding: new EdgeInsets.only(top: 20.0),),

              Container(
                height: 50,
                child: new TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || int.parse(value) >= int.parse(_invmaxController.text) ) {
                      return 'La inversion minima no debe ser mayor a la maxima';
                    }
                    return null;
                  },
                  controller: _invminController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                        border: OutlineInputBorder(),
                    labelText: 'Inversion Minima',
                    icon: new Icon(Icons.attach_money),
                  ),
                ),
              ),
              
               new Padding(padding: new EdgeInsets.only(top: 20.0),),

              Container(
                height: 50,
                child: new TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || int.parse(value) <= int.parse(_invminController.text) ) {
                      return 'La inversion maxima no debe ser menor a la minima';
                    }
                    return null;
                  },
                  controller: _invmaxController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                        border: OutlineInputBorder(),
                    labelText: 'Inversion Maxima',
                    icon: new Icon(Icons.attach_money),
                  ),
                ),
              ),

             new Padding(padding: new EdgeInsets.only(top: 20.0),),

              Container(
                height: 50,
                child: new TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese una tasa de interes';
                    }
                    return null;
                  },                  
                  controller: _tasaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                        border: OutlineInputBorder(),
                    labelText: 'Tasa de Interes',
                    icon: new Icon(Icons.trending_up),
                  ),
                ),
              ),

             new Padding(padding: new EdgeInsets.only(top: 20.0),),

              Container(
                height: 50,
                child: new TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty ) {
                      return 'Ingrese los meses de duracion';
                    }
                    return null;
                  },                  
                  controller: _duracionController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                        border: OutlineInputBorder(),
                    labelText: 'Meses de Duracion',
                    icon: new Icon(Icons.calendar_today),
                  ),
                ),
              ),

             new Padding(padding: new EdgeInsets.only(top: 44.0),),
              Container(
                height: 50,
                child: new ElevatedButton(
                  onPressed: (){
                if (_formKey.currentState!.validate()) {
                    databaseHelper.addDataPlan(
                        _nameController.text.trim(), _invminController.text.trim(), _invmaxController.text.trim(),
                        _tasaController.text.trim(),_duracionController.text.trim());
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new MyHomePage(),
                        )
                    );


                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }                    

                  },
                  child: new Text(
                    'Agregar',
                    style: new TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.blue),),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}