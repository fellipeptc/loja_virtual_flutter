import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {

  final String orderId;
  OrderScreen(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido Realizado"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
                Icons.check_circle_outline_outlined,
              color: Colors.green,
              size: 80.0,
            ),
            Text(
              "Pedido realizado com sucesso!",
              style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 5.0,),
            Text(
              "Código do pedido",
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              "$orderId",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
            ),

          ],
        ),
      ),
    );
  }
}
