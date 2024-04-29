import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/utils.dart';

class LogListPage extends StatefulWidget {
  const LogListPage({super.key});

  @override
  State<LogListPage> createState() => _LogListPageState();
}

class _LogListPageState extends State<LogListPage> {
  ScrollController scrollController = ScrollController();
  String logStr = '';

  TextEditingController? textEditingController;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _loadLog();
  }

  Future _loadLog({String? path}) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String outPath = '${appDocDir.path}/log';
    File file = File(
      path != null
          ? '$outPath/$path'
          : '$outPath/.${DateTime.now().toString().replaceAll(RegExp(r'(?<=\d\d-\d\d-\d\d)[\S|\s]+'), '')}.log',
    );
    String fileName = p.basename(file.path);
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    var content = file.readAsStringSync();
    setState(() {
      logStr = content;
    });
    textEditingController = TextEditingController(text: fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff1f1f1),
      appBar: AppBar(
        backgroundColor: const Color(0xfff1f1f1),
        title: const Text(
          '日志',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (scrollController.offset ==
                  scrollController.position.maxScrollExtent) {
                scrollController.jumpTo(0);
                setState(() {});
              } else {
                scrollController
                    .jumpTo(scrollController.position.maxScrollExtent);
                setState(() {});
              }
            },
            icon: const Icon(Icons.unfold_more_rounded),
          ),
          IconButton(
            onPressed: () async {
              _loadLog().then((value) {
                KitToastUtils.toast(msg: "加载完成");
              });
            },
            icon: const Icon(Icons.sync),
          ),
          // IconButton(
          //   onPressed: () async {
          //     await AppLog.clean().then((value) {
          //       KitToastUtils.toast(msg: "清理完成");
          //     });
          //     _loadLog();
          //   },
          //   icon: const Icon(Icons.cleaning_services_outlined),
          // ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
                // height: 30,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      color: Color(0xffcccccc),
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    hintText: '日志名称',
                    fillColor: Colors.transparent,
                    filled: true,
                    isDense: true,
                    counterText: '',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value != "") {
                      _loadLog(path: value);
                    } else {
                      _loadLog();
                    }
                  },
                )),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Text(
                logStr,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
