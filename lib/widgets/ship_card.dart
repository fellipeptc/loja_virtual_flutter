import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/correios_frete.dart';
import 'package:http/http.dart' as http;
import 'package:loja_virtual/models/cart_model.dart';
import 'package:xml2json/xml2json.dart';
import 'package:search_cep/search_cep.dart';

class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Calcular Frete",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.location_on),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              maxLength: 8,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Digite seu CEP"),
              initialValue: "",
              onFieldSubmitted: (cepDigitado) async {
                Xml2Json xml2json = new Xml2Json(); // class parse XML to JSON

                //VALIDANDO O CEP
                final postmonSearchCep = PostmonSearchCep();
                final infoCepJSON =
                    await postmonSearchCep.searchInfoByCep(cep: cepDigitado);

                String? validaCep =
                    (infoCepJSON.fold((_) => null, (data) => data.cep));

                print("CEP DIGITADO > ${validaCep}");

                if (validaCep != null) {
                  try {
                    var url = Uri.parse(
                        "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx?nCdEmpresa=&sDsSenha=&sCepOrigem=70002900&sCepDestino=$cepDigitado&nVlPeso=1&nCdFormato=1&nVlComprimento=20&nVlAltura=20&nVlLargura=20&sCdMaoPropria=n&nVlValorDeclarado=0&sCdAvisoRecebimento=n&nCdServico=04510&nVlDiametro=0&StrRetorno=xml&nIndicaCalculo=3");

                    http.Response reponse = await http.get(url);

                    print("GET DO XML");
                    print(reponse.body);

                    if (reponse.statusCode == 200) {
                      xml2json.parse(reponse.body);

                      var resultMap = xml2json.toGData();

                      Correios correios = Correios.fromJson(
                          json.decode(resultMap)["Servicos"]["cServico"]);

                      CartModel.of(context).setShip(double.parse(correios.valor.replaceAll(RegExp(r','), '.')));

                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text(
                              "R\$ ${correios.valor} reais \nPrazo da entrega: ${correios.prazo} dias"),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );
                    } else {

                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("Erro de conexão: ${reponse.statusCode}"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  } catch (erro) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(erro.toString()),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                } else {

                  CartModel.of(context).setShip(0.0);

                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("CEP Inválido! Digite novamente."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
