import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './notification.dart' as notification;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './shop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => Store()),
        ChangeNotifierProvider(create: (c) => Store2()),
      ],
      child: MaterialApp(
        theme: style.theme,
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var list = [];
  var userImage;
  var userContent;

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    var map = {'age': 20};
    storage.setString('map', jsonEncode(map));
    var result = storage.getString('map') ?? 'NO';
    print(jsonDecode(result));
  }

  addMyData() {
    var myData = {
      'id': list.length,
      'image': userImage,
      'likes': 5,
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };

    print(myData);
    setState(() {
      list.insert(0, myData);
    });
  }

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));

    setState(() {
      list = jsonDecode(result.body);
    });
  }

  addData(a) {
    print(a);
    setState(() {
      list.add(a);
    });
  }

  setUserContent(a) {
    setState(() {
      userContent = a;
    });
  }

  @override
  void initState() {
    super.initState();
    saveData();
    getData();
    notification.initNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('hihi'),
        onPressed: () {
          notification.showNotification2();
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  userImage = File(image.path);
                });
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => Upload(
                        userImage: userImage,
                        setUserContent: setUserContent,
                        addMyData: addMyData)),
              );
            },
            icon: Icon(Icons.add_box_outlined),
            iconSize: 30,
          )
        ],
        title: Text('Instagram'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Colors.black),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined, color: Colors.black),
            label: '샵',
          ),
        ],
        onTap: (int tabNumber) {
          setState(() {
            tab = tabNumber;
          });
        },
      ),
      body: [CustomListView(data: list, addData: addData), Shop()][tab],
    );
  }
}

class CustomListView extends StatefulWidget {
  const CustomListView({Key? key, this.data, this.addData}) : super(key: key);
  final data;
  final addData;

  @override
  State<CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  var scroll = ScrollController();

  getMore() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);

    widget.addData(result2);
  }

  @override
  void initState() {
    super.initState();

    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.data.isNotEmpty) {
      return Container();
    } else {
      return ListView.builder(
        controller: scroll,
        itemCount: widget.data.length,
        itemBuilder: (BuildContext listViewContet, int idx) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.data[idx]['image'].runtimeType == String
                  ? Image.network(widget.data[idx]['image'])
                  : Image.file(widget.data[idx]['image']),
              GestureDetector(
                child: Text(widget.data[idx]['user']),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (e, a1, a2) => Profile(),
                      transitionsBuilder: (c, a1, a2, child) => SlideTransition(
                        position: Tween(
                          begin: Offset(1.0, 0.0),
                          end: Offset(0.0, 0.0),
                        ).animate(a1),
                        child: child,
                      ),
                    ),
                    // CupertinoPageRoute(builder: (c) => Profile()),
                  );
                },
              ),
              Text('좋아요 ${widget.data[idx]['likes'].toString()}'),
              Text(widget.data[idx]['date']),
              Text(widget.data[idx]['content']),
            ],
          );
        },
      );
    }
  }
}

class Store extends ChangeNotifier {
  var name = 'john park';
  var follower = 0;
  var followed = false;

  var profileImage = [];

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    print(result2);
    notifyListeners();
  }

  changeFollow() {
    if (followed) {
      follower -= 1;
    } else {
      follower += 1;
    }

    followed = !followed;
    notifyListeners();
  }
}

class Store2 extends ChangeNotifier {
  var name = 'john kim';
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store2>().name)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (c, i) => Image.network(context.watch<Store>().profileImage[i]),
              childCount: context.watch<Store>().profileImage.length,
            ),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          )
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        Text('팔로우 ${context.watch<Store>().follower}명'),
        ElevatedButton(
          onPressed: () {
            context.read<Store>().changeFollow();
          },
          child: Text('팔로우'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<Store>().getData();
          },
          child: Text('사진 가져오기'),
        )
      ],
    );
  }
}

class Upload extends StatefulWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData})
      : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                widget.addMyData();
              },
              icon: Icon(Icons.exposure_plus_1_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(widget.userImage),
            TextField(
              onChanged: (String text) {
                widget.setUserContent(text);
              },
            ),
            Text('이미지업로드화면222'),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)),
          ],
        ),
      ),
    );
  }
}
