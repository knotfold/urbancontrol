import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urbancontrol/shared/shared.dart';
import 'package:urbancontrol/services/services.dart';

class HistorialList extends StatelessWidget {
  final Urban urban;

  HistorialList({this.urban});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: Firestore.instance
          .collection('urbans')
          .document(urban.id)
          .collection('historial')
          .orderBy('dia', descending: true)
          .snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) return const Text('No hay datos', style: TextStyle(fontSize: 20),);

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshots.data.documents.length,
          physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          itemBuilder: (context, index) => HistorialCard(
            historial: Historial.fromDSanpshot(snapshots.data.documents[index]),
          ),
        );
      },
    );
  }
}
