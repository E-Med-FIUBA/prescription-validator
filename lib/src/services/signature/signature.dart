import 'dart:typed_data';

import 'package:emed/src/services/signature/key_repository.dart';
import 'package:pointycastle/export.dart';

class Signature {
  final KeyPairRepository keyRepository = KeyPairRepository();

  String sign(RSAPrivateKey privateKey, Uint8List dataToSign) {
    final privateKey = keyRepository.privateKey;

    if (privateKey == null) {
      throw Exception('Private key does not exist');
    }

    final signer = Signer('SHA-256/RSA');

    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));

    final sig = signer.generateSignature(dataToSign);

    return sig.toString();
  }
}
