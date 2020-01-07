import 'package:flutter/material.dart';
import 'package:urbancontrol/shared/shared.dart';
import 'package:urbancontrol/pages/pages.dart';
import 'package:urbancontrol/services/services.dart';


class SearchPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              TextField(
                toolbarOptions: ToolbarOptions(),
              )
            ],
          ),
        ),
      ),
    );
  }
}