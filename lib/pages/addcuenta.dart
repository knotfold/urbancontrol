import 'package:flutter/material.dart';
import 'package:urbancontrol/shared/shared.dart';
import 'package:urbancontrol/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urbancontrol/pages/pages.dart';

class AddCuenta extends StatefulWidget {
  final Urban urban;
  AddCuenta({this.urban});
  @override
  _AddCuentaState createState() => _AddCuentaState();
}

class _AddCuentaState extends State<AddCuenta> {
  bool isLoading = false;
  int gasto = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> detalles = [];
  List<Widget> myWidgets = [];

  Map<String, dynamic> formData = {
    'cantidad': null,
    'dia': DateTime.now(),
    'detalles': <Map<String, dynamic>>[],
    'excusas': null
  };
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadiendo entrega de cuenta'),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Text(
                'Nueva entrega de cuenta de la unidad ${widget.urban.ruta}/${widget.urban.no}',
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
                    dateSelector(),
                    txtExcusas(),
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.details),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Agregar detalles de la cuenta entregada',
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
                      itemCount: detalles.length,
                      itemBuilder: (context, index) => gastoWidget(index),
                    ),
                    isLoading ? CircularProgressIndicator() : myButtonBar(),
                  ],
                ),
              )
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

    _formKey.currentState.save();

    isLoading = true;

    if (detalles.isNotEmpty) {
      for (var gast in detalles) {
        gasto = gasto + int.parse(gast['cantidad']);
      
      }
    }

    formData['detalles'] = detalles;
    formData['cantidad'] = gasto;

    var query = await Firestore.instance
        .collection('urbans')
        .document(widget.urban.id)
        .collection('cuentas')
        .add(formData)
        .then((onValue) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => UrbanDetails(
                    urban: widget.urban,
                  )),
          ModalRoute.withName('/'));
    });
  }

  addGasto() {
    setState(() {
      detalles.add({'turno': null, 'cantidad': null, 'chofer': null});
    });
  }

  eliminarGasto() {
    setState(() {
      detalles.removeLast();
    });
  }

  Widget gastoWidget(int index) {
    return Card(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
        children: <Widget>[
            txtCantidad(index),
            SizedBox(
              height: 15,
            ),
            dropDown(widget.urban.chofer,
                'Seleccione al chofer que entrega la cuenta', index),
            txtTurno(index)
        ],
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
          child: Text('AGREGAR A HISTORIAL'),
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

  Widget txtExcusas() {
    return Container(
      margin: EdgeInsets.only(right: 25.0, top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
      
        validator: (String value) {},
        decoration: InputDecoration(
            icon: Icon(Icons.desktop_mac),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText:
                'Excusas presentadas en caso de que no se haya entregado la cuenta completa'),
        onSaved: (value) {
          formData['excusas'] = value;
        },
      ),
    );
  }

  Widget dropDown(List<String> lista, String header, int index) {
    String dropdownValue = widget.urban.chofer.elementAt(index);
    detalles.elementAt(index)['chofer'] = widget.urban.chofer.elementAt(index);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          header,
          style: TextStyle(fontSize: 16),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.card_membership),
            SizedBox(
              width: 10,
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: primaryColor,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  detalles.elementAt(index)['chofer'] = newValue;
                });
              },
              items: lista.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget txtCantidad(int index) {
    return Container(
      margin: EdgeInsets.only(right: 25.0, top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        keyboardType: TextInputType.numberWithOptions(),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Llenar campo de gasto correctamente';
          }
        },
        decoration: InputDecoration(
            icon: Icon(Icons.monetization_on),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText: 'Cantidad entregada por el chofer'),
        onSaved: (value) {
          detalles.elementAt(index)['cantidad'] = value;
        },
      ),
    );
  }

  Widget txtTurno(int index) {
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
            icon: Icon(Icons.assignment_turned_in),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText: 'Turno en el que labora el chofer'),
        onSaved: (value) {
          detalles.elementAt(index)['turno'] = value;
        },
      ),
    );
  }
}
