import 'package:flutter/material.dart';
import '../data/cart_data.dart';
import 'order_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get totalPrice {
    return widget.cartItems.fold(0.0, (sum, item) {
      final priceAfterDiscount =
          item.product.price -
          (item.product.price * item.product.discount / 100);
      return sum + priceAfterDiscount * item.quantity;
    });
  }

  Future<void> saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      widget.cartItems
          .map(
            (item) => {
              'id': item.product.id,
              'name': item.product.name,
              'image': item.product.image,
              'price':
                  item.product.price -
                  (item.product.price * item.product.discount / 100),
              'quantity': item.quantity,
            },
          )
          .toList(),
    );
    await prefs.setString('savedCart', encoded);
  }

  void increaseQty(int index) async {
    setState(() {
      widget.cartItems[index].quantity++;
    });
    await saveCartToPrefs();
  }

  void decreaseQty(int index) async {
    if (widget.cartItems[index].quantity > 1) {
      setState(() {
        widget.cartItems[index].quantity--;
      });
      await saveCartToPrefs();
    }
  }

  void removeItem(int index) async {
    setState(() {
      widget.cartItems.removeAt(index);
    });
    await saveCartToPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return ListTile(
                        leading: Image.network(
                          item.product.image,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        ),
                        title: Text(item.product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.product.discount > 0)
                              Row(
                                children: [
                                  Text(
                                    "\$${item.product.price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "\$${(item.product.price - item.product.price * item.product.discount / 100).toStringAsFixed(2)} x ${item.quantity}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                "Price: \$${item.product.price.toStringAsFixed(2)} x ${item.quantity}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => decreaseQty(index),
                            ),
                            Text(item.quantity.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => increaseQty(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => removeItem(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Total: \$${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (widget.cartItems.isEmpty) return;

                          final newOrder = Order(
                            items: List.from(widget.cartItems),
                            total: totalPrice,
                            dateTime: DateTime.now(),
                          );
                          orderHistory.add(newOrder);
                          await saveOrdersToPrefs();

                          widget.cartItems.clear();
                          await saveCartToPrefs();

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Order placed!")),
                          );

                          setState(() {});
                        },
                        child: const Text("Place Order"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
