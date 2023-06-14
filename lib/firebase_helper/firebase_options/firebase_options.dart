import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (Platform.isIOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:283466351178:ios:11f94d8546d09dc5939cb3',
        apiKey: 'AIzaSyDZMrO_9KcpEJc8yMiIL4oYEi9a5gFOzHI',
        projectId: 'e-commerce-6455a',
        messagingSenderId: '283466351178	',
        iosBundleId: 'com.example.youtubeEcommerce',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:979113894068:android:506b05b66ff7dd0ec6f7e1',
        apiKey: 'AIzaSyDT9ccLrt7zFE6CsUIiumTlBPyfDGmw5vQ',
        projectId: "e-commerce-4c0df",
        messagingSenderId: '283466351178',
      );
    }
  }
}
