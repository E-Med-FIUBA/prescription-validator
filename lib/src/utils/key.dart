import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
// ignore: implementation_imports
import 'package:pointycastle/src/platform_check/platform_check.dart';
import "package:pointycastle/export.dart";

const publicExponent = '65537';
const bitStrength = 2048;
const certaintyFactor = 64;

AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
    SecureRandom secureRandom,
    {int bitLength = bitStrength}) {
  // Create an RSA key generator and initialize it

  // final keyGen = KeyGenerator('RSA'); // Get using registry
  final keyGen = RSAKeyGenerator();

  keyGen.init(ParametersWithRandom(
      RSAKeyGeneratorParameters(
          BigInt.parse(publicExponent), bitLength, certaintyFactor),
      secureRandom));

  // Use the generator

  final pair = keyGen.generateKeyPair();

  // Cast the generated key pair into the RSA key types

  final myPublic = pair.publicKey as RSAPublicKey;
  final myPrivate = pair.privateKey as RSAPrivateKey;

  return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
}

SecureRandom generateSecureRandom() {
  final secureRandom = SecureRandom('Fortuna')
    ..seed(
        KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
  return secureRandom;
}

String encodePublicKeyToPem(RSAPublicKey publicKey) {
  var algorithmSeq = ASN1Sequence()
    ..add(ASN1ObjectIdentifier.fromName('rsaEncryption'))
    ..add(ASN1Null());

  var publicKeySeq = ASN1Sequence()
    ..add(ASN1Integer(publicKey.modulus!))
    ..add(ASN1Integer(publicKey.exponent!));

  var bitString = ASN1BitString(Uint8List.fromList(publicKeySeq.encodedBytes));
  var topLevelSeq = ASN1Sequence()
    ..add(algorithmSeq)
    ..add(bitString);

  var dataBase64 = base64.encode(topLevelSeq.encodedBytes);
  return '''-----BEGIN PUBLIC KEY-----\n$dataBase64\n-----END PUBLIC KEY-----''';
}

String encodePrivateKeyToPem(RSAPrivateKey privateKey) {
  var privateKeySeq = ASN1Sequence()
    ..add(ASN1Integer(BigInt.zero)) // version
    ..add(ASN1Integer(privateKey.modulus!))
    ..add(ASN1Integer(privateKey.publicExponent!))
    ..add(ASN1Integer(privateKey.privateExponent!))
    ..add(ASN1Integer(privateKey.p!))
    ..add(ASN1Integer(privateKey.q!))
    ..add(
        ASN1Integer(privateKey.privateExponent! % (privateKey.p! - BigInt.one)))
    ..add(
        ASN1Integer(privateKey.privateExponent! % (privateKey.q! - BigInt.one)))
    ..add(ASN1Integer(privateKey.q!.modInverse(privateKey.p!)));

  var dataBase64 = base64.encode(privateKeySeq.encodedBytes);
  return '''-----BEGIN PRIVATE KEY-----\n$dataBase64\n-----END PRIVATE KEY-----''';
}

RSAPrivateKey parsePrivateKeyFromPem(String pemString) {
  final privateKeyPem = pemString
      .replaceAll('-----BEGIN PRIVATE KEY-----', '')
      .replaceAll('-----END PRIVATE KEY-----', '')
      .replaceAll('\n', '');

  var bytes = base64.decode(privateKeyPem);

  ASN1Parser parser = ASN1Parser(bytes);
  ASN1Sequence sequence = parser.nextObject() as ASN1Sequence;

  var modulus = (sequence.elements[1] as ASN1Integer).valueAsBigInteger;
  var privateExponent = (sequence.elements[3] as ASN1Integer).valueAsBigInteger;
  var p = (sequence.elements[4] as ASN1Integer).valueAsBigInteger;
  var q = (sequence.elements[5] as ASN1Integer).valueAsBigInteger;

  return RSAPrivateKey(modulus, privateExponent, p, q);
}

RSAPublicKey parsePublicKeyFromPem(String pemString) {
  final publicKeyPem = pemString
      .replaceAll('-----BEGIN PUBLIC KEY-----', '')
      .replaceAll('-----END PUBLIC KEY-----', '')
      .replaceAll('\n', '');

  var bytes = base64.decode(publicKeyPem);

  ASN1Parser parser = ASN1Parser(bytes);
  ASN1Sequence sequence = parser.nextObject() as ASN1Sequence;

  ASN1Sequence publicKeySeq = ASN1Parser(sequence.elements[1].contentBytes())
      .nextObject() as ASN1Sequence;
  var modulus = (publicKeySeq.elements[0] as ASN1Integer).valueAsBigInteger;
  var exponent = (publicKeySeq.elements[1] as ASN1Integer).valueAsBigInteger;

  return RSAPublicKey(modulus, exponent);
}
