import 'dart:convert';

import 'package:app_transaction_manager/data_models/tran_record.dart';
import 'package:transaction/web3dart.dart';

class TxRecordModel extends TransactionRecord {
  TxRecordModel({
    this.transactionHash,
    this.sendTimestamp,
    this.confirmTimestamp,
  }) : super(transactionHash: transactionHash);

  final String transactionHash;
  TransactionInformation txInfo;
  TransactionReceipt txReceipt;
  String sendTimestamp;
  String confirmTimestamp;

  @override
  TxRecordModel.fromJson(Map<String, dynamic> r)
      : transactionHash = r['transactionHash'],
        txInfo = r['txInfo'] != null
            ? TransactionInformation.fromMap(jsonDecode(r['txInfo']))
            : null,
        txReceipt = r['txReceipt'] != null
            ? TransactionReceipt.fromMap(jsonDecode(r['txReceipt']))
            : null,
        sendTimestamp = r['sendTimestamp'],
        confirmTimestamp = r['confirmTimestamp'];

  @override
  Map<String, dynamic> toJson() => {
        'transactionHash': transactionHash,
        'txInfo': txInfo != null ? jsonEncode(txInfoToMap()) : null,
        'txReceipt': txReceipt != null ? jsonEncode(txReceiptToMap()) : null,
        'sendTimestamp': sendTimestamp,
        'confirmTimestamp': confirmTimestamp,
      };

  @override
  Map<String, dynamic> txInfoToMap() {
    return {
      'blockHash': txInfo.blockHash,
      'blockNumber': txInfo.blockNumber,
      'from': txInfo.from,
      'gas': txInfo.gas,
      'gasPrice': txInfo.gasPrice,
      'hash': txInfo.hash,
      'input': txInfo.input,
      'nonce': txInfo.nonce,
      'to': txInfo.to,
      'transactionIndex': txInfo.transactionIndex,
      'value': txInfo.value,
      'v': txInfo.v,
      'r': txInfo.r,
      's': txInfo.s,
    };
  }

  @override
  Map<String, dynamic> txReceiptToMap() {
    return {
      'transactionHash': txReceipt.transactionHash,
      'transactionIndex': txReceipt.transactionIndex,
      'blockHash': txReceipt.blockHash,
      'blockNumber': txReceipt.blockNumber,
      'from': txReceipt.from,
      'to': txReceipt.to,
      'cumulativeGasUsed': txReceipt.cumulativeGasUsed,
      'gasUsed': txReceipt.gasUsed,
      'contractAddress': txReceipt.contractAddress,
      'status': txReceipt.status,
      'logs': txReceipt.logs,
    };
  }
}
