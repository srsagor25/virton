import 'dart:convert';
import 'package:logger/logger.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_ecommerce/constants/routes.dart';
import 'package:youtube_ecommerce/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:youtube_ecommerce/models/category_model/category_model.dart';
import 'package:youtube_ecommerce/provider/app_provider.dart';
import 'package:youtube_ecommerce/screens/category_view/category_view.dart';
import 'package:youtube_ecommerce/screens/product_details/product_details.dart';
import 'package:youtube_ecommerce/widgets/top_titles/top_titles.dart';

import '../../models/product_model/product_model.dart';

final logger = Logger();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categoriesList = [];
  List<ProductModel> productModelList = [];

  bool isLoading = false;

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    getCategoryList();
    super.initState();
  }

  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestoreHelper.instance.updateTokenFromFirebase();
    categoriesList = await FirebaseFirestoreHelper.instance.getCategories();
    productModelList = await FirebaseFirestoreHelper.instance.getBestProducts();

    productModelList.shuffle();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  TextEditingController search = TextEditingController();
  List<ProductModel> searchList = [];
  void searchProducts(String value) {
    searchList = productModelList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  Future<List<int>> fetchImageFromFirebase(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // Send the image to the API for try-on
      await sendImageToAPI(response.bodyBytes);

      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<void> sendImageToAPI(List<int> imageBytes) async {
    // Convert the image bytes to base64
    String base64Image = base64Encode(imageBytes);

    // Prepare the POST request body
    Map<String, dynamic> body = {
      'image': base64Image,
    };

    // Make the POST request to the API endpoint
    Uri apiUrl = Uri.parse('http://192.168.68.137:5000/');
    http.Response apiResponse = await http.post(apiUrl, body: body);

    // Process the API response as needed
    if (apiResponse.statusCode == 200) {
      logger.d("Image successfully sent to the API");
    } else {
      logger.e("Failed to send image to the API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TopTitles(subtitle: "", title: "E Commerce"),
                        TextFormField(
                          controller: search,
                          onChanged: (String value) {
                            searchProducts(value);
                          },
                          decoration:
                              const InputDecoration(hintText: "Search...."),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        const Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  categoriesList.isEmpty
                      ? const Center(
                          child: Text("Categories is empty"),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categoriesList
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Routes.instance.push(
                                            widget:
                                                CategoryView(categoryModel: e),
                                            context: context);
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image.network(e.image),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  !isSearched()
                      ? const Padding(
                          padding: EdgeInsets.only(top: 12.0, left: 12.0),
                          child: Text(
                            "Best Products",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : SizedBox.fromSize(),
                  const SizedBox(
                    height: 12.0,
                  ),
                  search.text.isNotEmpty && searchList.isEmpty
                      ? const Center(
                          child: Text("No Product Found"),
                        )
                      : searchList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GridView.builder(
                                  padding: const EdgeInsets.only(bottom: 50),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: searchList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 20,
                                          crossAxisSpacing: 20,
                                          childAspectRatio: 0.7,
                                          crossAxisCount: 2),
                                  itemBuilder: (ctx, index) {
                                    ProductModel singleProduct =
                                        searchList[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.3),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 12.0,
                                          ),
                                          Image.network(
                                            singleProduct.image,
                                            height: 100,
                                            width: 100,
                                          ),
                                          const SizedBox(
                                            height: 12.0,
                                          ),
                                          Text(
                                            singleProduct.name,
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                              "Price: \$${singleProduct.price}"),
                                          const SizedBox(
                                            height: 30.0,
                                          ),
                                          SizedBox(
                                            height: 20,
                                            width: 70,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Routes.instance.push(
                                                    widget: ProductDetails(
                                                        singleProduct:
                                                            singleProduct),
                                                    context: context);
                                              },
                                              child: const Text(
                                                "Buy",
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          SizedBox(
                                            height: 45,
                                            width: 140,
                                            child: OutlinedButton(
                                              onPressed: () async {
                                                List<int> imageBytes =
                                                    await fetchImageFromFirebase(
                                                        singleProduct.image);
                                                await sendImageToAPI(
                                                    imageBytes);
                                              },
                                              child: const Text(
                                                "Try-on",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          : productModelList.isEmpty
                              ? const Center(
                                  child: Text("Best Product is empty"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: GridView.builder(
                                      padding:
                                          const EdgeInsets.only(bottom: 50),
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: productModelList.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: 20,
                                              crossAxisSpacing: 20,
                                              childAspectRatio: 0.7,
                                              crossAxisCount: 2),
                                      itemBuilder: (ctx, index) {
                                        ProductModel singleProduct =
                                            productModelList[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              Image.network(
                                                singleProduct.image,
                                                height: 100,
                                                width: 100,
                                              ),
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              Text(
                                                singleProduct.name,
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  "Price: \$${singleProduct.price}"),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              SizedBox(
                                                height: 30,
                                                width: 80,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Routes.instance.push(
                                                        widget: ProductDetails(
                                                            singleProduct:
                                                                singleProduct),
                                                        context: context);
                                                  },
                                                  child: const Text(
                                                    "Buy",
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              SizedBox(
                                                height: 30,
                                                width: 80,
                                                child: OutlinedButton(
                                                  onPressed: () async {
                                                    List<int> imageBytes =
                                                        await fetchImageFromFirebase(
                                                            singleProduct
                                                                .image);
                                                    await sendImageToAPI(
                                                        imageBytes);
                                                  },
                                                  child: const Text(
                                                    "Try-on",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                ],
              ),
            ),
    );
  }

  bool isSearched() {
    return search.text.isNotEmpty && searchList.isNotEmpty;
  }
}
