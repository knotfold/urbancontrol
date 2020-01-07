import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urbancontrol/shared/shared.dart';
import 'package:urbancontrol/services/services.dart';

class UrbanList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left:30.0 , right: 30.0, top: 50.0),
        child: Column(
          children: <Widget>[
            Text('Lista de urbans', style: TextStyle(fontSize: 20),),
            StreamBuilder(
              stream: Firestore.instance.collection('urbans').orderBy('ruta', descending: true).snapshots(),
              builder: (context,snapshots) { 
                if (!snapshots.hasData) return const Text('Loading...');
                return ListView.builder(
                
                itemCount: snapshots.data.documents.length,
                shrinkWrap: true,
                physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                itemBuilder: (context,index) => UrbanCard(urban: Urban.fromDSnapshot(snapshots.data.documents[index]),navigate: true,),
              );
              }
            ),
          ],
        ),
      ),
    );
  }
}