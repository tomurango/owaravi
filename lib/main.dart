import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/providers/auth_provider.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/login_screen.dart';

void main() async{
  // バインディングの初期化
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: AuthWrapper(),
      ),
    );
  }
}

// ユーザーの認証状態によって画面を切り替える
class AuthWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // ユーザーがログインしていない場合はログイン画面を表示
          return LoginScreen();
        } else {
          // ログインしている場合はホーム画面を表示
          return HomeScreen();
        }
      },
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(body: Center(child: Text('エラーが発生しました'))),
    );
  }
}
