import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct{

  late String cid;
  late String category; //ID da categoria
  late String pid; //ID do produto
  late int quantity; //QUANTIDADE
  late String size; //TAMANHO

  ProductData? productData; //PARA CARREGAR OS DADOS DA NUVEM

  CartProduct();

  //CONVERTE DA NUVEM  PARA CARTPRODUCT
  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.id;
    category = document["category"];
    pid = document["pid"];
    quantity = document["quantity"];
    size = document["size"];
  }

  Map<String,dynamic> toMap(){
    return{
      "category" : category,
      "pid" : pid,
      "quantity" : quantity,
      "size" : size,
      "product" : productData!.toResumeMap(),
    };
  }

}