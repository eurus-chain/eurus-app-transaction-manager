import 'package:app_storage_kit/data_models/db_record.dart';

class TransactionRecord extends DBRecord {
  TransactionRecord({
    this.transactionHash,
    this.blockHash,
    this.blockNumber,
    this.from,
    this.to,
  });

  final String transactionHash;
  final String blockHash;
  final String blockNumber;
  final String from;
  final String to;
  String contractAddress;
  String gas;
  String gasPrice;
  String cumulativeGasUsed;
  String gasUsed;
  String nonce;
  String sendDateTime;
  String confirmDateTime;
  String status;

  @override
  TransactionRecord fromJson(Map<String, dynamic> r) => TransactionRecord(
        transactionHash: r['transactionHash'],
        blockHash: r['blockHash'],
        blockNumber: r['blockNumber'],
        from: r['from'],
        to: r['to'],
      )
        ..contractAddress = r['contractAddress']
        ..gas = r['gas']
        ..gasPrice = r['gasPrice']
        ..cumulativeGasUsed = r['cumulativeGasUsed']
        ..gasUsed = r['gasUsed']
        ..nonce = r['nonce']
        ..sendDateTime = r['sendDateTime']
        ..confirmDateTime = r['confirmDateTime']
        ..status = r['status'];

  @override
  Map<String, dynamic> toJson() => {
        'transactionHash': transactionHash,
        'blockHash': blockHash,
        'blockNumber': blockNumber,
        'from': from,
        'to': to,
        'contractAddress': contractAddress,
        'gas': gas,
        'gasPrice': gasPrice,
        'cumulativeGasUsed': cumulativeGasUsed,
        'gasUsed': gasUsed,
        'nonce': nonce,
        'sendDateTime': sendDateTime,
        'confirmDateTime': confirmDateTime,
        'status': status,
      };
}
