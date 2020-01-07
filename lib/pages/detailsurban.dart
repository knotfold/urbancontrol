import 'package:flutter/material.dart';
import 'package:urbancontrol/services/services.dart';
import 'package:urbancontrol/shared/shared.dart';
import 'package:urbancontrol/pages/pages.dart';

class UrbanDetails extends StatelessWidget {
  final Urban urban;

  UrbanDetails({this.urban});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Detalles de  ${urban.ruta}/${urban.no}',
          style: TextStyle(fontSize: 20, color: pdark),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              UrbanCard(
                urban: urban,
                navigate: true,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.history,
                            color: sdark,
                          ),
                          SizedBox(width: 30,),
                          Text(
                            'Historial de acontecimientos',
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_box),
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddHistorial(
                                          urban: urban,
                                        ))),
                          )
                        ],
                      ),
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          icon: IconButton(icon: Icon(Icons.search), onPressed: () => null, padding: EdgeInsets.all(1),),
                          labelText: 'Buscar en el historial',
                          hintText: 'Buscar en el historial',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      toolbarOptions: ToolbarOptions(),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    HistorialList(
                      urban: urban,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.monetization_on,
                            color: pdark,
                          ),
                          SizedBox(width: 30,),
                          Text(
                            'Historial de cuentas',
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_box),
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddCuenta(
                                          urban: urban,
                                        ))),
                          )
                        ],
                      ),
                    ),
                    CuentaList(
                      urban: urban,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
