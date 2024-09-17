import 'dart:convert';

import 'package:exam_week_three/models/productModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowProduct extends StatefulWidget {
  const ShowProduct({super.key});

  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllProduct();
  }

  List<Product> listOfProduct = [];
  final TextEditingController _productNameTEXController =
      TextEditingController();
  final TextEditingController _productCodeTEXController =
      TextEditingController();
  final TextEditingController _productImgTEXController =
      TextEditingController();
  final TextEditingController _productUnitePriceTEXController =
      TextEditingController();
  final TextEditingController _productQuantityTEXController =
      TextEditingController();
  final TextEditingController _productTotalPriceTEXController =
      TextEditingController();

  bool _isLoading = true;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Product"),
          centerTitle: true,
          actions: [IconButton(onPressed: (){ getAllProduct();}, icon: Icon(Icons.refresh)),]
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio:0.6),
                    itemCount: listOfProduct.length,
                    itemBuilder: (context, index) {
                      Product product = listOfProduct[index];
                      return Container(
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.8,
                              blurRadius: 3,
                              offset: Offset(1, 0.5))
                        ]),
                        child: Column(
                          children: [
                            Image.network(
                              product.img,
                              width: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product.productName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(product.productCode)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Price : ${product.unitPrice}"),
                                  Text("Quantity: ${product.qty}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          deleteProduct(product.id);
                                        },
                                        icon: Icon(Icons.delete)),
                                    IconButton(
                                        onPressed: () {
                                          showUpdateDialog(product);
                                        },
                                        icon: Icon(Icons.update)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            CreateDialog();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void CreateDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              width: 400,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            "Add Product",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          )
                        ],
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _productNameTEXController,
                            decoration: InputDecoration(
                                label: Text("Name"),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _productCodeTEXController,
                            decoration: InputDecoration(
                                label: Text("Code"),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _productImgTEXController,
                            decoration: InputDecoration(
                                label: Text("Image"),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _productQuantityTEXController,
                            decoration: InputDecoration(
                                label: Text("Quantity"),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _productUnitePriceTEXController,
                            decoration: InputDecoration(
                                label: Text("Product Price"),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _productTotalPriceTEXController,
                            decoration: InputDecoration(
                                label: Text("Total Price"),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: TextButton(
                              onPressed: () {
                                OnTabAddProduct();
                              },
                              child: Text("Add Product"),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void OnTabAddProduct() {
    if (_formKey.currentState!.validate()) {
      addNewProduct();
    }
  }

  void showUpdateDialog(Product product) {
    // Set controllers with current product data
    _productNameTEXController.text = product.productName;
    _productCodeTEXController.text = product.productCode;
    _productImgTEXController.text = product.img;
    _productUnitePriceTEXController.text = product.unitPrice;
    _productQuantityTEXController.text = product.qty;
    _productTotalPriceTEXController.text = product.totalPrice;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 400,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Text(
                      "Update Product",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _productNameTEXController,
                          decoration: InputDecoration(
                            label: Text("Name"),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _productCodeTEXController,
                          decoration: InputDecoration(
                            label: Text("Code"),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _productImgTEXController,
                          decoration: InputDecoration(
                            label: Text("Image"),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _productQuantityTEXController,
                          decoration: InputDecoration(
                            label: Text("Quantity"),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _productUnitePriceTEXController,
                          decoration: InputDecoration(
                            label: Text("Product Price"),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _productTotalPriceTEXController,
                          decoration: InputDecoration(
                            label: Text("Total Price"),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.maxFinite,
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                updateProduct(product.id);
                              }
                            },
                            child: Text("Update Product"),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getAllProduct() async {
    try {
      _isLoading = true;
      setState(() {});
      http.Response response = await http
          .get(Uri.parse("http://164.68.107.70:6060/api/v1/ReadProduct"));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        listOfProduct.clear(); // Clear the list before adding new data

        for (var item in jsonResponse["data"]) {
          Product product = Product(
            id: item["_id"] ?? "",
            productName: item["ProductName"] ?? "Unknown",
            productCode: item["ProductCode"] ?? "Unknown Code",
            img: item["Img"] ?? "default_image.jpg",
            unitPrice: item["UnitPrice"] ?? "Unknown UnitPrice",
            qty: item["Qty"] ?? "",
            totalPrice: item["TotalPrice"] ?? "Unknown Code",
            createdDate: item["CreatedDate"] ?? "Unknown Time",
          );
          listOfProduct.add(product);
        }
        setState(() {});
        _isLoading = false;
        setState(() {});
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  Future<void> addNewProduct() async {
    try {
      Map<String, dynamic> requestBody = {
        "Img": _productImgTEXController.text,
        "ProductCode": _productCodeTEXController.text,
        "ProductName": _productNameTEXController.text,
        "Qty": _productQuantityTEXController.text,
        "TotalPrice": _productTotalPriceTEXController.text,
        "UnitPrice": _productUnitePriceTEXController.text
      };
      http.Response response = await http.post(
          Uri.parse("http://164.68.107.70:6060/api/v1/CreateProduct"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Successfully add product")));
      Navigator.pop(context);
      getAllProduct();
    } catch (error) {
      throw Exception("Failed To create New Product $error");
    }
  }

  Future<void> deleteProduct(id) async {
    try {
      http.Response response = await http
          .get(Uri.parse("http://164.68.107.70:6060/api/v1/DeleteProduct/$id"));
      if (response.statusCode == 200) {
        print("Product Deleted Successfully");
      }
      getAllProduct();
    } catch (error) {
      throw Exception("Failed TO delete Product $error");
    }
  }

  Future<void> updateProduct(id) async {
    try {
      Map<String, dynamic> requestBody = {
        "Img": _productImgTEXController.text,
        "ProductCode": _productCodeTEXController.text,
        "ProductName": _productNameTEXController.text,
        "Qty": _productQuantityTEXController.text,
        "TotalPrice": _productTotalPriceTEXController.text,
        "UnitPrice": _productUnitePriceTEXController.text
      };
      http.Response response = await http.post(
          Uri.parse("http://164.68.107.70:6060/api/v1/UpdateProduct/$id"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Successfully Updated product")));
      Navigator.pop(context);
      getAllProduct();
    } catch (error) {
      throw Exception("Failed To create New Product $error");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _productNameTEXController.dispose();
    _productQuantityTEXController.dispose();
    _productUnitePriceTEXController.dispose();
    _productTotalPriceTEXController.dispose();
    _productImgTEXController.dispose();
    _productCodeTEXController.dispose();
  }
}
