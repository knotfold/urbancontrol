import 'package:flutter/material.dart';
import 'package:urbancontrol/services/services.dart';
import 'package:urbancontrol/shared/shared.dart';

class HistorialCard extends StatefulWidget {
  final Historial historial;
  HistorialCard({this.historial});

  @override
  _HistorialCardState createState() => _HistorialCardState();
}

class _HistorialCardState extends State<HistorialCard> {
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
                  child: Text(widget.historial.nombre),
                ),
                 IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text(
                              '¿Seguro que desea eliminar este acontecimiento, del historial?',
                              style: TextStyle(color: Colors.black),
                            ),
                            title: Text(
                              'Eliminar acontecimiento del historial',
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
                                   widget.historial.reference.delete();
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
                              child: Text(
                                  widget.historial.dia.toDate().toString())),
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
                      widget.historial.gastos.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 50.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(
                                    parent: NeverScrollableScrollPhysics()),
                                itemCount: widget.historial.gastos.length,
                                itemBuilder: (context, index) => Container(
                                  child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            '- Descripción: ${widget.historial.gastos[index]['desc']}'),
                                        Text(
                                            '- Gasto: \$ ${widget.historial.gastos[index]['gasto']}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      widget.historial.gasto != null
                          ? Row(
                              children: <Widget>[
                                Icon(
                                  Icons.monetization_on,
                                  color: yellow,
                                  size: 25,
                                ),
                                Text(
                                    'Gasto total = \$ ${widget.historial.gasto.toString()}')
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
