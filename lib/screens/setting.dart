import 'package:flutter/material.dart';
import 'package:flutter_app/components/setting_user_info.dart';
import 'package:flutter/services.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final url = Uri.parse('https://dotto.web.app/');

  TextEditingController _userKeyController = TextEditingController();

  // 2つのプルダウンの初期値を設定
  String dropdownValue1 = 'なし';
  String dropdownValue2 = 'なし';

  @override
  void dispose() {
    _userKeyController.dispose(); // リソースの解放
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "学年:",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: dropdownValue1,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue1 = newValue!;
                          });
                        },
                        items: <String>['なし', '1年', '2年', '3年', '4年']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "コース:",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: dropdownValue2,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue2 = newValue!;
                          });
                        },
                        items: <String>[
                          'なし',
                          '情報システム',
                          '情報デザイン',
                          '知能',
                          '複雑',
                          '高度ICT'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(right: 15, left: 15),
                    child: TextField(
                      controller: _userKeyController,
                      // 入力数
                      maxLength: 16,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '課題のユーザーキー',
                        hintText: '半角英数字16桁',
                      ),
                      inputFormatters: [
                        // 最大16文字まで入力可能
                        LengthLimitingTextInputFormatter(16),
                        // 半角英数字のみ許可
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]'),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        _saveSettings(() => FocusScope.of(context).unfocus()),
                    child: const Text("設定保存"),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "ユーザーキーを設定する方法は下記リンクから（PCで開くこと推奨）",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SelectableText(
                    "https://dotto.web.app/",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 設定保存処理
  void _saveSettings(void Function() onFunction) async {
    onFunction();
    await UserPreferences.setString(UserPreferenceKeys.grade, dropdownValue1);
    await UserPreferences.setString(UserPreferenceKeys.course, dropdownValue2);
    try {
      if (_userKeyController.text.isNotEmpty) {
        await UserPreferences.setUserKey(_userKeyController.text);
      }
      _saveMessage();
    } catch (e) {
      _failuredMessage();
    }
  }

  void _failuredMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ユーザーキーが不正です。')),
    );
  }

  void _saveMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('設定が保存されました。')),
    );
  }

//保存設定を確認する処理
  void _checkSettings() async {
    final String? grade =
        await UserPreferences.getString(UserPreferenceKeys.grade);
    final String? course =
        await UserPreferences.getString(UserPreferenceKeys.course);
    final String? userKey =
        await UserPreferences.getString(UserPreferenceKeys.userKey);

    setState(() {
      _userKeyController = TextEditingController(text: userKey);
      dropdownValue1 = grade ?? 'なし';
      dropdownValue2 = course ?? 'なし';
    });
  }
}
