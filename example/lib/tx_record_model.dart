import 'dart:convert';

import 'package:app_transaction_manager/data_models/tran_record.dart';
import 'package:transaction/web3dart.dart';
import 'package:web3dart/crypto.dart';

class TxRecordModel extends TransactionRecord {
  TxRecordModel({
    this.transactionHash,
    this.decodedInputAmount,
    this.sendTimestamp,
    this.confirmTimestamp,
  }) : super(transactionHash: transactionHash);

  final String transactionHash;
  TransactionInformation txInfo;
  TransactionReceipt txReceipt;
  double decodedInputAmount;
  String txTo;
  String txFrom;
  String sendTimestamp;
  String confirmTimestamp;
  String chain;

  @override
  TxRecordModel.fromJson(Map<String, dynamic> r)
      : transactionHash = r['transactionHash'],
        txInfo = r['txInfo'] != null
            ? TransactionInformation.fromMap(jsonDecode(r['txInfo']))
            : null,
        txReceipt = r['txReceipt'] != null
            ? TransactionReceipt.fromMap(jsonDecode(r['txReceipt']))
            : null,
        decodedInputAmount = double.tryParse(r['decodedInputAmount']) ?? null,
        sendTimestamp = r['sendTimestamp'],
        confirmTimestamp = r['confirmTimestamp'],
        txTo = r['txTo'],
        txFrom = r['txFrom'];

  @override
  Map<String, dynamic> toJson() => {
        'transactionHash': transactionHash,
        'txInfo': txInfo != null ? jsonEncode(txInfoToMap()) : null,
        'txReceipt': txReceipt != null ? jsonEncode(txReceiptToMap()) : null,
        'txFrom': txInfo?.from?.hex ?? txFrom,
        'txTo': txInfo?.to?.hex ?? txTo,
        'txInput': txInfo?.input,
        'decodedInputAmount': decodedInputAmount,
        'sendTimestamp': sendTimestamp,
        'confirmTimestamp': confirmTimestamp,
        'chain': chain
      };

  @override
  Map<String, dynamic> txInfoToMap() {
    return {
      'blockHash': txInfo.blockHash,
      'blockNumber': txInfo.blockNumber.toString(),
      'from': txInfo.from?.hex,
      'gas': txInfo.gas.toString(),
      'gasPrice': txInfo.gasPrice.getInWei.toString(),
      'hash': txInfo.hash,
      'input': bytesToHex(txInfo.input),
      'nonce': txInfo.nonce.toString(),
      'to': txInfo.to?.hex,
      'transactionIndex': txInfo.transactionIndex.toString(),
      'value': txInfo.value.getInWei.toString(),
      'v': '0x' + txInfo.v.toRadixString(16),
      'r': '0x' + txInfo.r.toRadixString(16),
      's': '0x' + txInfo.s.toRadixString(16),
    };
  }

  @override
  Map<String, dynamic> txReceiptToMap() {
    return {
      'transactionHash': bytesToHex(txReceipt.transactionHash),
      'transactionIndex': txReceipt.transactionIndex.toString(),
      'blockHash': bytesToHex(txReceipt.blockHash),
      'blockNumber': txReceipt.blockNumber.toString(),
      'from': txReceipt.from.hex,
      'to': txReceipt.to.hex,
      'cumulativeGasUsed': '0x' + txReceipt.cumulativeGasUsed.toRadixString(16),
      'gasUsed': '0x' + txReceipt.gasUsed.toRadixString(16),
      'contractAddress': txReceipt.contractAddress?.hex,
      'status': txReceipt.status == true ? '0x1' : '0x0',
      'logs': filterEventToMap(txReceipt.logs),
    };
  }

  List<Map<String, dynamic>> filterEventToMap(List<FilterEvent> l) {
    List<Map<String, dynamic>> result = [];

    l.forEach((e) {
      final Map<String, dynamic> log = {
        'removed': e.removed,
        'logIndex': '0x' + e.logIndex.toRadixString(16),
        'transactionIndex': '0x' + e.transactionIndex.toRadixString(16),
        'transactionHash': e.transactionHash,
        'blockHash': e.blockHash,
        'blockNum': '0x' + e.blockNum.toRadixString(16),
        'address': e.address.hex,
        'data': e.data,
        'topics': e.topics,
      };

      result.add(log);
    });

    return result;
  }
}
