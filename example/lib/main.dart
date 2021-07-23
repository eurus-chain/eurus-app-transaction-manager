import 'package:app_transaction_manager_example/tx_record_handler.dart';
import 'package:app_transaction_manager_example/tx_record_model.dart';
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
  TxRecordHandler manager = TxRecordHandler();
  Web3dart web3dart = Web3dart();

  @override
  void initState() {
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
                TextButton(
                  onPressed: () => _btn1(),
                  child: Text('Add record'),
                ),
                TextButton(
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
    web3dart
      ..mainNetEthClient = Web3Client(
        'https://rinkeby.infura.io/v3/9e3b26ef3d2c45d2b9ff73cc933bead1',
        Client(),
      );
  }

  void _btn1() async {
    await manager.addSentTx(
      TxRecordModel(
          transactionHash:
              '0x5866f2f002de610c2b64afe18e43fed7d0ec16d3b45622e16944082d0db78039')
        ..chain = 'eth',
    );
    await manager.addSentTx(
      TxRecordModel(
          transactionHash:
              '0x16b6b6c0f5c9b3285992e8e88a5e2922c82f65df3b02c11ca96c2a596733285a')
        ..chain = 'eth',
    );
    await manager.addSentTx(
      TxRecordModel(
          transactionHash:
              '0x908709938c9b93d390a1394f14ab5cd5a2d8e690e7321f7b66a4249954742d7c')
        ..chain = 'eth',
    );
    await manager.addSentTx(
      TxRecordModel(
          transactionHash:
              '0x4e209ecf94b887e7b6645dd2193094db1e788bcc75acd8695c999d08c3b7c7e0')
        ..chain = 'eth',
    );
    await manager.addSentTx(
      TxRecordModel(
          transactionHash:
              '0xffcabaaaf48400ca92b98c969d136f5cf9665bdc43b3b490fbcce8952e3c9dd5')
        ..chain = 'eth',
    );
    await manager.addSentTx(
      TxRecordModel(
          transactionHash:
              '0xf2988f8e71aa60529ac7a3629e616e29372d9f5123daecf61af8ee36fbfaadcc')
        ..chain = 'eth'
        ..txFrom = '0x268fede3ee04c1ff53bebea07d8e062d4bcb52bf'
        ..txTo = '0xbd5d797bd25d0a07578ecab9ed5de2504ae49a40'
        ..decodedInputAmount = 1,
    );
  }

  void _btn2() async {
    // List<TxRecordModel> result = await manager.readTxs(
    //   where: "txTo = ?",
    //   whereArgs: ['0xbd5d797bd25d0a07578ecab9ed5de2504ae49a40'],
    // );
    List<TxRecordModel> result = await manager.readTxs();

    print('done result: ${result.length}');

    result.forEach((e) {
      print(
          'vv-llas Amount: ${e.decodedInputAmount}, txFrom: ${e.txFrom} txTo: ${e.txTo}, decodedTo: ${e.decodedInputRecipientAddress}');
    });
  }
}
