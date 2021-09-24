import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser!.uid;

      return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("orders")
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              print(snapshot.data!.docs);
              if (snapshot.data!.docs.length == 0 ||
                  snapshot.data!.docs == null) {
                return Center(
                  child: Text(
                    "Nenhum pedido realizado!",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F0F0F)),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return ListView(
                  children: snapshot.data!.docs
                      .map((doc) => OrderTile(doc.id))
                      .toList().reversed.toList(),
                );
              }
            }
          });
    } else {
      return Container(
        padding: EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.view_list_sharp,
              color: Theme.of(context).primaryColor,
              size: 80.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Faça o login para visualizar pedidos!",
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
                  padding: EdgeInsets.only(
                      left: 5.0, top: 10.0, right: 5.0, bottom: 10.0),
                  textStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                  primary: Theme.of(context).primaryColor),
            ),
          ],
        ),
      );
    }
  }
}
