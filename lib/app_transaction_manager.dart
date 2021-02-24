import 'dart:async';

import 'package:app_storage_kit/app_storage_kit.dart';
import 'package:app_storage_kit/db_storage.dart';
import 'package:app_storage_kit/data_models/db_table_model.dart';
import 'package:app_transaction_manager/data_models/tran_record.dart';
import 'package:transaction/web3dart.dart';

class AppTransactionManager {
  DatabaseStorageKit _db;
  Web3dart web3dart;

  AppTransactionManager() {
    web3dart = Web3dart();
    _initDB();
  }

  Future<Null> _initDB() async {
    DBTableModel table = DBTableModel(
      tableName: 'transaction_hash',
      fields: [
        TableFieldModel(name: 'transactionHash', type: 'TEXT', isPK: true),
        TableFieldModel(name: 'txInfo', type: 'TEXT'),
        TableFieldModel(name: 'txReceipt', type: 'TEXT'),
        TableFieldModel(name: 'sendTimestamp', type: 'TEXT'),
        TableFieldModel(name: 'confirmTimestamp', type: 'TEXT'),
      ],
    );
    _db = DatabaseStorageKit(table: table);
  }

  Future<bool> addSentTransaction(String hash) async {
    await _initDB();

    TransactionRecord r = TransactionRecord(
      transactionHash: hash,
      sendTimestamp: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    await _db.setRecord(r);
    return true;
  }

  Future<List<TransactionRecord>> readTransaction({
    String where,
    List<String> whereArgs,
    int limit,
    int offset,
    String order,
  }) async {
    List<Map<String, dynamic>> response = await _db.getRecords(
      where: where,
      whereArgs: whereArgs,
      limit: limit,
      offset: offset,
      order: order,
    );

    List<TransactionRecord> records = [];
    for (int i = 0; i < response.length; i++) {
      var record = TransactionRecord.fromJson(response[i]);

      // await _getTransactionByHash(record.transactionHash);

      records.add(record);
    }

    return records;
  }

  Future<dynamic> _getTransactionByHash(String hash) async {
    TransactionInformation info =
        await web3dart.mainNetEthClient.getTransactionByHash(hash);

    print(info.toString());
  }
}
