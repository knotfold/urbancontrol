import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urbancontrol/shared/shared.dart';
import 'package:urbancontrol/services/services.dart';

class CuentaList extends StatelessWidget {
  final Urban urban;

  CuentaList({this.urban});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: Firestore.instance
          .collection('urbans')
          .document(urban.id)
          .collection('cuentas')
          .orderBy('dia', descending: true)
          .snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) return const Text('No hay datos', style: TextStyle(fontSize: 20),);

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshots.data.documents.length,
          physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          itemBuilder: (context, index) => CuentaCard(
            cuenta: Cuenta.fromDSnapshot(snapshots.data.documents[index]),
          ),
        );
      },
    );
  }
}
