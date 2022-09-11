import 'package:files/widgets/context_menu/context_menu_theme.dart';
import 'package:files/widgets/home.dart';
import 'package:flutter/material.dart';

class FilesApp extends StatelessWidget {
  const FilesApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Files',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepOrange,
          secondary: Colors.deepOrange,
          background: Color(0xFF161616),
          surface: Color(0xFF212121),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onError: Colors.white,
        ),
        scrollbarTheme: ScrollbarThemeData(
          trackBorderColor: MaterialStateProperty.all(Colors.transparent),
          crossAxisMargin: 0,
          mainAxisMargin: 0,
          radius: Radius.zero,
        ),
        extensions: [
          ContextMenuTheme(),
        ],
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),
      debugShowCheckedModeBanner: false,
      home: const FilesHome(),
    );
  }
}
