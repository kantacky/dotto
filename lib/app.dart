import 'package:flutter/material.dart';
import 'package:flutter_app/repository/find_rooms_in_use.dart';
import 'package:flutter_app/repository/read_schedule_file.dart';
import 'package:flutter_app/screens/kamoku.dart';

import 'screens/home.dart';
import 'screens/map.dart';
import 'screens/kakomon.dart';
import 'components/color_fun.dart';
import 'screens/setting.dart';

import 'repository/get_room_from_firebase.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project 03 Group C',
      theme: ThemeData(
        primarySwatch: customFunColor,
      ),
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const _screens = [
    HomeScreen(),
    MapScreen(),
    KakomonScreen(),
    //KamokuScreen(),
    kamokusortScreen()
  ];

  @override
  void initState() {
    super.initState();
    // アプリ起動時に一度だけ実行される
    // initState内で非同期処理を行うための方法
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Firebaseからファイルをダウンロード
      await downloadFileFromFirebase();

      // ダウンロードしたファイルの中身を読み取る
      try {
        String fileContent = await readScheduleFile();
        List<String> resourceIds = findRoomsInUse(fileContent);

        if (resourceIds.isNotEmpty) {
          for (String resourceId in resourceIds) {
            print("ResourceId: $resourceId");
            // ここで取得したresourceIdをつかえるとおもう
          }
        } else {
          print("No ResourceId exists for the current time.");
        }
      } catch (e) {
        print(e);
      }
    });
  }

  int _selectedIndex = 0;
  String appBarTitle = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(appBarTitle)),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const SettingScreen();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const Offset begin = Offset(0.0, 1.0);
                      const Offset end = Offset.zero;
                      final Animatable<Offset> tween =
                          Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: Curves.easeInOut));
                      final Animation<Offset> offsetAnimation =
                          animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'ホーム'),
            BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined), label: 'マップ'),
            BottomNavigationBarItem(
                icon: Icon(Icons.folder_copy_outlined), label: '過去問'),
            //BottomNavigationBarItem(icon: Icon(Icons.book), label: '授業'),
            //以下を追加
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'ソート'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
