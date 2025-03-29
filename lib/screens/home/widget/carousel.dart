import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:myproject1/db/model/data_model.dart';
import 'dart:io'; // Import for File

class ProductCarousel extends StatelessWidget {
  final ValueNotifier<List<productmodel>> productListNotifier;

  const ProductCarousel({required this.productListNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<productmodel>>(
      valueListenable: productListNotifier,
      builder: (context, products, child) {
        if (products.isEmpty) {
          return const Center(
            child: Text(
              'No products available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        return CarouselSlider(
          options: CarouselOptions(
            height: 220.0, 
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            viewportFraction: 0.85, 
            aspectRatio: 2.0,
          ),
          items: products.map((product) {
            return Builder(
              builder: (BuildContext context) {
                return Card( // Wrap in Card for elevation and shadow
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // White background for cleanliness
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient( // Subtle gradient for appeal
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.amber[50]!, Colors.amber[100]!],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0), // Consistent padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Product Image
                          ClipRRect( // Rounded corners for the image
                            borderRadius: BorderRadius.circular(10),
                            child: product.image != null && product.image!.isNotEmpty
                                ? Image.file(
                                    File(product.image!),
                                    height: 120, // Larger image for prominence
                                    width: 200,
                                    fit: BoxFit.fitHeight,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 120,
                                        width: 120,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    height: 120,
                                    width: 120,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Text(
                                        'No Image',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                          ),
                      
                          Container(
                            height: 30,
                            width: 150,
                            decoration:const BoxDecoration(
                              color: Colors.black,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 3),
                                  spreadRadius: 3,
                                    blurRadius: 3,
                                    color: Colors.grey
                                )
                              ]
                            ),
                            child: Text(
                              product.itemname1 ?? 'Unnamed Product',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}