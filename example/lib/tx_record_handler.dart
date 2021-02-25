import 'package:app_transaction_manager/app_transaction_manager.dart';
import 'package:app_transaction_manager_example/tx_record_model.dart';
import 'package:transaction/web3dart.dart';

class TxRecordHandler extends AppTransactionManager {
  BigInt tokenDecimal;

  @override
  Future<bool> addSentTx(txRd) async {
    await initDB();

    txRd..sendTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

    super.db.setRecord(txRd);
    return true;
  }

  /// Read Trasaction Record from Database
  ///
  /// If local record is complete (Have )
  /// return local record
  /// If local record is not complete (missing info / receipt)
  /// Get info using web3 -> update local data -> return data
  @override
  Future<List<TxRecordModel>> readTxs({
    String where,
    List<String> whereArgs,
    int limit,
    int offset,
    String order,
  }) async {
    await initDB();

    List<Map<String, dynamic>> records = await super.db.getRecords(
          where: where,
          whereArgs: whereArgs,
          offset: offset,
          order: order,
        );

    List<TxRecordModel> finalRecords = [];

    for (int i = 0; i < records.length; i++) {
      final rd = TxRecordModel.fromJson(records[i]);
      bool updated = false;

      /// Update txInfo if found null or missing blockhash
      if (rd.txInfo == null || rd.txInfo?.blockHash == null) {
        updated = true;
        rd.txInfo = await getTxInfo(rd.transactionHash, chain: rd.chain);

        rd.decodedInputAmount =
            await getDecodedInputAmount(rd.txInfo) ?? rd.decodedInputAmount;
      }

      if (rd.txReceipt == null && rd.txInfo.blockHash != null) {
        updated = true;
        rd.txReceipt = await getTxReceipt(rd.transactionHash, chain: rd.chain);

        rd.confirmTimestamp = DateTime.now().millisecondsSinceEpoch.toString();
      }

      if (updated) await updateTx(rd);

      finalRecords.add(rd);
    }

    return finalRecords;
  }

  @override
  Future<bool> updateTx(r) async {
    super.db.setRecord(r);

    return true;
  }

  Future<TransactionInformation> getTxInfo(String hash, {String chain}) async {
    return chain != 'eth'
        ? web3dart.eurusEthClient.getTransactionByHash(hash)
        : await web3dart.mainNetEthClient.getTransactionByHash(hash);
  }

  Future<TransactionReceipt> getTxReceipt(String hash, {String chain}) async {
    return chain != 'eth'
        ? await web3dart.eurusEthClient.getTransactionReceipt(hash)
        : await web3dart.mainNetEthClient.getTransactionReceipt(hash);
  }

  Future<double> getDecodedInputAmount(TransactionInformation txInfo) async {
    if (txInfo.value.getInWei > BigInt.zero) {
      var result = txInfo.value.getInWei / BigInt.from(100000000000000000);
      return result;
    }

    return null;
  }

  Future<BigInt> getTokenDecimal(String contractAddress) async {
    tokenDecimal = BigInt.from(1);

    return tokenDecimal;
  }
}
