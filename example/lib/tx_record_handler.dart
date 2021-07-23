import 'dart:typed_data';

import 'package:app_transaction_manager/app_transaction_manager.dart';
import 'package:app_transaction_manager_example/tx_record_model.dart';
import 'package:transaction/web3dart.dart';
import 'package:web3dart/crypto.dart';

class TxRecordHandler extends AppTransactionManager {
  Map<String, int> _ethTokenDecimal = {};
  Map<String, int> _eunTokenDecimal = {};

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
    String? where,
    List<String>? whereArgs,
    int? limit,
    int? offset,
    String? order,
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
        rd.txInfo = rd.chain != null
            ? await getTxInfo(rd.transactionHash, chain: rd.chain!)
            : null;

        if (rd.txInfo != null) {
          rd.txFrom = rd.txInfo?.from.hex;
          rd.txTo = rd.txInfo?.to?.hex;
          rd.txInput = rd.txInfo?.input;

          if (rd.txInfo!.input.length > 2) {
            final toHex = rd.txInfo!.to?.hex ?? '';
            int? decimal = toHex.isNotEmpty
                ? await getTokenDecimal(toHex, chain: rd.chain!)
                : null;

            Map<String, dynamic> decodedVal =
                decodedInput(rd.txInfo!.input, decimals: decimal ?? 0);

            rd.decodedInputFncIdentifierHex = decodedVal['fncIdentifier'];
            rd.decodedInputRecipientAddress = decodedVal['address'];
            rd.decodedInputAmount = decodedVal['amount'];
          } else {
            rd.decodedInputAmount =
                getDecodedInputAmount(rd.txInfo!.value.getInWei, 18);
          }
        }
      }

      if (rd.txReceipt == null && rd.txInfo?.blockHash != null) {
        updated = true;
        rd.txReceipt = rd.chain != null
            ? await getTxReceipt(rd.transactionHash, chain: rd.chain!)
            : null;

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

  /// Get TransactionInformation using web3dart
  Future<TransactionInformation> getTxInfo(String hash,
      {required String chain}) async {
    return chain == 'eun'
        ? await web3dart.eurusEthClient.getTransactionByHash(hash)
        : await web3dart.mainNetEthClient.getTransactionByHash(hash);
  }

  /// Get TransactionReceipt using web3dart
  Future<TransactionReceipt?> getTxReceipt(String hash,
      {required String chain}) async {
    return chain == 'eun'
        ? await web3dart.eurusEthClient.getTransactionReceipt(hash)
        : await web3dart.mainNetEthClient.getTransactionReceipt(hash);
  }

  /// Get Token decimal by contract address using web3dart
  Future<int> getTokenDecimal(String contractAddress,
      {required String chain}) async {
    int? loadedDecimal = chain == 'eun'
        ? _eunTokenDecimal[contractAddress]
        : _ethTokenDecimal[contractAddress];

    if (loadedDecimal != null) return loadedDecimal;

    DeployedContract contract = chain == 'eun'
        ? web3dart.getEurusERC20Contract(contractAddress: contractAddress)
        : web3dart.getEthereumERC20Contract(contractAddress: contractAddress);

    BigInt decimal = await web3dart.getContractDecimal(
        deployedContract: contract,
        blockChainType:
            chain == 'eun' ? BlockChainType.Eurus : BlockChainType.Ethereum);

    int finalDecimal = decimal.toInt();

    chain == 'eun'
        ? _eunTokenDecimal.addAll({contractAddress: finalDecimal})
        : _ethTokenDecimal.addAll({contractAddress: finalDecimal});

    return finalDecimal;
  }

  double getDecodedInputAmount(BigInt amount, int decimals) {
    return amount / BigInt.from(10).pow(decimals);
  }

  @override
  Map<String, dynamic> decodedInput(Uint8List raw, {int decimals = 0}) {
    if (raw.length < 3) return Map<String, dynamic>();

    String input = bytesToHex(raw);

    String fncIdentifier = '0x' + input.substring(0, 8);

    String addressRaw = input.substring(10, 72);
    RegExp exp = new RegExp(r"^0+(.+)$");
    var matches = exp.allMatches(addressRaw);

    if ((matches.elementAt(0).group(1) ?? '').isEmpty)
      return Map<String, dynamic>();

    String address = '0x' + matches.elementAt(0).group(1)!;

    String amountRaw = input.substring(72, 136);
    double amountBigInt = hexToInt(amountRaw) / (BigInt.from(10).pow(decimals));

    return {
      'fncIdentifier': fncIdentifier,
      'address': address,
      'amount': amountBigInt,
    };
  }
}
