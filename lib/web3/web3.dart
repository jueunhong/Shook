import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class SendToken extends StatefulWidget {
  const SendToken({super.key});

  @override
  State<SendToken> createState() => _SendTokenState();
}

class _SendTokenState extends State<SendToken> {
  static const rpcUrl = '';

  final client = Web3Client(
    rpcUrl,
    Client(),
  );

// The address that will receive the token.
  final EthereumAddress receiverAddress = EthereumAddress.fromHex('');

// The address that will send the token.
  final EthereumAddress senderAddress = EthereumAddress.fromHex('');

// The private key of the senderAddress.
  static const privateKey = '';
  final EthPrivateKey _credentials = EthPrivateKey.fromHex(privateKey);

// The address of the token contract.
  final EthereumAddress _tokenAddress =
      EthereumAddress.fromHex('0x3FcB63277Cf936284eF16157aCb544F4179E8a00');

  DeployedContract? _contract;
  ContractFunction? _transfer;

  @override
  void initState() {
    super.initState();
    readAbi().then((String value) {
      _contract =
          DeployedContract(ContractAbi.fromJson(value, 'Token'), _tokenAddress);
      _transfer = _contract?.function('transfer');
    });
  }

  Future<String> readAbi() async {
    return await rootBundle.loadString('assets/abi.json');
  }

  Future<void> sendToken() async {
    try {
      var result = await client.sendTransaction(
          _credentials,
          Transaction.callContract(
            contract: _contract!,
            function: _transfer!,
            parameters: [
              receiverAddress,
              EtherAmount.fromUnitAndValue(EtherUnit.ether, 1)
                  .getValueInUnitBI(EtherUnit.wei)
            ],
          ),
          chainId: 5);
      print(result);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        sendToken();
      },
      child: Text('Points to Token'),
    );
  }
}
