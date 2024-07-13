import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deleteOldOrders() async {
  DateTime now = DateTime.now();
  DateTime sevenDaysAgo = now.subtract(Duration(days: 7));
  Timestamp sevenDaysAgoTimestamp = Timestamp.fromDate(sevenDaysAgo);

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('orders')
      .where('createdAt', isLessThanOrEqualTo: sevenDaysAgoTimestamp)
      .get();

  for (DocumentSnapshot doc in snapshot.docs) {
    await doc.reference.delete();
  }
}


class DeleteOldOrdersButton extends StatelessWidget {
  const DeleteOldOrdersButton({Key? key}) : super(key: key);

  Future<void> deleteOldOrders(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(Duration(days: 7));
    Timestamp sevenDaysAgoTimestamp = Timestamp.fromDate(sevenDaysAgo);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('createdAt', isLessThanOrEqualTo: sevenDaysAgoTimestamp)
        .get();

    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Old orders deleted successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () async {
        await deleteOldOrders(context);
      }, 
      icon: Icon(Icons.delete)
      );
  }
}
