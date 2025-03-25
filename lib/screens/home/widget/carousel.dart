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
          return const Center(child: Text('No products available'));
        }
        return CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            enlargeCenterPage: true,
          ),
          items: products.map((product) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display the image if the path exists
                        product.image != null && product.image!.isNotEmpty
                            ? Image.file(
                                File(product.image!), // Convert String path to File
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text('Image not available');
                                },
                              )
                            : const Text('No image'),
                        const SizedBox(height: 10), // Spacing
                        // Display the product name
                        Text(
                          product.itemname1 ?? 'Unnamed Product',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
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