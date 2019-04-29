import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CrytoCurrency",
      theme: ThemeData.dark(),
      home: HomePage(
        currencies: await _getData(),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  List currencies;
  HomePage({this.currencies});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //  1 USD → 68.92400 INR
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("CryptoCurrency"),
      ),
      body: ListView.builder(
        itemCount: widget.currencies.length,
        itemBuilder: (_, int i) {
          var priceInUsd = widget.currencies[i]['price_usd'];
          var totalPrice = double.parse(priceInUsd) * 68.92400;
          var totalPriceCeil = totalPrice.ceil();
          var percentChangeIn1hList = widget.currencies[i]['percent_change_1h'];
          var percentChangeIn1h =
              (double.parse(percentChangeIn1hList) * 100.0).toStringAsFixed(2);
          return Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      "${widget.currencies[i]['symbol']}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15.0),
                    ),
                  ),
                  title: Text("${widget.currencies[i]['id'].toUpperCase()}"),
                  // subtitle: Text("${widget.currencies[i]['price_usd']} USD"),
                  subtitle: Row(
                    children: <Widget>[
                      Text(
                        "INR: $totalPriceCeil",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 3.0),
                      ),
                      Expanded(
                        child: Text(
                          ", % Change in 1 Hour: $percentChangeIn1h %",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Divider(),
            ],
          );
        },
      ),
    );
  }
}

Future<List> _getData() async {
  String apiUrl = "https://api.coinmarketcap.com/v1/ticker/?limit=50";
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}
