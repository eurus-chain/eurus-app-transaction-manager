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
  }

  Future<Null> _initDB() async {
    DBTableModel table = DBTableModel(
      tableName: 'transaction_hash',
      fields: [
        TableFieldModel(name: 'transactionHash', type: 'TEXT', isPK: true),
        TableFieldModel(name: 'blockHash', type: 'TEXT'),
        TableFieldModel(name: 'blockNumber', type: 'TEXT'),
        TableFieldModel(name: 'contractAddress', type: 'TEXT'),
        TableFieldModel(name: 'from', type: 'TEXT'),
        TableFieldModel(name: 'to', type: 'TEXT'),
        TableFieldModel(name: 'gas', type: 'TEXT'),
        TableFieldModel(name: 'gasPrice', type: 'TEXT'),
        TableFieldModel(name: 'cumulativeGasUsed', type: 'TEXT'),
        TableFieldModel(name: 'gasUsed', type: 'TEXT'),
        TableFieldModel(name: 'nonce', type: 'TEXT'),
        TableFieldModel(name: 'sendDateTime', type: 'TEXT'),
        TableFieldModel(name: 'confirmDateTime', type: 'TEXT'),
        TableFieldModel(name: 'status', type: 'TEXT'),
      ],
    );

    _db = DatabaseStorageKit(table: table);
  }

  Future<bool> addTransaction(TransactionRecord r) async {
    int response = await _db.setRecord(r);
  }

  Future<void> setTransaction(TransactionRecord r) async {
    await _db.setRecord(r);
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
    response.forEach((val) {
      records.add(TransactionRecord().fromJson(val));
    });

    return records;
  }

  Future<dynamic> _getTransactionByHash(String hash) async {
    TransactionInformation info =
        await web3dart.mainNetEthClient.getTransactionByHash(hash);
  }
}
