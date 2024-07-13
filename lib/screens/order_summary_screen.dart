// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MealOrderDetailsScreen extends StatefulWidget {
  const MealOrderDetailsScreen({super.key});

  @override
  _MealOrderDetailsScreenState createState() => _MealOrderDetailsScreenState();
}

class _MealOrderDetailsScreenState extends State<MealOrderDetailsScreen> {
  DateTime now = DateTime.now();

  String getFormattedDate(DateTime date) {
    return DateFormat('d MMMM E').format(date);
  }

  DateTime getPreviousDay(DateTime date) {
    return date.subtract(Duration(days: 1));
  }

  Future<Map<String, Map<String, int>>> fetchOrders(DateTime date) async {
    DateTime startOfDay = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    List<QueryDocumentSnapshot> orderDocs = snapshot.docs;

    Map<String, Map<String, int>> categorizedOrders = {
      'Breakfast': {},
      'Lunch': {},
      'Dinner': {},
      'Snacks': {},
    };

    for (var orderDoc in orderDocs) {
      QuerySnapshot confirmOrdersSnapshot = await orderDoc.reference.collection('confirmOrders').get();
      List<QueryDocumentSnapshot> confirmOrderDocs = confirmOrdersSnapshot.docs;

      for (var confirmOrderDoc in confirmOrderDocs) {
        var data = confirmOrderDoc.data() as Map<String, dynamic>;
        String productName = data['productName'];
        int productQuantity = data['productQuantity'];
        String categoryName = data['categoryName'].toLowerCase();

        if (categoryName == 'breakfast') {
          categorizedOrders['Breakfast'] = updateOrderCount(categorizedOrders['Breakfast']!, productName, productQuantity);
        } else if (categoryName == 'lunch') {
          categorizedOrders['Lunch'] = updateOrderCount(categorizedOrders['Lunch']!, productName, productQuantity);
        } else if (categoryName == 'dinner') {
          categorizedOrders['Dinner'] = updateOrderCount(categorizedOrders['Dinner']!, productName, productQuantity);
        } else if (categoryName == 'snacks') {
          categorizedOrders['Snacks'] = updateOrderCount(categorizedOrders['Snacks']!, productName, productQuantity);
        }
      }
    }

    return categorizedOrders;
  }

  Map<String, int> updateOrderCount(Map<String, int> orderCount, String productName, int productQuantity) {
    if (orderCount.containsKey(productName)) {
      orderCount[productName] = orderCount[productName]! + productQuantity;
    } else {
      orderCount[productName] = productQuantity;
    }
    return orderCount;
  }

  @override
  Widget build(BuildContext context) {
    DateTime previousDay = getPreviousDay(now);

    return SingleChildScrollView(
        child: Column(
          children: [
            _buildOrderSection('Yesterday\'s Orders (${getFormattedDate(previousDay)})', previousDay),
           SizedBox(height: 30,),
            _buildOrderSection('Today\'s Orders (${getFormattedDate(now)})', now),
          ],
        ),
      );
  }

  Widget _buildOrderSection(String title, DateTime date) {
    return FutureBuilder<Map<String, Map<String, int>>>(
      future: fetchOrders(date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No orders data available for $title.'));
        }

        final orders = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildCategorySection('Breakfast', orders['Breakfast']!),
            _buildCategorySection('Lunch', orders['Lunch']!),
            _buildCategorySection('Dinner', orders['Dinner']!),
            _buildCategorySection('Snacks', orders['Snacks']!),
          ],
        );
      },
    );
  }

  Widget _buildCategorySection(String category, Map<String, int> orders) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ...orders.entries.map((entry) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key, style: TextStyle(fontSize: 16)),
                Text('${entry.value} piece${entry.value > 1 ? 's' : ''}', style: TextStyle(fontSize: 16)),
              ],
            );
          }).toList(),
          Divider(height: 30,),
        ],
      ),
    );
  }
}
