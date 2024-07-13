// ignore_for_file: prefer_const_constructors, file_names, must_be_immutable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:CateringAdmin/models/product-model.dart';
import 'package:CateringAdmin/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SingleProductDetailScreen extends StatelessWidget {
  final ProductModel productModel;

  SingleProductDetailScreen({
    Key? key,
    required this.productModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(productModel.productName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display the first image at the top
            CachedNetworkImage(
              imageUrl: productModel.productImages.isNotEmpty
                  ? productModel.productImages[0]
                  : '',
              fit: BoxFit.cover,
              height: 300,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: 10),
            // Product Details Card
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Product Name", productModel.productName),
                    _buildDetailRow(
                      "Product Price",
                      productModel.salePrice != ''
                          ? productModel.salePrice
                          : productModel.fullPrice,
                    ),
                    _buildDetailRow("Delivery Time", productModel.deliveryTime),
                    _buildDetailRow("Is Sale?", productModel.isSale ? "True" : "False"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8.0),
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
