import 'package:app_storage_kit/data_models/db_record.dart';
import 'package:flutter/material.dart';

abstract class TransactionRecord extends DBRecord {
  TransactionRecord({
    @required this.transactionHash,
    this.sendTimestamp,
    this.confirmTimestamp,
  });

  final String transactionHash;
  String sendTimestamp;
  String confirmTimestamp;

  @override
  TransactionRecord.fromJson(Map<String, dynamic> r)
      : transactionHash = r['transactionHash'],
        sendTimestamp = r['sendTimestamp'],
        confirmTimestamp = r['confirmTimestamp'];

  @override
  Map<String, dynamic> toJson() => {
        'transactionHash': transactionHash,
        'sendTimestamp': sendTimestamp,
        'confirmTimestamp': confirmTimestamp,
      };

  Map<String, dynamic> txInfoToMap();
  Map<String, dynamic> txReceiptToMap();
}
