// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, avoid_print

import 'package:CateringAdmin/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'specific-customer-orders-screen.dart';

class Total_Product_Details extends StatefulWidget {
  const Total_Product_Details({super.key});

  @override
  _Total_Product_DetailsState createState() => _Total_Product_DetailsState();
}

class _Total_Product_DetailsState extends State<Total_Product_Details> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 23, minute: 59);

  Future<Map<String, int>> calculateDailyProductSales(DateTime specificDate) async {
    // Calculate the start and end of the specific day with selected times
    DateTime startDateTime = DateTime(specificDate.year, specificDate.month, specificDate.day, startTime.hour, startTime.minute);
    DateTime endDateTime = DateTime(specificDate.year, specificDate.month, specificDate.day, endTime.hour, endTime.minute);

    Timestamp startOfDay = Timestamp.fromDate(startDateTime);
    Timestamp endOfDay = Timestamp.fromDate(endDateTime);

    // Get all documents in the 'orders' collection
    QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance.collection('orders').get();

    Map<String, int> productQuantities = {};

    for (var orderDoc in ordersSnapshot.docs) {
      // For each document in 'orders', get the nested 'confirmOrders' collection
      QuerySnapshot confirmOrdersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderDoc.id)
          .collection('confirmOrders')
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
          .where('createdAt', isLessThanOrEqualTo: endOfDay)
          .get();

      // Aggregate the product quantities in the nested 'confirmOrders' collection
      for (var confirmOrderDoc in confirmOrdersSnapshot.docs) {
        // Ensure data is of type Map<String, dynamic>
        var data = confirmOrderDoc.data() as Map<String, dynamic>;
        String? productName = data['productName'] as String?;
        int? productQuantity = data['productQuantity'] as int?;

        if (productName != null && productQuantity != null) {
          if (productQuantities.containsKey(productName)) {
            productQuantities[productName] = productQuantities[productName]! + productQuantity;
          } else {
            productQuantities[productName] = productQuantity;
          }
        }
      }
    }

    return productQuantities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders Overview"),
        backgroundColor: AppConstant.appMainColor,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () async {
              TimeOfDay? pickedStartTime = await showTimePicker(
                context: context,
                initialTime: startTime,
              );
              if (pickedStartTime != null && pickedStartTime != startTime) {
                setState(() {
                  startTime = pickedStartTime;
                });
              }

              TimeOfDay? pickedEndTime = await showTimePicker(
                context: context,
                initialTime: endTime,
              );
              if (pickedEndTime != null && pickedEndTime != endTime) {
                setState(() {
                  endTime = pickedEndTime;
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Showing sales from ${selectedDate.year}-${selectedDate.month}-${selectedDate.day} ${startTime.format(context)} to ${selectedDate.year}-${selectedDate.month}-${selectedDate.day} ${endTime.format(context)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, int>>(
              future: calculateDailyProductSales(selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No sales data available for the selected date and time range.'));
                } else {
                  final productQuantities = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: productQuantities.length,
                    itemBuilder: (context, index) {
                      final productName = productQuantities.keys.elementAt(index);
                      final productQuantity = productQuantities[productName];

                      return Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text(productName),
                          subtitle: Text('Total sold: $productQuantity'),
                          trailing: Icon(Icons.shopping_cart),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
