import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // 设置系统UI样式
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      runApp(const MyApp());
    },
    (error, stackTrace) {
      debugPrint('runZonedGuarded: Caught error in root zone: $error, $stackTrace');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthKit 数据管理器',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // iOS风格的颜色方案
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF), // iOS蓝色
          brightness: Brightness.light,
        ),

        // 主色调
        primaryColor: const Color(0xFF007AFF),
        primarySwatch: Colors.blue,

        // 使用Material 3
        useMaterial3: true,

        // 应用栏主题
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),

        // 卡片主题
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          color: Colors.white,
        ),

        // 按钮主题
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007AFF),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),

        // 文本按钮主题
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF007AFF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),

        // 输入框主题
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF007AFF), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),

        // 标签页主题
        tabBarTheme: const TabBarThemeData(
          labelColor: Color(0xFF007AFF),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFF007AFF),
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),

        // 底部导航栏主题
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF007AFF),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // 浮动操作按钮主题
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF007AFF),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        ),

        // 对话框主题
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          elevation: 8,
        ),

        // 分割线主题
        dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 0.5),

        // 列表瓦片主题
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          tileColor: Colors.white,
        ),

        // 字体
        fontFamily: '.SF Pro Display',

        // 文本主题
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
          titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
