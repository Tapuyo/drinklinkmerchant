import 'package:flutter/material.dart';

class MerchantPage extends StatefulWidget {
  const MerchantPage({Key? key}) : super(key: key);

  @override
  State<MerchantPage> createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Image.asset('assets/images/merchant_sample.png'),
      ),
    ]);
  }
}
