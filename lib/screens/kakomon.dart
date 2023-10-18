import 'package:flutter/material.dart';
import 'package:flutter_app/screens/kakomon_list.dart';

class KakomonScreen extends StatefulWidget {
  const KakomonScreen({Key? key}) : super(key: key);

  @override
  State<KakomonScreen> createState() => _KakomonScreenState();
}

class _KakomonScreenState extends State<KakomonScreen> {
  List<String> weektime = [
    '火1',
    '火3',
    '金3',
    'a',
  ];
  List<String> subject = [
    '画像認識3-ABCDEF',
    '情報ネットワーク3-ABCD',
    'オペレーティングシステム3-ABCD',
    'a',
  ];
  List<int> subjectUrl = [108201, 108301, 108402, 100001];
  List<String> type = [
    '専門選択',
    '専門必修',
    '専門必修',
    'a',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          for (int i = 0; i < subject.length; i++) ...{
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return KakomonListScreen(
                        url: subjectUrl[i],
                      );
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const Offset begin = Offset(1.0, 0.0); // 右から左
                      // final Offset begin = Offset(-1.0, 0.0); // 左から右
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
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(child: Text(weektime[i])),
                  title: Text(subject[i]),
                  subtitle: Text(type[i]),
                ),
              ),
            ),
            const Divider(
              height: 0,
            ),
          }
        ],
      ),
    );
  }
}
