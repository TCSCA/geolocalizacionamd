import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageController {
  final storage = const FlutterSecureStorage();

  Future writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future readSecureData(String key) async {
    String? readValue = await storage.read(key: key);
    readValue ??= '';
    return readValue;
  }

  Future deleteSecureData(String key) async {
    await storage.delete(key: key);
  }

  IOSOptions getIOSOptions() => const IOSOptions(
        accountName: '',
      );

  AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'Test2',
        // preferencesKeyPrefix: 'Test'
      );
}
