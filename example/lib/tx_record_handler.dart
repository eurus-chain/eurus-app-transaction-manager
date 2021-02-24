import 'package:app_transaction_manager/app_transaction_manager.dart';
import 'package:app_transaction_manager_example/tx_record_model.dart';
import 'package:transaction/web3dart.dart';

class TxRecordHandler extends AppTransactionManager {
  @override
  Future<bool> addSentTx(String hash) async {
    if (!super.inited) await initDB();

    TxRecordModel r = TxRecordModel(
      transactionHash: hash,
      sendTimestamp: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    super.db.setRecord(r);
    return true;
  }

  @override
  Future<List<TxRecordModel>> readTxs({
    String where,
    List<String> whereArgs,
    int limit,
    int offset,
    String order,
  }) async {
    if (!super.inited) await initDB();

    List<Map<String, dynamic>> records = await super.db.getRecords();

    for (int i = 0; i < records.length; i++) {
      var rd = TxRecordModel.fromJson(records[i]);

      if (rd.txInfo == null) {
        TransactionInformation info = await _getTxInfo(rd.transactionHash);
      }
    }

    return [];
  }

  @override
  Future<bool> updateTx(
    String hash, {
    txInfo,
    txReceipt,
    String confirmTimestamp,
  }) {}

  Future<TransactionInformation> _getTxInfo(String hash) async {
    return await web3dart.mainNetEthClient.getTransactionByHash(hash);
  }

  Future<TransactionReceipt> _getTxReceipt(String hash) async {}
}
