import 'dart:async';

import 'package:app_storage_kit/app_storage_kit.dart';
import 'package:app_storage_kit/db_storage.dart';
import 'package:app_storage_kit/data_models/db_table_model.dart';
import 'package:app_transaction_manager/data_models/tran_record.dart';

abstract class AppTransactionManager {
  DatabaseStorageKit db;
  bool get inited => db != null && db.dbReady;

  AppTransactionManager() {
    initDB();
  }

  Future<Null> initDB() async {
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
    db = DatabaseStorageKit(table: table);
    await db.initDB();
    return;
  }

  Future<bool> addSentTx(String hash);
  Future<bool> updateTx(
    String hash, {
    dynamic txInfo,
    dynamic txReceipt,
    String confirmTimestamp,
  });
  Future<List<TransactionRecord>> readTxs({
    String where,
    List<String> whereArgs,
    int limit,
    int offset,
    String order,
  });
}
