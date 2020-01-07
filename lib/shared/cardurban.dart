import 'package:flutter/material.dart';
import 'package:urbancontrol/services/services.dart';
import 'package:urbancontrol/pages/pages.dart';

class UrbanCard extends StatelessWidget {
  final Urban urban;
  final bool navigate;
  UrbanCard({this.urban, this.navigate});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () => navigate
          ? Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UrbanDetails(
                    urban: urban,
                  )))
          : null,
      child: Card(
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.airport_shuttle,
                size: 50,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(urban.ruta + '/' + urban.no),
                    ListView.builder(
                      itemBuilder: (context, index) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.person, size: 20),
                          Text(urban.chofer.elementAt(index)),
                        ],
                      ),
                      itemCount: urban.chofer.length,
                      shrinkWrap: true,
                      physics:
                          ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 20,
                          color: Colors.yellow[700],
                        ),
                        Text(urban.gpd.toString() + '/ dia'),
                      ],
                    ),
                  ],
                ),
              ),
              // navigate
              //     ? Icon(
              //         Icons.arrow_forward_ios,
              //       )
              //     : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
