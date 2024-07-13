// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, must_be_immutable, sized_box_for_whitespace, prefer_is_empty, avoid_print, await_only_futures

import 'dart:io';
import 'package:CateringAdmin/models/product-model.dart';
import 'package:CateringAdmin/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../controllers/category-dropdown_controller.dart';
import '../controllers/is-sale-controller.dart';
import '../controllers/products-images-controller.dart';
import '../services/generate-ids-service.dart';
import '../widgets/dropdown-categories-widget.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  AddProductImagesController addProductImagesController =
      Get.put(AddProductImagesController());

  //
  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());

  IsSaleController isSaleController = Get.put(IsSaleController());

  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
 // TextEditingController realityController = TextEditingController();

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
          ),
        ],
      );
    },
  );
  }
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Products"),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Select Images"),
                    ElevatedButton(
                      onPressed: () {
                        addProductImagesController.showImagesPickerDialog();
                      },
                      child: Text("Select Images"),
                    )
                  ],
                ),
              ),

              //show Images
              GetBuilder<AddProductImagesController>(
                init: AddProductImagesController(),
                builder: (imageController) {
                  return imageController.selectedIamges.length > 0
                      ? Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: Get.height / 3.0,
                          child: GridView.builder(
                            itemCount: imageController.selectedIamges.length,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Image.file(
                                    File(addProductImagesController
                                        .selectedIamges[index].path),
                                    fit: BoxFit.cover,
                                    height: Get.height / 4,
                                    width: Get.width / 2,
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        imageController.removeImages(index);
                                        print(imageController
                                            .selectedIamges.length);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            AppConstant.appScendoryColor,
                                        child: Icon(
                                          Icons.close,
                                          color: AppConstant.appTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),

              //show categories drop down
              DropDownCategoriesWiidget(),

              //isSale
              // GetBuilder<IsSaleController>(
              //   init: IsSaleController(),
              //   builder: (isSaleController) {
              //     return Card(
              //       elevation: 10,
              //       child: Padding(
              //         padding: EdgeInsets.all(8.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text("Invisible"),
              //             Switch(
              //               value: isSaleController.isSale.value,
              //               activeColor: AppConstant.appMainColor,
              //               onChanged: (value) {
              //                 isSaleController.toggleIsSale(value);
              //               },
              //             )
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              // ),
              //form
              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: productNameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Product Name",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),

              // Obx(() {
              //   return isSaleController.isSale.value
              //       ? Container(
              //           height: 65,
              //           margin: EdgeInsets.symmetric(horizontal: 10.0),
              //           child: TextFormField(
              //             cursorColor: AppConstant.appMainColor,
              //             textInputAction: TextInputAction.next,
              //             controller: salePriceController,
              //             decoration: InputDecoration(
              //               contentPadding: EdgeInsets.symmetric(
              //                 horizontal: 10.0,
              //               ),
              //               hintText: "Sale Price",
              //               hintStyle: TextStyle(fontSize: 12.0),
              //               border: OutlineInputBorder(
              //                 borderRadius: BorderRadius.all(
              //                   Radius.circular(10.0),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         )
              //       : SizedBox.shrink();
              // }),

              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: fullPriceController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Price in BDT",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.0),
              // Container(
              //   height: 65,
              //   margin: EdgeInsets.symmetric(horizontal: 10.0),
              //   child: TextFormField(
              //     cursorColor: AppConstant.appMainColor,
              //     textInputAction: TextInputAction.next,
              //     controller: deliveryTimeController,
              //     decoration: InputDecoration(
              //       contentPadding: EdgeInsets.symmetric(
              //         horizontal: 10.0,
              //       ),
              //       hintText: "Delivery Time",
              //       hintStyle: TextStyle(fontSize: 12.0),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(10.0),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            
              // SizedBox(height: 10.0),

            // Container(
            //     height: 65,
            //     margin: EdgeInsets.symmetric(horizontal: 10.0),
            //     child: TextFormField(
            //       cursorColor: AppConstant.appMainColor,
            //       textInputAction: TextInputAction.next,
            //       controller: realityController,
            //       decoration: InputDecoration(
            //         contentPadding: EdgeInsets.symmetric(
            //           horizontal: 10.0,
            //         ),
            //         hintText: "3d object link",
            //         hintStyle: TextStyle(fontSize: 12.0),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.all(
            //             Radius.circular(10.0),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
              SizedBox(height: 10.0),

              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: productDescriptionController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Product Desc",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),

              ElevatedButton(
  onPressed: () async {
    // Validation checks
    if (categoryDropDownController.selectedCategoryId == null ||
        categoryDropDownController.selectedCategoryId!.isEmpty) {
      _showErrorDialog(context, "Category is required");
      return;
    }
    if (productNameController.text.trim().isEmpty) {
      _showErrorDialog(context, "Product name is required");
      return;
    }
    if (fullPriceController.text.trim().isEmpty) {
      _showErrorDialog(context, "Full price is required");
      return;
    }
    if (addProductImagesController.selectedIamges.isEmpty) {
      _showErrorDialog(context, "At least one product image is required");
      return;
    }
    // if (deliveryTimeController.text.trim().isEmpty) {
    //   _showErrorDialog(context, "Delivery time is required");
    //   return;
    // }
    if (productDescriptionController.text.trim().isEmpty) {
      _showErrorDialog(context, "Product description is required");
      return;
    }

    try {
      EasyLoading.show();
      await addProductImagesController.uploadFunction(
          addProductImagesController.selectedIamges);
      print(addProductImagesController.arrImagesUrl);

      String productId = await GenerateIds().generateProductId();

      ProductModel productModel = ProductModel(
        productId: productId,
        categoryId: categoryDropDownController.selectedCategoryId.toString(),
        productName: productNameController.text.trim(),
        categoryName: categoryDropDownController.selectedCategoryName.toString(),
        salePrice: salePriceController.text != ''
            ? salePriceController.text.trim()
            : '',
        fullPrice: fullPriceController.text.trim(),
        productImages: addProductImagesController.arrImagesUrl,
        deliveryTime: "1",
        isSale: false,
        productDescription: productDescriptionController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .set(productModel.toMap());
      EasyLoading.dismiss();

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Product added successfully!"),
            actions: <Widget>[
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                  Navigator.of(context).pop(); // Go back to previous screen
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      print("error : $e");
      // Show error dialog
      _showErrorDialog(context, "An error occurred while adding the product. Please try again.");
    }
  },
  child: Text("Upload"),
)
            ],
          ),
        ),
      ),
    );
  }
}
