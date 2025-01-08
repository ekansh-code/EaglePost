import 'package:eagle_post/features/record_list/page_home.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://uspdbyyrsckaagegolrv.supabase.co/',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVzcGRieXlyc2NrYWFnZWdvbHJ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYzMDgyNDgsImV4cCI6MjA1MTg4NDI0OH0.HsudvDWngU-tgjBbhbRIKcXkGh29yDlaX2zxc8TIAig',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Pagination',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}
