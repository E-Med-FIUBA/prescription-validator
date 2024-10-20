import 'package:emed/src/utils/let.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/pointycastle.dart';

import '../../utils/key.dart';

enum _SecureStorageKeys { privateKey, certificate, publicKey }

class KeyPairRepository {
  static late final FlutterSecureStorage _secureStorage;

  static RSAPublicKey? _publicKey;

  static RSAPrivateKey? _privateKey;

  static String? _certificate;

  static void init() async {
    _secureStorage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.passcode));

    _privateKey = let(
        await _getFromSecureStorage(_SecureStorageKeys.privateKey),
        (key) => parsePrivateKeyFromPem(key));
    _publicKey = let(await _getFromSecureStorage(_SecureStorageKeys.publicKey),
        (key) => parsePublicKeyFromPem(key));

    _certificate = await _getFromSecureStorage(_SecureStorageKeys.certificate);
  }

  static Future<String?> _getFromSecureStorage(_SecureStorageKeys key) async {
    if (await _secureStorage.containsKey(key: key.name)) {
      return await _secureStorage.read(key: key.name) ?? '';
    }

    return null;
  }

  setKeyPair() async {
    final keyPair = generateRSAkeyPair(generateSecureRandom());

    _publicKey = keyPair.publicKey;
    _privateKey = keyPair.privateKey;

    await saveKeyPairToStorage(keyPair);
  }

  saveKeyPairToStorage(
      AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> pair) async {
    await _secureStorage.write(
        key: _SecureStorageKeys.privateKey.name,
        value: encodePrivateKeyToPem(pair.privateKey));
    await _secureStorage.write(
        key: _SecureStorageKeys.publicKey.name,
        value: encodePublicKeyToPem(pair.publicKey));
  }

  RSAPrivateKey? get privateKey {
    return _privateKey;
  }

  RSAPublicKey? get publicKey {
    return _publicKey;
  }

  setCertificate(String certificate) {
    _certificate = certificate;

    saveCertificateToStorage(certificate);
  }

  saveCertificateToStorage(String certificate) async {
    await _secureStorage.write(
        key: _SecureStorageKeys.certificate.name, value: certificate);
  }

  String? get certificate {
    if (_certificate != null) {
      return _certificate;
    }

    return _certificate;
  }
}
