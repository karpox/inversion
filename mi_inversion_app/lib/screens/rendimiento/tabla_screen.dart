import 'package:flutter/material.dart';
import 'package:mi_inversion_app/screens/rendimiento/rendimiento_screen.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import 'dart:convert';
import '../../../main.dart';


import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class tablaPage extends StatefulWidget {

  final String nombre;
  final int tasa, duracion;
  final DateTime date;
  final int monto;


  const tablaPage({ Key? key, required this.nombre , required this.tasa, required this.duracion, required this.date, required this.monto}) : super(key: key);

  

  @override
  _tablaPageState createState() => _tablaPageState();
}

class _tablaPageState extends State<tablaPage> {
late List<Employee> emps;
@override
void initState() {
emps = Employee.getUsers(widget.nombre,widget.tasa, widget.duracion, widget.date,widget.monto);
super.initState();
}
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).push( new MaterialPageRoute( builder: (BuildContext context) => new MyHomePage(),))),
          title:  Text('Tabla'),
        ),
        body: Container(
           child: SingleChildScrollView(
           scrollDirection: Axis.horizontal,
          child: DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Plan',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Fecha',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Tasa',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
                DataColumn(
          label: Text(
            'Monto',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Rendimiento',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'plazo',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
rows: emps.map(
                (emp) => DataRow(
                   cells: [
                      DataCell(
                        Text('${emp.plan}'),
                                      ),
                      DataCell(
                        Text('${emp.fecha}'),
                                      ),
                      DataCell(
                        Text('${emp.tasa}'),
                                    ),
                      DataCell(
                        Text('${emp.monto}'),
                      ),
                                            DataCell(
                        Text('${emp.rendimiento}'),
                      ),
                                            DataCell(
                        Text('${emp.plazo}'),
                      ),
                    ]),
              ) .toList(),
        ),
    )
          ) 
        )
      )
    ;
  }

}


class Employee {
String? plan;
String? fecha;
String? tasa;
int? monto;
double? rendimiento;
double? plazo;
Employee({this.plan, this.fecha, this.tasa, this.monto, this.rendimiento, this.plazo});


static  List<Employee> getUsers(String ine,int tas, int dur, DateTime date, int monto) {


  return <Employee>[  
    Employee(
      plan: ine ,
      fecha: '${date.year}/${date.month}/${date.day}',
      tasa: '${tas}',
      monto: monto,
      rendimiento: 0,
      plazo:1),
    for(int i =1; i<dur; i++)
    Employee(
      plan: ' ' ,
      fecha: date.month+i <= 12 ? '${date.year}/${date.month+i}/${date.day}' : '${date.year+1}/${date.month+i - 12}/${date.day}'  ,
      tasa: '${tas}',
      monto: monto,
      rendimiento: ( monto*tas)/100,
      plazo:i+1),

    Employee(
      plan: 'Total Final' ,
      fecha: ' ',
      tasa: ' ',
      monto: monto,
      rendimiento: (( monto*tas)/100)*(dur-1),
      plazo: (( monto*tas)/100)*(dur-1)+ monto) ,
    ];
  }

}