import 'package:flutter/material.dart';
import 'package:urbancontrol/services/services.dart';
import 'package:urbancontrol/shared/shared.dart';

class CuentaCard extends StatefulWidget {
  final Cuenta cuenta;
  CuentaCard({this.cuenta});

  @override
  _CuentaCardState createState() => _CuentaCardState();
}

class _CuentaCardState extends State<CuentaCard> {
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        setState(() {
          if (clicked) {
            clicked = false;
            return;
          }

          clicked = true;
        });
      },
      child: Container(
        margin: EdgeInsets.all(1.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 3),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  clicked ? Icons.arrow_drop_up : Icons.arrow_drop_down_circle,
                  color: yellow,
                  size: 25,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(widget.cuenta.dia.toDate().day.toString() +
                      '/' +
                      widget.cuenta.dia.toDate().month.toString() +
                      '/' +
                      widget.cuenta.dia.toDate().year.toString()),
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text(
                              '¿Seguro que desea eliminar esta cuenta, del historial de cuentas?',
                              style: TextStyle(color: Colors.black),
                            ),
                            title: Text(
                              'Eliminar cuenta del historial',
                              style: TextStyle(color: Colors.black),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(color: primaryColor),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              RaisedButton(
                                color: primaryColor,
                                onPressed: () {
                                  widget.cuenta.reference.delete();
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Elminar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )),
                )
              ],
            ),
            clicked
                ? Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            size: 25,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child:
                                  Text(widget.cuenta.dia.toDate().toString())),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.details,
                            size: 25,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Text('Detalles')),
                        ],
                      ),
                      widget.cuenta.detalles.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 50.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(
                                    parent: NeverScrollableScrollPhysics()),
                                itemCount: widget.cuenta.detalles.length,
                                itemBuilder: (context, index) => Container(
                                  child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            '- Descripción: ${widget.cuenta.detalles[index]['chofer']}'),
                                        Text(
                                            '- Cantidad: \$ ${widget.cuenta.detalles[index]['cantidad']}'),
                                        Text(
                                            '- Turno:  ${widget.cuenta.detalles[index]['turno']}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      widget.cuenta.cantidad != null
                          ? Row(
                              children: <Widget>[
                                Icon(
                                  Icons.monetization_on,
                                  color: yellow,
                                  size: 25,
                                ),
                                Text(
                                    'Ganancia total = \$ ${widget.cuenta.cantidad.toString()}')
                              ],
                            )
                          : Container(),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
