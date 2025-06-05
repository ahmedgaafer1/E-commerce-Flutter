import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/cart_data.dart';
import '../models/product_model.dart';

class Order {
  final List<CartItem> items;
  final double total;
  final DateTime dateTime;

  Order({required this.items, required this.total, required this.dateTime});

  Map<String, dynamic> toJson() => {
    'items': items
        .map(
          (item) => {
            'id': item.product.id,
            'name': item.product.name,
            'price': item.product.price,
            'image': item.product.image,
            'quantity': item.quantity,
          },
        )
        .toList(),
    'total': total,
    'dateTime': dateTime.toIso8601String(),
  };

  static Order fromJson(Map<String, dynamic> json) {
    final List<CartItem> parsedItems = (json['items'] as List).map((item) {
      return CartItem(
        product: Product(
          id: item['id'],
          name: item['name'],
          image: item['image'],
          price: (item['price'] as num).toDouble(),
          category: '',
          discount: 0,
          description: '',
        ),
        quantity: item['quantity'],
      );
    }).toList();

    return Order(
      items: parsedItems,
      total: (json['total'] as num).toDouble(),
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}

List<Order> orderHistory = [];

Future<void> saveOrdersToPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final encoded = jsonEncode(orderHistory.map((o) => o.toJson()).toList());
  await prefs.setString('orderHistory', encoded);
}

Future<void> loadOrdersFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final encoded = prefs.getString('orderHistory');
  if (encoded != null) {
    final List decoded = jsonDecode(encoded);
    orderHistory = decoded.map((o) => Order.fromJson(o)).toList();
  }
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    loadOrdersFromPrefs().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),
      body: orderHistory.isEmpty
          ? const Center(child: Text("No orders placed yet."))
          : ListView.builder(
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Text(
                      "Total: \$${order.total.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Date: ${order.dateTime.toLocal().toString().split('.')[0]}",
                    ),
                    children: order.items.map((item) {
                      return ListTile(
                        title: Text(item.product.name),
                        trailing: Text(
                          "${item.quantity} x \$${item.product.price}",
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
