import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:loja_virtual/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

import 'order_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int tam = model.products.length;
                return Text(
                  "${tam == null ? 0 : tam} ${tam == 1 ? "ITEM" : "ITENS"}",
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(builder: (context, child, model) {
        if (model.isLoading && UserModel.of(context).isLoggedIn()) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!UserModel.of(context).isLoggedIn()) {
          return Container(
            padding: EdgeInsets.all(26.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.remove_shopping_cart,
                  color: Theme.of(context).primaryColor,
                  size: 80.0,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Faça o login para adicionar produtos!",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F0F0F)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    "Entrar",
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 3.0,
                    padding: EdgeInsets.only(left: 5.0, top: 10.0, right: 5.0, bottom: 10.0),
                      textStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                      primary: Theme.of(context).primaryColor),
                ),
              ],
            ),
          );
        } else if(model.products == null || model.products.length == 0){
          return Center(
            child: Text(
              "Nenhum produto no carrinho!",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F0F0F)),
              textAlign: TextAlign.center,
            ),
          );
        } else{
          return ListView(
            children: <Widget>[
              Column(
                children: model.products.map((product){
                  return CartTile(product);
                }).toList(),
              ),
              DiscountCard(),
              ShipCard(),
              CartPrice(() async{
                String? orderId = await model.finishOrder();
                if(orderId!=null){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => OrderScreen(orderId))
                  );
                }
              }),
            ],
          );
        }
      }),
    );
  }
}
