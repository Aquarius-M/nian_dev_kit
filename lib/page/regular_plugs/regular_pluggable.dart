import 'package:nian_dev_kit/core/pluggable.dart';
import 'package:flutter/material.dart';

import 'icon.dart' as icon;

class RegularPluggable extends StatefulWidget implements Pluggable {
  const RegularPluggable({super.key});

  @override
  State<RegularPluggable> createState() => _RegularPluggableState();

  @override
  Widget? buildWidget(BuildContext? context) => this;

  @override
  String get name => '正则';

  @override
  String get displayName => '正则';

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);

  @override
  int get index => 9;

  @override
  void onTrigger() {}
}

class _RegularPluggableState extends State<RegularPluggable> {
  TextEditingController? regularEditingController = TextEditingController();
  TextEditingController? contentEditingController = TextEditingController();

  String inputRegular = "";
  String inputContent = "";

  String regularResult = "";

  bool multiLine = false;
  bool caseSensitive = true;
  bool unicode = false;
  bool dotAll = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          '正则',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: multiLine,
                        onChanged: (value) {
                          multiLine = value!;
                          setState(() {});
                        },
                      ),
                      const Text("多行")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: caseSensitive,
                        onChanged: (value) {
                          caseSensitive = value!;
                          setState(() {});
                        },
                      ),
                      const Text("区分大小写")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: unicode,
                        onChanged: (value) {
                          unicode = value!;
                          setState(() {});
                        },
                      ),
                      const Text("unicode")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: dotAll,
                        onChanged: (value) {
                          dotAll = value!;
                          setState(() {});
                        },
                      ),
                      const Text("匹配所有字符")
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 4),
              child: Text(
                "正则表达式：",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            TextFormField(
              controller: regularEditingController,
              minLines: 3,
              maxLines: 3,
              scrollPadding: const EdgeInsets.all(5),
              style: const TextStyle(
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onChanged: (value) {
                inputRegular = value;
                setState(() {});
                regular();
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 4),
              child: Text(
                "内容：",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            TextFormField(
              controller: contentEditingController,
              minLines: 4,
              maxLines: 4,
              style: const TextStyle(
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onChanged: (value) {
                inputContent = value;
                setState(() {});
                regular();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "匹配结果：",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  if (regularResult != "")
                    InkWell(
                      onTap: () {
                        regularResult = "";
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.clear_rounded,
                        size: 22,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black26,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    regularResult,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Align(
                child: GestureDetector(
                  onTap: () {
                    regular();
                  },
                  child: Container(
                    width: 156,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: Colors.blueAccent,
                    ),
                    child: const Align(
                      child: Text(
                        "验 证",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void regular() {
    if (inputRegular != "" && inputContent != "") {
      String regExp = inputRegular;
      var matches = RegExp(
        regExp,
        multiLine: multiLine,
        caseSensitive: caseSensitive,
        unicode: unicode,
        dotAll: dotAll,
      ).allMatches(inputContent);
      if (matches.isNotEmpty) {
        regularResult = "";
        for (final Match m in matches) {
          String match = m[0]!;
          if (regularResult != "") {
            regularResult = "$regularResult\n$match";
          } else {
            regularResult = match;
          }
        }
      } else {
        regularResult = "";
      }
      setState(() {});
    }
  }
}
