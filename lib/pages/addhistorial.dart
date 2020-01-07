import 'package:flutter/material.dart';
import 'package:urbancontrol/shared/shared.dart';
import 'package:urbancontrol/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urbancontrol/pages/pages.dart';

class AddHistorial extends StatefulWidget {
  final Urban urban;
  AddHistorial({this.urban});
  @override
  _AddHistorialState createState() => _AddHistorialState();
}

class _AddHistorialState extends State<AddHistorial> {
  bool isLoading = false;
  int gasto = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> gastos = [];
  List<Widget> myWidgets = [];

  Map<String, dynamic> formData = {
    'nombre': null,
    'dia': DateTime.now(),
    'gasto': null,
    'gastos': <Map<String, dynamic>>[],
    'desc' : null
  };
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadiendo acontecimiento'),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Text(
                'Nuevo acontecimiento de la unidad ${widget.urban.ruta}/${widget.urban.no}',
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
                    txtNombre(),
                    txtDescAc(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.money_off),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Gastos',
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                      itemCount: gastos.length,
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
    print(gastos.length);

    isLoading = true;

    if(gastos.isNotEmpty){
      for(var gast in  gastos){
        gasto = gasto + int.parse(gast['gasto']);
        print(gast['gasto']);
      }
    }

    formData['gastos'] = gastos;
    formData['gasto'] = gasto;

    var query =  await Firestore.instance.collection('urbans').document(widget.urban.id).collection('historial').add(formData).then((onValue) {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> UrbanDetails(urban: widget.urban,)), ModalRoute.withName('/'));

    });

  
      
    


  }

  addGasto() {
    setState(() {
      gastos.add({'gasto': null, 'desc': null});
    });
  }

  eliminarGasto() {
    setState(() {
      gastos.removeLast();
    });
  }

  Widget gastoWidget(int index) {
    return Column(
      children: <Widget>[txtGasto(index), txtDesc(index)],
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

  Widget txtDescAc() {
    return Container(
      margin: EdgeInsets.only(right: 25.0, top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
       
        validator: (String value) {
       
        },
        decoration: InputDecoration(
            icon: Icon(Icons.desktop_mac),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText: 'Descripción o datos extra'),
        onSaved: (value) {
          formData['desc'] = value;
        },
      ),
    );
  }

  Widget txtGastoGeneral() {
    return Row(
      children: <Widget>[
        Icon(Icons.monetization_on),
        SizedBox(
          width: 20,
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            gasto.toString(),
            style: TextStyle(fontSize: 16),
          ),
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor, width: 3)),
        ),
      ],
    );
  }

  Widget txtNombre() {
    return Container(
      margin: EdgeInsets.only(right: 25.0, top: 20.0),
      child: TextFormField(
         style: TextStyle(color: Colors.black),
        
        validator: (String value) {
          if (value.isEmpty) {
            return 'Llenar campo de nombre correctamente';
          }
        },
        decoration: InputDecoration(
            icon: Icon(Icons.archive),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText: 'Nombre del aconntecimiento'),
        onSaved: (value) {
          formData['nombre'] = value;
        },
      ),
    );
  }

  Widget txtGasto(int index) {
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
            icon: Icon(Icons.money_off),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText: 'Gasto'),
        onSaved: (value) {
          gastos.elementAt(index)['gasto'] = value;
        },
      ),
    );
  }

  

  Widget txtDesc(int index) {
    return Container(
      margin: EdgeInsets.only(right: 25.0, top: 20.0),
      child: TextFormField(
         style: TextStyle(color: Colors.black),
      
        validator: (String value) {
          if (value.isEmpty) {
            return 'Llenar campo de descripción del evento correctamente';
          }
        },
        decoration: InputDecoration(
            icon: Icon(Icons.description),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            labelText: 'Descripción del gasto'),
        onSaved: (value) {
          gastos.elementAt(index)['desc'] = value;
        },
      ),
    );
  }
}
