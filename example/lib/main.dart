import 'package:app_transaction_manager_example/logging_client.dart';
import 'package:app_transaction_manager_example/tx_record_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:transaction/web3dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TxRecordHandler manager;
  Web3dart web3dart;

  @override
  void initState() {
    manager = TxRecordHandler();
    _initWeb3();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          child: Center(
            child: Column(
              children: [
                FlatButton(
                  onPressed: () => _btn1(),
                  child: Text('Add record'),
                ),
                FlatButton(
                  onPressed: () => _btn2(),
                  child: Text('Read record'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initWeb3() async {
    web3dart = Web3dart();
    web3dart
      ..mainNetEthClient = Web3Client(
        'https://rinkeby.infura.io/v3/9e3b26ef3d2c45d2b9ff73cc933bead1',
        // LoggingClient(Client()),
        Client(),
      );
  }

  void _btn1() async {
    manager.addSentTx(
        '0x16b6b6c0f5c9b3285992e8e88a5e2922c82f65df3b02c11ca96c2a596733285a');
  }

  void _btn2() async {
    manager.readTxs();
  }
}
