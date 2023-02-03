import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:camera_app/token_abi.dart';
import 'package:camera_app/token_class.dart';

class SendToken extends StatefulWidget {
  const SendToken({super.key});

  @override
  State<SendToken> createState() => _SendTokenState();
}

class _SendTokenState extends State<SendToken> {
  final client = Web3Client(
    'https://goerli.infura.io/v3/fde20f4993364d3082af631d3a07b990',
    Client(),
  );

// The address that will receive the token.
  final EthereumAddress receiverAddress =
      EthereumAddress.fromHex('0xE4a11C83c693609EFa68FBf5bB7EB0b4Fc94E4fb');

// The address that will send the token.
  final EthereumAddress senderAddress =
      EthereumAddress.fromHex('0xE4a11C83c693609EFa68FBf5bB7EB0b4Fc94E4fb');

// The private key of the senderAddress.
  static const privateKey = '{private key}';
  final EthPrivateKey _credentials = EthPrivateKey.fromHex(privateKey);

// The address of the token contract.
  final _tokenAddress =
      EthereumAddress.fromHex('0x3FcB63277Cf936284eF16157aCb544F4179E8a00');

  DeployedContract? _contract;
  ContractFunction? _transfer;
  Token? _token;

  @override
  void initState() {
    super.initState();
    _token = Token(address: _tokenAddress, client: client, chainId: 5);
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
    final decimalPlaces = 18;

    try {
      // var result = await client.call(
      //     contract: _contract!,
      //     function: _contract!.function('balanceOf'),
      //     params: [senderAddress]);

      var result = await client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract!,
              from: senderAddress,
              function: _transfer!,
              parameters: [
                receiverAddress,
                EtherAmount.fromUnitAndValue(EtherUnit.ether, 1)
                    .getValueInUnitBI(EtherUnit.wei)
              ],
              gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 5),
              maxGas: 5000000),
          chainId: 5);

      // var result = await _token!
      //     .sendCoin(receiverAddress, amount, credentials: _credentials);
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
