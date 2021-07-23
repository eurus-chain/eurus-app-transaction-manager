import 'dart:async';
import 'dart:typed_data';

import 'package:app_storage_kit/app_storage_kit.dart';
import 'package:app_storage_kit/db_storage.dart';
import 'package:app_storage_kit/data_models/db_table_model.dart';
import 'package:app_transaction_manager/data_models/tran_record.dart';

abstract class AppTransactionManager {
  late DatabaseStorageKit db;
  bool get inited => db.dbReady;

  Future<Null> initDB() async {
    DBTableModel table = DBTableModel(
      tableName: 'transaction_hash',
      fields: [
        TableFieldModel(name: 'transactionHash', type: 'TEXT', isPK: true),
        TableFieldModel(name: 'txInfo', type: 'TEXT'),
        TableFieldModel(name: 'txReceipt', type: 'TEXT'),
        TableFieldModel(name: 'txFrom', type: 'TEXT'),
        TableFieldModel(name: 'txTo', type: 'TEXT'),
        TableFieldModel(name: 'txInput', type: 'TEXT'),
        TableFieldModel(name: 'decodedInputFncIdentifierHex', type: 'TEXT'),
        TableFieldModel(name: 'decodedInputRecipientAddress', type: 'TEXT'),
        TableFieldModel(name: 'decodedInputAmount', type: 'TEXT'),
        TableFieldModel(name: 'sendTimestamp', type: 'TEXT'),
        TableFieldModel(name: 'confirmTimestamp', type: 'TEXT'),
        TableFieldModel(name: 'chain', type: 'TEXT'),
        TableFieldModel(name: 'gasPrice', type: 'TEXT'),
        TableFieldModel(name: 'gasUsed', type: 'TEXT'),
        TableFieldModel(name: 'eurusTxType', type: 'TEXT'),
        TableFieldModel(name: 'eurusTxStatus', type: 'TEXT'),
        TableFieldModel(name: 'adminFee', type: 'TEXT'),
      ],
    );
    db = DatabaseStorageKit(table: table);
    await db.initDB();
    return;
  }

  Future<bool> addSentTx(dynamic r);
  Future<bool> updateTx(dynamic r);
  Future<List<TransactionRecord>> readTxs({
    String where,
    List<String> whereArgs,
    int limit,
    int offset,
    String order,
  });
  Map<String, dynamic> decodedInput(Uint8List input, {int decimals});
}
