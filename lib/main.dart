import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './src/app.dart';
import './src/providers/ideas.dart';
import './src/providers/notes.dart';
import './src/providers/auth.dart';
import './src/providers/criteria.dart';

import './src/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
        ChangeNotifierProvider<Ideas>(create: (_) => Ideas()),
        ChangeNotifierProvider<Notes>(create: (_) => Notes()),
        ChangeNotifierProvider<Criteria>(create: (_) => Criteria()),
      ],
      child: MyApp(),
    ),
  );
}
