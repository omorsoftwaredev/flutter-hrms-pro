import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Supabase.initialize(
    url: 'https://cehyujegqldehjefzmtm.supabase.co',
    anonKey: 'sb_publishable_6VxHhIYul1CCpKmHDjbzcw_O_Z43yDf',
  );

  runApp(
    const ProviderScope(
      child: HrmsApp(),
    ),
  );
}