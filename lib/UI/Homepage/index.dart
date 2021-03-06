

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:n_fintech/UI/Homepage/beranda.dart';
import 'package:n_fintech/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:n_fintech/UI/component/History/detailHistoryPPOB.dart';
import 'package:n_fintech/UI/component/about.dart';
import 'package:n_fintech/UI/component/sosmed/detailSosmed.dart';
import 'package:n_fintech/UI/component/myProfile.dart';
import 'package:n_fintech/UI/component/testimoni/testi.dart';
import 'package:n_fintech/UI/detail_berita_ui.dart';
import 'package:n_fintech/UI/history_ui.dart';
import 'package:n_fintech/UI/jaringan_ui.dart';
import 'package:n_fintech/UI/loginPhone.dart';
import 'package:n_fintech/UI/produk_mlm_ui.dart';
import 'package:n_fintech/UI/profile_ui.dart';
import 'package:n_fintech/config/api.dart';
import 'package:n_fintech/config/user_repo.dart';
import 'package:n_fintech/resources/gagalHitProvider.dart';
import 'package:url_launcher/url_launcher.dart';



class DashboardThreePage extends StatefulWidget {
  final String param;
  DashboardThreePage({this.param});
  @override
  _DashboardThreePageState createState() => _DashboardThreePageState();
}

class _DashboardThreePageState extends State<DashboardThreePage> {

  final TextStyle whiteText = TextStyle(color: Colors.white);
  final userRepository = UserRepository();
  SharedPreferences preferences;
  String id="", kdReferral='';
  bool showAlignmentCards = false;
  bool isLoading = false;
  bool isLoading2 = false;
  Future<Null> blockedMember() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('cek', true);
    prefs.setString('id', null);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
  }
  Location location = Location();
  static String latitude = '';
  static String longitude = '';
  Future updateApk() async{
    String url = 'https://play.google.com/store/apps/details?id=com.thaibah';
    if (await canLaunch(url)) {
      await launch(url);
    }else{
      print(url);
    }
  }
  Future play() async{
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play('https://thaibah.com/assets/adzan_.mp3');
  }

  @override
  void dispose() {
    indexcontroller.close();
    super.dispose();

  }
  PageController pageController = PageController(initialPage: 0);
  StreamController<int> indexcontroller = StreamController<int>.broadcast();
  int index = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const snackBarDuration = Duration(seconds: 3);

  final snackBar = SnackBar(
    content: Text('Tekan Kembali Untuk Keluar',style:TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
    duration: snackBarDuration,
  );

  DateTime backButtonPressTime;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null || currentTime.difference(backButtonPressTime) > snackBarDuration;
    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = currentTime;
      scaffoldKey.currentState.showSnackBar(snackBar);
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPin', true);
//    var cek = prefs.setBool('isPin', true);
    print("################################# KALUAR APLIKASI ${prefs.getBool('isPin')} ##############################");
    return true;
  }

  bool modeUpdate = false;

  Future checkModeUpdate() async{
    final prefs = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if(prefs.get('pin') == null || prefs.get('pin') == '') {
      print('pin kosong');
      setState(() {
        modeUpdate = true;
      });
      GagalHitProvider().fetchRequest('index','kondisi = pin kosong, brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');
    }
  }
  // Our first view
  @override
  void initState() {
    checkModeUpdate();
    cekPath();
    location.onLocationChanged().listen((value) {
      if(mounted){
        setState(() {
          latitude = value.latitude.toString();
          longitude = value.longitude.toString();
        });
      }
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    isLoading = true;
    isLoading2 = true;

    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    OneSignal.shared.init("6a4c55fd-d96d-427f-8634-d2c4b9d96d69", iOSSettings: settings);
    OneSignal.shared.setNotificationOpenedHandler((notification) {
      var notify = notification.notification.payload.additionalData;
      print("################################################################################");
      print(notify);
      print("################################################################################");
      if (notify["type"] == "berita") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailBeritaUI(id: notify['id'],category: notify['category'])));
      }
      if (notify["type"] == "transaksi_bonus") {
        Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
      }
      if (notify["type"] == "transaksi_suplemen") {
        Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
      }
      if (notify["type"] == "transaksi_tanah") {
        Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
      }
      if (notify["type"] == "transaksi_ppob") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailHistoryPPOB(kdTrx: notify['id']),
          ),
        );
      }
      if (notify["type"] == "feed_komentar") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailSosmed(id: notify['id']),
          ),
        );
      }
      if (notify["type"] == "UPDATE_APK") {
        updateApk();
      }
      if (notify["type"] == "transaksi_saldo") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryUI(page: 'home')));
      }
      if (notify["type"] == "member") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral)));
      }
      if (notify["type"] == "blocked_member") {
        blockedMember();
      }
      if(notify['type'] == 'adzan'){
        play();
      }

    });


  }

  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    Beranda(lat: latitude,lng: longitude),
    ProdukMlmUI(),
    About(),
    Testimoni(),
    ProfileUI(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen =  Beranda();

  void cekPath(){
    if(widget.param == 'beranda' || widget.param == ''){
      setState(() {
        currentTab = 0;
        currentScreen = Beranda(lat: latitude,lng: longitude);
      });
    }
    if(widget.param == 'produk'){
      setState(() {
        currentTab = 1;
        currentScreen = ProdukMlmUI();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return modeUpdate == true ? modeUpdateBuild() : latitude == null || longitude == null ? CircularProgressIndicator() :Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
      ),
//      floatingActionButton: _buildFab(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: currentTab == 2 ? Colors.green : Colors.white,
        child: SvgPicture.asset(
          ApiService().assetsLocal+"t.svg",
          height: ScreenUtilQ.getInstance().setHeight(50),
          width: ScreenUtilQ.getInstance().setWidth(50),
          color: currentTab == 2 ? Colors.white : Colors.green,
        ),
        onPressed: () {
          setState(() {
            currentScreen = About();// if user taps on this dashboard tab will be active
            currentTab = 2;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Beranda(lat: latitude,lng: longitude); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        currentTab == 0 ? SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Home_Warna.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        ) : SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Home_Abu.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = ProdukMlmUI(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        currentTab == 1 ? SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Produk_Warna.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        ) : SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Produk_abu.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        )
                      ],
                    ),
                  )
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Testimoni(); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        currentTab == 3 ? SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Testimoni_Warna.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        ) : SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Testimoni_Abu.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = MyProfile(); // if user taps on this dashboard tab will be active
                        currentTab = 4;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        currentTab == 4 ? SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Profile_Warna.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        ) : SvgPicture.asset(
                          ApiService().assetsLocal+"Icon_Utama_Profile_abu.svg",
                          height: ScreenUtilQ.getInstance().setHeight(50),
                          width: ScreenUtilQ.getInstance().setWidth(50),
                        )
                      ],
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      ),
//      body: UpdatePage(),
//      body: Container(
//        color: const Color(0xffF4F7FA),
//        child: WillPopScope(
//          onWillPop: onWillPop,
//          child: PageView(
//            physics: NeverScrollableScrollPhysics(),
//            onPageChanged: (index) {
//              indexcontroller.add(index);
//            },
//            controller: pageController,
//            children: <Widget>[
//              Beranda(lat:latitude,lng:longitude),
//              ProdukMlmUI(),
//              About(),
//              Testimoni(),
//              ProfileUI(),
//            ],
//          ),
//        ),
//      ),
//
//      bottomNavigationBar: StreamBuilder<Object>(
//          initialData: 0,
//          stream: indexcontroller.stream,
//          builder: (context, snapshot) {
//            int cIndex = snapshot.data;
//            return FancyBottomNavigation(
//              currentIndex: cIndex,
//              items: <FancyBottomNavigationItem>[
//                FancyBottomNavigationItem(icon: Icon(Icons.home), title: Text('Home',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),),
//                FancyBottomNavigationItem(icon: Icon(Icons.shopping_basket), title: Text('Produk',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'))),
//                FancyBottomNavigationItem(icon: Icon(Icons.account_balance), title: Text('Tentang',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'))),
//                FancyBottomNavigationItem(icon: Icon(Icons.videocam), title: Text('Testimoni',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),),
//                FancyBottomNavigationItem(icon: Icon(Icons.account_circle), title: Text('Profile',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik'))),
//              ],
//              onItemSelected: (int value) {
//                indexcontroller.add(value);
//                Future.delayed(Duration(milliseconds: 100), () {
//                  pageController.jumpToPage(value);
//                });
////              pageController.jumpToPage(value);
//              },
//            );
//          }
//      ),
//        bottomNavigationBar: CurvedNavigationBarQ(
//          key: _bottomNavigationKey,
//          index: 0,
//          height: 50.0,
//          items: <Widget>[
//            Icon(Icons.home, size: 30,color:Colors.white),
//            Icon(Icons.shopping_basket, size: 30,color:Colors.white),
//            Icon(Icons.account_balance, size: 30,color:Colors.white),
//            Icon(Icons.videocam, size: 30,color:Colors.white),
//            Icon(Icons.account_circle, size: 30,color:Colors.white),
//          ],
//          color: Color(0xFF30cc23),
//          buttonBackgroundColor: Color(0xFF30cc23),
//          backgroundColor: Colors.white,
//          animationCurve: Curves.easeInOut,
//          animationDuration: Duration(milliseconds: 600),
//          onTap: (index) {
//            setState(() {
//              _page = index;
//            });
//          },
//        ),
//        body: WillPopScope(
//            child: moves(_page),
//            onWillPop: onWillPop
//        )
    );
  }
  Widget modeUpdateBuild(){
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        padding:EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(100, 100), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.green, // button color
                    child: InkWell(
                      splashColor: Colors.green, // splash color
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.clear();
                        prefs.commit();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.power_settings_new,color: Colors.white,), // icon
                          Text("Keluar",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold)), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Text("anda baru saja mengupgdate aplikasi thaibah.",textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
              Text("tekan tombol keluar untuk melanjutkan proses pemakaian aplikasi thaibah",textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
            ],
          ),
        ),
      ),
    );
  }
}


class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const snackBarDuration = Duration(seconds: 3);

  final snackBar = SnackBar(
    content: Text('Tekan Kembali Untuk Keluar',style:TextStyle(fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
    duration: snackBarDuration,
  );

  DateTime backButtonPressTime;


  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null || currentTime.difference(backButtonPressTime) > snackBarDuration;
    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = currentTime;
      scaffoldKey.currentState.showSnackBar(snackBar);
      return false;
    }

    return true;
  }
  Future updateApk() async{
    String url = 'https://play.google.com/store/apps/details?id=com.thaibah';
    if (await canLaunch(url)) {
      await launch(url);
    }else{
      print(url);
    }
  }
  Future cekStatusLogin()async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString('id') == null || prefs.getString('id') == ''){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cekStatusLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: WillPopScope(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Image.asset("assets/images/warning.png",width: 100.0),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Center(
                      child: Text("Silahkan Perbaharui Aplikasi Anda Ke Versi ${ApiService().versionCode} !!".toUpperCase(), textAlign: TextAlign.center, style:TextStyle(color:Colors.red,fontSize:14.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Center(
                      child: Text("Tekan Tombol Dibawah Ini Untuk Memperbaharui Aplikasi ...".toUpperCase(),  textAlign: TextAlign.center,style:TextStyle(color:Colors.red,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Center(
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.green)
                        ),
                        color: Colors.white,
                        textColor: Colors.green,
                        padding: EdgeInsets.all(20.0),
                        onPressed: () {
                          updateApk();
                        },
                        child: Text(
                          "Perbaharui Aplikasi Sekarang".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          onWillPop: onWillPop
      ),
    );
  }
}

//
//class FancyBottomNavigation extends StatefulWidget {
//  final int currentIndex;
//  final double iconSize;
//  final Color activeColor;
//  final Color inactiveColor;
//  final Color backgroundColor;
//  final List<FancyBottomNavigationItem> items;
//  final ValueChanged<int> onItemSelected;
//
//  FancyBottomNavigation(
//      {Key key,
//        this.currentIndex = 0,
//        this.iconSize = 24,
//        this.activeColor,
//        this.inactiveColor,
//        this.backgroundColor,
//        @required this.items,
//        @required this.onItemSelected}) {
//    assert(items != null);
//    assert(onItemSelected != null);
//  }
//
//  @override
//  _FancyBottomNavigationState createState() {
//    return _FancyBottomNavigationState(
//        items: items,
//        backgroundColor: backgroundColor,
//        currentIndex: currentIndex,
//        iconSize: iconSize,
//        activeColor: activeColor,
//        inactiveColor: inactiveColor,
//        onItemSelected: onItemSelected);
//  }
//}
//
//class _FancyBottomNavigationState extends State<FancyBottomNavigation> {
//  final int currentIndex;
//  final double iconSize;
//  Color activeColor;
//  Color inactiveColor;
//  Color backgroundColor;
//  List<FancyBottomNavigationItem> items;
//  int _selectedIndex;
//  ValueChanged<int> onItemSelected;
//
//  _FancyBottomNavigationState(
//      {@required this.items,
//        this.currentIndex,
//        this.activeColor,
//        this.inactiveColor = Colors.black,
//        this.backgroundColor,
//        this.iconSize,
//        @required this.onItemSelected}) {
//    _selectedIndex = currentIndex;
//  }
//
//  Widget _buildItem(FancyBottomNavigationItem item, bool isSelected) {
//    return AnimatedContainer(
//      width: isSelected ? 100 : 50,
//      height: double.maxFinite,
//      duration: Duration(milliseconds: 250),
//      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
//      decoration: !isSelected
//          ? null
//          : BoxDecoration(
//        color: activeColor,
//        borderRadius: BorderRadius.all(Radius.circular(50)),
//      ),
//      child: ListView(
//        shrinkWrap: true,
//        padding: EdgeInsets.all(0),
//        physics: NeverScrollableScrollPhysics(),
//        scrollDirection: Axis.horizontal,
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(right: 8),
//                child: IconTheme(
//                  data: IconThemeData(
//                      size: iconSize,
//                      color: isSelected ? backgroundColor : inactiveColor),
//                  child: item.icon,
//                ),
//              ),
//              isSelected
//                  ? DefaultTextStyle.merge(
//                style: TextStyle(color: backgroundColor),
//                child: item.title,
//              )
//                  : SizedBox.shrink()
//            ],
//          )
//        ],
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    activeColor = (activeColor == null) ? Theme.of(context).accentColor : activeColor;
//    backgroundColor = (backgroundColor == null) ? Theme.of(context).bottomAppBarColor : backgroundColor;
//    return Container(
//      width: MediaQuery.of(context).size.width/2,
//      height: 56,
//      padding: EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
//      decoration: BoxDecoration(
//          color: backgroundColor,
//          boxShadow: [BoxShadow(color: Colors.green, blurRadius: 2)]),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: items.map((item) {
//          var index = items.indexOf(item);
//          return GestureDetector(
//            onTap: () {
//              onItemSelected(index);
//              setState(() {
//                _selectedIndex = index;
//              });
//            },
//            child: _buildItem(item, _selectedIndex == index),
//          );
//        }).toList(),
//      ),
//    );
//  }
//}
//
//class FancyBottomNavigationItem {
//  final Widget icon;
//  final Text title;
//
//  FancyBottomNavigationItem({
//    @required this.icon,
//    @required this.title,
//  }) {
//    assert(icon != null);
//    assert(title != null);
//  }
//}



class FabWithIcons extends StatefulWidget {
  FabWithIcons({this.icons, this.onIconTapped});
  final List<IconData> icons;
  ValueChanged<int> onIconTapped;
  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.icons.length, (int index) {
        return _buildChild(index);
      }).toList()..add(
        _buildFab(),
      ),
    );
  }

  Widget _buildChild(int index) {
    Color backgroundColor = Colors.white;
    Color foregroundColor = Theme.of(context).accentColor;
    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(
              0.0,
              1.0 - index / widget.icons.length / 2.0,
              curve: Curves.easeOut
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: backgroundColor,
          child:SvgPicture.asset(
            ApiService().assetsLocal+"t.svg",
            height: ScreenUtilQ.getInstance().setHeight(50),
            width: ScreenUtilQ.getInstance().setWidth(50),
            color: Colors.green,
          ),
//          child: Icon(widget.icons[index], color: foregroundColor),
          onPressed: () => _onTapped(index),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      tooltip: 'Thaibah',
      child: SvgPicture.asset(
        ApiService().assetsLocal+"t.svg",
        height: ScreenUtilQ.getInstance().setHeight(50),
        width: ScreenUtilQ.getInstance().setWidth(50),
        color: Colors.green,
      ),
      elevation: 2.0,
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}



class AnchoredOverlay extends StatelessWidget {
  final bool showOverlay;
  final Widget Function(BuildContext, Offset anchor) overlayBuilder;
  final Widget child;

  AnchoredOverlay({
    this.showOverlay,
    this.overlayBuilder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return new OverlayBuilder(
          showOverlay: showOverlay,
          overlayBuilder: (BuildContext overlayContext) {
            RenderBox box = context.findRenderObject() as RenderBox;
            final center = box.size.center(box.localToGlobal(const Offset(0.0, 0.0)));

            return overlayBuilder(overlayContext, center);
          },
          child: child,
        );
      }),
    );
  }
}

class OverlayBuilder extends StatefulWidget {
  final bool showOverlay;
  final Function(BuildContext) overlayBuilder;
  final Widget child;

  OverlayBuilder({
    this.showOverlay = false,
    this.overlayBuilder,
    this.child,
  });

  @override
  _OverlayBuilderState createState() => new _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }

    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    overlayEntry = new OverlayEntry(
      builder: widget.overlayBuilder,
    );
    addToOverlay(overlayEntry);
  }

  void addToOverlay(OverlayEntry entry) async {
    print('addToOverlay');
    Overlay.of(context).insert(entry);
  }

  void hideOverlay() {
    print('hideOverlay');
    overlayEntry.remove();
    overlayEntry = null;
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CenterAbout extends StatelessWidget {
  final Offset position;
  final Widget child;

  CenterAbout({
    this.position,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: position.dy,
      left: position.dx,
      child: new FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}
