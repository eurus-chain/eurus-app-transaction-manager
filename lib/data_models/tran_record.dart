import 'dart:convert';

import 'package:app_storage_kit/data_models/db_record.dart';
import 'package:flutter/material.dart';
import 'package:transaction/web3dart.dart';

class TransactionRecord extends DBRecord {
  TransactionRecord({
    @required this.transactionHash,
    this.txInfo,
    this.txReceipt,
    this.sendTimestamp,
    this.confirmTimestamp,
  });

  final String transactionHash;
  TransactionInformation txInfo;
  TransactionReceipt txReceipt;
  String sendTimestamp;
  String confirmTimestamp;

  @override
  TransactionRecord.fromJson(Map<String, dynamic> r)
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
      };
}
