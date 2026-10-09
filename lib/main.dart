import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do Supabase
  await Supabase.initialize(
    url: 'https://SEU_PROJETO.supabase.co', // Substitua pelo seu URL do Supabase
    anonKey: 'SUA_CHAVE_ANONIMA_SUPABASE',   // Substitua pela sua anonKey
  );

  runApp(const TravelGoApp());
}

class TravelGoApp extends StatelessWidget {
  const TravelGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRAVEL GO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Utiliza o tema que já configurou
      home: const HomeScreen(),
    );
  }
}