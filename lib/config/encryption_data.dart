import 'package:encrypt/encrypt.dart';

class AESEncryption {

  static String encrypt(String value) {
    final key = Key.fromUtf8("1245714587458888"); 
    final iv = IV.fromUtf8("e16ce888a20dadb8"); 

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(value, iv: iv);

    return encrypted.base64;
  }

  static String decrypt(String encrypted) {
    final key =
        Key.fromUtf8("1245714587458888"); 
    final iv =
        IV.fromUtf8("e16ce888a20dadb8"); 

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Encrypted enBase64 = Encrypted.from64(encrypted);
    final decrypted = encrypter.decrypt(enBase64, iv: iv);
    return decrypted;
  }
}
