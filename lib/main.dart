// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'dart:async';
import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flurrency/Model/currency.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer' as developer;

void main() {
  runApp(const Flurrency());
}

class Flurrency extends StatelessWidget {
  const Flurrency({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'mikhak',
          textTheme: const TextTheme(
              displayLarge: TextStyle(
                  fontFamily: 'mikhak',
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
              bodyLarge: TextStyle(
                  fontFamily: 'mikhak',
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
              displaySmall: TextStyle(
                  fontFamily: 'mikhak',
                  fontSize: 18,
                  color: Color.fromARGB(255, 14, 14, 14),
                  fontWeight: FontWeight.w700),
              bodySmall: TextStyle(
                  fontFamily: 'mikhak',
                  fontSize: 18,
                  color: Color.fromARGB(255, 211, 0, 0),
                  fontWeight: FontWeight.w700),
              displayMedium: TextStyle(
                  fontFamily: 'mikhak',
                  fontSize: 18,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.w700),
              titleLarge: TextStyle(
                  fontFamily: 'mikhak',
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.w300),
              bodyMedium: TextStyle(
                  fontFamily: 'mikhak',
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300))),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({
    super.key,
  });

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  List<Currency> currency = [];

  bool dataReceived = false;
  bool isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    isButtonEnabled = true;
    getResponse(context);
    _startCooldownTimer();
  }

  void _startCooldownTimer() {
    setState(() {
      isButtonEnabled = false;
    });

    Timer(const Duration(minutes: 1), () {
      setState(() {
        isButtonEnabled = true;
      });
    });
  }

  Future getResponse(BuildContext context) async {
    var url = "https://redlenz.ir/currency";
    developer.log("message");
    var response = await http.get(Uri.parse(url));

    if (currency.isEmpty) {
      if (response.statusCode == 200) {
        List jsonList = convert.jsonDecode(response.body);

        if (jsonList.isNotEmpty) {
          for (int i = 0; i < jsonList.length; i++) {
            setState(() {
              String persianName = convert.utf8.decode(
                  Uint8List.fromList(jsonList[i]["persian_name"].codeUnits));
              currency.add(Currency(
                id: jsonList[i]["id"],
                persianName: persianName,
                price: jsonList[i]["price"],
                changes: jsonList[i]["changes"],
                status: jsonList[i]["status"],
              ));
            });
          }
        }
      }
      if (!dataReceived) {
        _startCooldownTimer();
        dataReceived = true;
      }
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(197, 24, 24, 24),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(206, 24, 12, 32),
        actions: [
          Image.asset("assets/images/dollar.png"),
          Align(
              alignment: Alignment.center,
              child: Text(
                "قیمت لحظه ای ارز",
                style: Theme.of(context).textTheme.displayLarge,
              )),
          const Expanded(
              child: Align(
            alignment: Alignment.centerLeft,
          )),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/question.png"),
                  const SizedBox(width: 8),
                  Text(
                    "چرا Flurrency ؟",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "با توجه به تغییرات لحظه ای قیمت دلار در کشور، بد نیست که به صورت لحظه ای و در آن واحد نیز قیمت آن را در دست داشته باشیم! به همین دلیل اپ Flurrency از ساعت ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "۱۱ صبح تا ۱۱ شب",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge, // Set the color to red
                      ),
                      TextSpan(
                        text:
                            "  قیمت لحظه ای ارز های مختلف را به شما نمایش می‌دهد.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: const Color.fromARGB(255, 186, 186, 186),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "نام ارز",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            "قیمت ارز",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            "نرخ تغییر",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ]),
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height / 2.15,
                  width: double.infinity,
                  child: listFutureBuilder(context)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 34, 34, 34),
                      borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        child: TextButton.icon(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 51, 35, 62)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)))),
                            onPressed: () {
                              if (isButtonEnabled) {
                                currency.clear();
                                _showLoadingSnackBar(context);
                                listFutureBuilder(context);
                                _show_snack_bar(context,
                                    "اطلاعت با موفقیت به‌روز رسانی شد !", true);
                                _startCooldownTimer();
                              } else {
                                _show_snack_bar(
                                    context,
                                    "لطفاً ۱ دقیقه تا درخواست بعدی صبر کنید !",
                                    false);
                              }
                            },
                            icon: const Icon(
                              CupertinoIcons.refresh,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            label: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Text("به‌روز رسانی",
                                  style: Theme.of(context).textTheme.bodyLarge),
                            )),
                      ),
                      Text("آخرین به‌روز رسانی  ${getCurrentPersianTime()}"),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: currency.length,
                itemBuilder: (BuildContext context, int position) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 15, 4, 0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                blurRadius: 5,
                                color: Color.fromARGB(255, 166, 99, 195))
                          ],
                          color: const Color.fromARGB(255, 21, 21, 21),
                          borderRadius: BorderRadius.circular(100)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              currency[position].persianName!,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            Text(
                              getPersianNumber(
                                  currency[position].price.toString()),
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            Text(
                              getPersianNumber(
                                  currency[position].changes.toString()),
                              style: currency[position].status == "pos"
                                  ? Theme.of(context).textTheme.displayMedium
                                  : Theme.of(context).textTheme.bodySmall,
                            ),
                          ]),
                    ),
                  );
                })
            : const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 145, 36, 143),
                ),
              );
      },
      future: getResponse(context),
    );
  }
}

String getCurrentPersianTime() {
  String currentTime = _get_time();
  String persianTime = getPersianNumber(currentTime);
  return persianTime;
}

// ignore: non_constant_identifier_names
String _get_time() {
  DateTime now = DateTime.now();
  return DateFormat("kk:mm:ss").format(now);
}

void _show_snack_bar(BuildContext context, String msg, isGreen) {
  if (isGreen) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: Theme.of(context).textTheme.displayLarge,
      ),
      backgroundColor: const Color.fromARGB(255, 56, 138, 37),
      duration: const Duration(seconds: 2),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: Theme.of(context).textTheme.displayLarge,
      ),
      backgroundColor: const Color.fromARGB(255, 138, 37, 37),
      duration: const Duration(seconds: 2),
    ));
  }
}

void _showLoadingSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 16),
          Text(
            "در حال به‌روز رسانی...",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 2),
    ),
  );
}

String getPersianNumber(String number) {
  const eng = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  const per = ["۰", "۱", "۲", "۳", "۴", "۵", "۶", "۷", "۸", "۹"];

  for (var element in eng) {
    number = number.replaceAll(element, per[eng.indexOf(element)]);
  }
  return number;
}
