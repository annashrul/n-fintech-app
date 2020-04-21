import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:n_fintech/UI/server_form.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:n_fintech/Model/onboardingModel.dart';
import 'package:n_fintech/Model/pageViewModel.dart';
import 'package:n_fintech/Model/user_location.dart';
import 'package:n_fintech/UI/Homepage/index.dart';
import 'package:n_fintech/UI/loginPhone.dart';
import 'package:n_fintech/UI/splash/introViews.dart';
import 'package:n_fintech/config/api.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:n_fintech/config/user_repo.dart';
import 'package:n_fintech/resources/location_service.dart';
import 'package:connectivity/connectivity.dart';
import 'UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'UI/Widgets/responsive_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getString('id');
  var pin = prefs.getString('pin');
  var token = prefs.getString('token');
  var cek = prefs.getBool('cek');
  print(id);
  print(cek);
  print(pin);
  print(token);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
//      home: id == null ? LoginPhone() : MyApp()
      home: cek == false ? Splash() : (id == null || pin == null || token == null ? Splash() :  MyApp())
    )
  );
//  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp>  {
  bool isLoading = false;
  SharedPreferences preferences;
  String id="";
   Future checkLoginStatus() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
      id = preferences.getString("id");
    });
  }
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final userRepository = UserRepository();



  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    isLoading = true;
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//    Timer.periodic(Duration(seconds:ApiService().timerActivity), (Timer t){
//      chekcer();
//    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }


  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiBSSID, wifiIP;

        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
            await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status = await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiName = await _connectivity.getWifiName();
            } else {
              wifiName = await _connectivity.getWifiName();
            }
          } else {
            wifiName = await _connectivity.getWifiName();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiName = "Failed to get Wifi Name";
        }

        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
            await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
              await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiBSSID = await _connectivity.getWifiBSSID();
            } else {
              wifiBSSID = await _connectivity.getWifiBSSID();
            }
          } else {
            wifiBSSID = await _connectivity.getWifiBSSID();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiBSSID = "Failed to get Wifi BSSID";
        }

        try {
          wifiIP = await _connectivity.getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiIP = "Failed to get Wifi IP";
        }

        setState(() {
          _connectionStatus = '$result\n'
              'Wifi Name: $wifiName\n'
              'Wifi BSSID: $wifiBSSID\n'
              'Wifi IP: $wifiIP\n';
        });
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.light, statusBarColor: Colors.transparent));

    return isLoading?CircularProgressIndicator(): StreamProvider<UserLocation>(
        create: (context) => LocationService().locationStream,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Splash()
        )
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new DashboardThreePage()));
      prefs.setBool('isPin', false);
    } else {
      prefs.setBool('seen', true);
      prefs.setBool('cek', true);

      if(prefs.getBool('cek') == true){
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new IntroScreen()));
        prefs.setBool('isPin', false);
      }else{
        prefs.setBool('isPin', false);
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new DashboardThreePage()));
      }
    }
  }
  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 500), () {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.transparent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50.0,
                        child:Image.asset("${ApiService().logo}",height: 150.0,width: 150.0,)
//                        child: SvgPicture.asset(
//                          'assets/images/svg/logo.svg',
//                          height: ScreenUtilQ.getInstance().setHeight(150),
//                          width: ScreenUtilQ.getInstance().setWidth(150),
//                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Text('Versi '+ApiService().versionCode,style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),)
                    ],
                  ),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}



class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<PageViewModel> wrapOnboarding = [];
  var cek = [];
  bool isLoading = false;
  var res;
  Future load() async{
    Client client = Client();
    final response = await client.get(ApiService().baseUrl+'info/onboarding');
    if(response.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      if(response.body.isNotEmpty){
        OnboardingModel onboardingModel = OnboardingModel.fromJson(jsonResponse);
        onboardingModel.result.map((Result items){
          setState(() {
            wrapOnboarding.add(PageViewModel(
              pageColor: Colors.white,
              bubbleBackgroundColor: Colors.indigo,
              title: Container(),
              body: Column(
                children: <Widget>[
                  Text(items.title,style: TextStyle(fontFamily: 'Rubik',color: Color(0xFF116240),fontWeight: FontWeight.bold)),
                  Text(items.description,style: TextStyle(fontSize: 12.0,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                ],
              ),
              mainImage: Image.network(
                items.picture,
                width: 285.0,
                alignment: Alignment.center,
              ),
              textStyle: TextStyle(color: Colors.black,fontFamily: 'Rubik',),
            ));
          });

        }).toList();
        setState(() {
          isLoading = false;
        });
      }
    }else {
      throw Exception('Failed to load info');
    }
  }
  @override
  void initState(){
    load();
    isLoading = true;
  }
  SharedPreferences preferences;
  Future<Null> go() async {
//    preferences = await SharedPreferences.getInstance();
//    preferences.setBool('isLogin', false);
//    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPhone()), (Route<dynamic> route) => false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPhone(),
      ), //MaterialPageRoute
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: isLoading?Container(child: Center(child: CircularProgressIndicator(),),):Stack(
          children: <Widget>[
            IntroViewsFlutter(
              wrapOnboarding,
              onTapDoneButton: (){
                go();
              },
              showSkipButton: true,
              doneText: Text("Mulai",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
              pageButtonsColor: Colors.green,
              pageButtonTextStyles: new TextStyle(
                fontSize: 16.0,
                fontFamily: "Rubik",
                fontWeight: FontWeight.bold
              ),
            ),
            Positioned(
                top: 20.0,
                left: MediaQuery.of(context).size.width/2 - 50,
                child: Image.asset('${ApiService().logo}', width: 100,)
            )
          ],
        )
    );
  }
}



class ServerForm extends StatefulWidget {
  @override
  _ServerFormState createState() => _ServerFormState();
}

class _ServerFormState extends State<ServerForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double _height;
  GlobalKey<FormState> _key = GlobalKey();
  bool _large;
  bool _medium;
  double _pixelRatio;
  double _width;
  SharedPreferences preferences;
  var serverAddressController      = TextEditingController();
  final FocusNode serverAddressFocus = FocusNode();
  Future checkServer() async{
    final prefs = await SharedPreferences.getInstance();
    if(serverAddressController.text==''){
      return serverAddressFocus.requestFocus();
    }else{
      prefs.setString("serverName", serverAddressController.text);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Splash()), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return pages(context);

  }

  Widget pages(BuildContext context) {
    ScreenUtilQ.instance = ScreenUtilQ.getInstance()..init(context);
    ScreenUtilQ.instance = ScreenUtilQ(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Center(child:Image.asset("${ApiService().logo}",width: 120.0)),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset("assets/images/image_02.png")
            ],
          ),

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "",
                        width: ScreenUtilQ.getInstance().setWidth(150),
                        height: ScreenUtilQ.getInstance().setHeight(150),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(180)),
                  Container(
                    width: double.infinity,
                    height: ScreenUtilQ.getInstance().setHeight(220),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0.0),
                        boxShadow: [
                          BoxShadow(color: Colors.black12,offset: Offset(0.0, 0.0),blurRadius: 0.0),
                          BoxShadow(color: Colors.black12,offset: Offset(0.0, -5.0),blurRadius: 10.0),
                        ]
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Alamat Server",style: TextStyle(fontSize: ScreenUtilQ.getInstance().setSp(45),fontFamily: "Rubik",letterSpacing: .6,fontWeight: FontWeight.bold)),
                          SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
//                          Text("No WhatsApp (Silahkan Masukan No WhatsApp Yang Telah Anda Daftarkan)",style: TextStyle(fontFamily: "Rubik",fontSize: ScreenUtilQ.getInstance().setSp(26))),
                          TextFormField(
                            maxLength: 60,
                            autofocus: false,
                            controller: serverAddressController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                            focusNode: serverAddressFocus,
                            onFieldSubmitted: (term){
                              checkServer();
//                              _fieldFocusChange(context, nameFocus, nohpFocus);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(20)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("*Pastikan Handphone Anda Terkoneksi Dengan Internet*",style: TextStyle(fontFamily: "Rubik",fontSize: ScreenUtilQ.getInstance().setSp(26),fontWeight: FontWeight.bold,color:Colors.red)),
                  ),

                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(40)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width/1,
                          height: ScreenUtilQ.getInstance().setHeight(100),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                checkServer();
                              },
                              child:Center(
                                child: Text("Simpan",style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: ScreenUtilQ.getInstance().setHeight(40)),
                ],
              ),
            ),
          )
        ],
      ),

    );
  }
  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtilQ.getInstance().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );
}
