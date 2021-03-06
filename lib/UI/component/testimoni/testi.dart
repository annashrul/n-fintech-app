import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:n_fintech/UI/component/testimoni/testiKavling.dart';
import 'package:n_fintech/UI/component/testimoni/testiSuplemen.dart';
import 'package:n_fintech/config/user_repo.dart';

class Testimoni extends StatefulWidget {
  @override
  _TestimoniState createState() => _TestimoniState();
}

class _TestimoniState extends State<Testimoni> with SingleTickerProviderStateMixin  {
  int currentPos;
  String stateText;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  bool isLoading = false;
  final userRepository = UserRepository();
  String versionCode = '';
  bool versi = false;




  @override
  void initState() {
    print('#################### AKTIF INDEX TESTIMONI #####################');
    currentPos = 0;
    stateText = "Video not started";
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            key: scaffoldKey,
            appBar: new AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      Color(0xFF116240),
                      Color(0xFF30cc23)
                    ],
                  ),
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
              title: Text('Testimoni', style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
              bottom: TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[400],
                  indicatorWeight: 2,
                  labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white, fontFamily: 'Rubik',fontSize: 16),
                  tabs: <Widget>[
                    Tab(text: "Produk",),
                    Tab(text: "Bisnis"),
                  ]
              ),
            ),
            body: TabBarView(
                children: <Widget>[
                  TestiSuplemen(),
                  TestiKavling(),
                ]
            ),
          )
      ),
    );
  }

}
