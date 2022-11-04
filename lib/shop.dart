import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  void getData() async {
    try {
      var result = await firestore.collection('product').get();
      if (result.docs.isNotEmpty) {
        for (var doc in result.docs) {
          print(doc['name']);
        }
      } else {
        print('에러 발생');
      }

      // var result2 = await firestore
      //     .collection('product')
      //     .add({'name': '내복', 'price': 50000});
      // print(result2);

      // var result3 = await firestore.collection('product').where({}).get();
      // var result4 = await firestore.collection('product').delete();
      // var result5 = await firestore.collection('product').doc('').update({'name' : 'add'});
    } catch (err) {
      print('Catch : ${err}');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Text('샵');
  }
}
