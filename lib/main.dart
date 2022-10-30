import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          actionsIconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.white,
        ),
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Icon(Icons.add_box_outlined),
          ],
          title: Text('Instagram'),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.home, color: Colors.black),
                Icon(Icons.backpack, color: Colors.black),
              ],
            ),
          ),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/woogi.jpeg'),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '좋아요 100개',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'johnkim',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          '8월 7일',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
            // return ListTile(
            //   title: Column(
            //     children: [
            //       Text('좋아요 100개'),
            //       Text('johnkim'),
            //       Text('8월 7일'),
            //     ],
            //   ),
            // );
          },
        ));
  }
}
