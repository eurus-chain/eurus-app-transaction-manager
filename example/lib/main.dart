import 'package:app_transaction_manager/data_models/tran_record.dart';
import 'package:app_transaction_manager_example/logging_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:app_transaction_manager/app_transaction_manager.dart';
import 'package:transaction/web3dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTransactionManager manager;
  Web3dart web3dart;

  @override
  void initState() {
    // manager = AppTransactionManager();
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
          child: Column(
            children: [
              FlatButton(
                onPressed: () => dummyFnc(),
                child: Text('Add record'),
              ),
              FlatButton(
                onPressed: () => _readRecord(),
                child: Text('Read record'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dummyFnc() async {
    AppTransactionManager().addSentTransaction(
        '0x908709938c9b93d390a1394f14ab5cd5a2d8e690e7321f7b66a4249954742d7c');
  }

  void _initWeb3() async {
    web3dart = Web3dart();
    web3dart
      ..mainNetEthClient = Web3Client(
        'https://rinkeby.infura.io/v3/9e3b26ef3d2c45d2b9ff73cc933bead1',
        LoggingClient(Client()),
      );
  }

  void _addRecord() async {
    await manager.addSentTransaction(
        '0x908709938c9b93d390a1394f14ab5cd5a2d8e690e7321f7b66a4249954742d7c');
    await manager.addSentTransaction(
        '0x4e209ecf94b887e7b6645dd2193094db1e788bcc75acd8695c999d08c3b7c7e0');

    List<dynamic> rs = await manager.readTransaction();
  }

  void _readRecord() async {
    List<TransactionRecord> rs =
        await AppTransactionManager().readTransaction();

    rs.forEach((e) {
      print(e.transactionHash);
    });
  }
}
