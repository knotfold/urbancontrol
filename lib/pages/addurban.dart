import 'package:flutter/material.dart';
import 'package:urbancontrol/shared/shared.dart';
import 'package:urbancontrol/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urbancontrol/pages/pages.dart';

class AddUrban extends StatefulWidget {
  @override
  _AddUrbanState createState() => _AddUrbanState();
}

class _AddUrbanState extends State<AddUrban> {
  bool isLoading = false;
  bool error = false;
  int gasto = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> chofer = ['chofer'];

  List<Map<String, dynamic>> detalles = [];
  List<Widget> myWidgets = [];

  Map<String, dynamic> formData = {
    'ruta': null,
    'no': DateTime.now(),
    'chofer': <String>[],
    'gpd': null,
    'recorrido': null
  };
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadiendo nueva Unidad'),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Text(
                'Añadir nueva unidad',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    txtRuta(),
                    txtNo(),
                    txtGDP(),
                    txtRecorrido(),
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.person_add),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Agregar chofer a esta unidad',
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => addGasto(),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => eliminarGasto(),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                      itemCount: chofer.length,
                      itemBuilder: (context, index) => gastoWidget(index),
                    ),
                    isLoading ? CircularProgressIndicator() : myButtonBar(),
                  ],
                ),
              ),
              error
                  ? Text(
                      'La unidad debe de tener al menos un chofer',
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  sendHistorial() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (chofer.isEmpty) {
      setState(() {
        error = true;
      });

      return;
    }

    error = false;

    _formKey.currentState.save();

    formData['chofer'] = chofer;

    isLoading = true;

    var query = await Firestore.instance
        .collection('urbans')
        .document(formData['ruta'] + formData['no'])
        .setData(formData)
        .then((onValue) {
      Navigator.of(context).pushReplacementNamed('/');
    });
  }

  addGasto() {
    setState(() {
      chofer.add('nuevo');
    });
  }

  eliminarGasto() {
    setState(() {
      if (chofer.isNotEmpty) {
        chofer.removeLast();
      }
    });
  }

  Widget gastoWidget(int index) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[txtNombreChofer(index)],
        ),
      ),
    );
  }

  Widget dateSelector() {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Icon(Icons.calendar_today),
          SizedBox(
            width: 20,
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Fecha: ' +
                  date.day.toString() +
                  '/' +
                  date.month.toString() +
                  '/' +
                  date.year.toString(),
              style: TextStyle(fontSize: 16),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 3)),
          ),
        ],
      ),
      onTap: () => _selectDate(context),
    );
  }

  Widget myButtonBar() {
    return ButtonBar(
      children: <Widget>[
        RaisedButton(
          child: Text('AGREGAR NUEVA UNIDAD'),
          onPressed: () => sendHistorial(),
        )
      ],
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2100),
    );

    setState(() {
      formData['dia'] = Timestamp.fromDate(picked);
      date = picked;
    });
  }

  Widget txtRecorrido() {
    return Container(
      margin: EdgeInsets.only(right: 25.0, top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
     
        validator: (String value) {
          if (value.isEmpty) {
            return 'Llenar campo de recorrido de ruta correctamente';
          }
        },
        decoration: InputDecoration(
            icon: Icon(Icons.map),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText: 'Recorrido que realiza la unidad'),
        onSaved: (value) {
          formData['recorrido'] = value;
        },
      ),
    );
  }

  Widget txtRuta() {
    return Container(
      margin: EdgeInsets.only(right: 25.0, top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        keyboardType: TextInputType.numberWithOptions(),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Llenar campo de numero de ruta correctamente';
          }
        },
        decoration: InputDecoration(
            icon: Icon(Icons.airport_shuttle),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText: 'Numero de Ruta de la unidad'),
        onSaved: (value) {
          formData['ruta'] = value;
        },
      ),
    );
  }

  Widget txtNo() {
    return Container(
      margin: EdgeInsets.only(right: 25.0, top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        keyboardType: TextInputType.numberWithOptions(),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Llenar campo de numero de unidad correctamente';
          }
        },
        decoration: InputDecoration(
            icon: Icon(Icons.format_list_numbered),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText: 'Numero de la unidad'),
        onSaved: (value) {
          formData['no'] = value;
        },
      ),
    );
  }

  Widget txtGDP() {
    return Container(
      margin: EdgeInsets.only(right: 25.0, top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        keyboardType: TextInputType.numberWithOptions(),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Llenar campo de ganancia por dia correctamente';
          }
        },
        decoration: InputDecoration(
            icon: Icon(Icons.monetization_on),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText: 'Cantidad que genera la unidad por dia'),
        onSaved: (value) {
          formData['gpd'] = int.parse(value);
        },
      ),
    );
  }

  Widget txtNombreChofer(int index) {
    return Container(
      margin: EdgeInsets.only(right: 25.0, top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        
        validator: (String value) {
          if (value.isEmpty) {
            return 'Llenar campo de turno por favor';
          }
        },
        decoration: InputDecoration(
            icon: Icon(Icons.person_pin),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText: 'Nombre del chofer'),
        onSaved: (value) {
          chofer[index] = value;
        },
      ),
    );
  }
}
