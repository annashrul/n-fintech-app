import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:n_fintech/Model/profileModel.dart';
import 'package:n_fintech/UI/Widgets/alertq.dart';
import 'package:n_fintech/UI/Widgets/skeletonFrame.dart';
import 'package:n_fintech/UI/Widgets/tutorialClearData.dart';
import 'package:n_fintech/UI/component/History/historyDeposit.dart';
import 'package:n_fintech/UI/component/History/historyPenarikan.dart';
import 'package:n_fintech/UI/component/History/indexHistory.dart';
import 'package:n_fintech/UI/component/dataDiri/indexMember.dart';
import 'package:n_fintech/UI/component/penukaranBonus.dart';
import 'package:n_fintech/UI/component/privacyPolicy.dart';
import 'package:n_fintech/UI/component/sosmed/myFeed.dart';
import 'package:n_fintech/UI/jaringan_ui.dart';
import 'package:n_fintech/UI/loginPhone.dart';
import 'package:n_fintech/config/api.dart';
import 'package:n_fintech/config/richAlertDialogQ.dart';
import 'package:n_fintech/config/user_repo.dart';
import 'package:n_fintech/resources/gagalHitProvider.dart';
import 'package:n_fintech/resources/memberProvider.dart';
import 'package:n_fintech/resources/profileProvider.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'dart:ui' as ui;

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final formatter = new NumberFormat("#,###");
  final userRepository = UserRepository();
  bool isLoading=false, modeUpdate=false,moreThenOne=false,isLoadingShare=false,retry=false;
  int jumlahJaringan=0,counterHit=0;
  String name='',picture='',qr='',kdReferral='',saldo='',rawSaldo='',saldoMain='',saldoBonus='',downline='';
  String kaki1='',kaki2='',kaki3='',privacyPolicy='',omsetJaringan='',id='';


  @override
  void initState() {
    super.initState();
    loadData();
    isLoading=true;
    moreThenOne = false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.light, statusBarColor: Colors.transparent));
    var ratio = ui.window.devicePixelRatio;
    double mq;
    int fl;

    if(ratio>=4.0){
      mq = MediaQuery.of(context).size.height/20;
    }else if(ratio >= 3.5 && ratio < 4.0){

    }else if(ratio >= 3.0 && ratio <3.5){
      mq = MediaQuery.of(context).size.height/16;
    }else if(ratio >= 2.5 && ratio <3.0){
      mq = MediaQuery.of(context).size.height/30;
      mq = MediaQuery.of(context).size.height/35;
    }else if(ratio >= 2.0 && ratio <2.5){
      mq = MediaQuery.of(context).size.height/15;
    }
    print("longestSide ${MediaQuery.of(context).size.longestSide}");
    print("shortestSide ${MediaQuery.of(context).size.shortestSide}");
    print("aspectRatio ${MediaQuery.of(context).size.aspectRatio}");
    print("flifed ${MediaQuery.of(context).size.flipped}");
    print("devicePixelRatio ${ui.window.devicePixelRatio}");

    return Scaffold(
      key: scaffoldKey,
      body:  modeUpdate == true ? UserRepository().modeUpdate(context) : isLoading ? _loading() : retry == true ? UserRepository().requestTimeOut((){
        setState(() {
          counterHit = counterHit+1;
          retry=false;
          isLoading=true;
        });
        loadData();
      }) : moreThenOne==true?UserRepository().moreThenOne(context, (){
        Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => TutorialClearData()));
      }):Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(height: 250.0,width: double.infinity,color: Color(0xFF30cc23),),
                Positioned(
                  bottom: 50.0,
                  right: 100.0,
                  child: Container(
                    width: 400.0,
                    height: 400.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(200.0),color: Color(0xFF116240).withOpacity(0.5)),
                  ),
                ),
                Positioned(
                  bottom: 100.0,
                  left: 150.0,
                  child: Container(
                    width: 300.0,
                    height: 300.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(200.0),color: Color(0xFF30cc23).withOpacity(0.5)),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 30.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(width: 10.0),
                        Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 2.0),
                          ),
                          child:CircleAvatar(
                            radius: 32.0,
                            child: CachedNetworkImage(
                              imageUrl: picture,
                              imageBuilder: (context, imageProvider) => Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => SkeletonFrame(width: 80.0,height: 80.0),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),
                        SizedBox( width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('$name',style: TextStyle(color: Colors.white, fontFamily: 'Rubik', fontSize: 14.0, fontWeight: FontWeight.bold)),
                            GestureDetector(
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text('$kdReferral',style: TextStyle(
                                        fontWeight: FontWeight.bold, color: Colors.white,fontFamily: 'Rubik',
                                        shadows: [Shadow(blurRadius: 5.0,color: Colors.black,offset: Offset(0.0, 1.0))]
                                    )),
                                    SizedBox(width: 5),
                                    Icon(Icons.content_copy, color: Colors.white, size: 15,),
                                  ]
                              ),
                              onTap: () {
                                Clipboard.setData(new ClipboardData(text: '$kdReferral'));
                                scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Kode Referral Berhasil Disalin")));
                              },
                            ),
                          ],
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width/3.5,),
                        IconButton(
                          icon: Icon(Icons.settings,color: Colors.white, size: 20.0,),
                          onPressed: () => Navigator.of(context, rootNavigator: true).push(
                            new CupertinoPageRoute(builder: (context) => IndexMember(id: id)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        customCardOneFour('jaringan_rev', 'Jaringan Saya', '$jumlahJaringan ( Orang )'),
                        customCardOneFour('kaki_1', 'Kaki Besar 1', '$kaki1 ( STP )'),
                        customCardOneFour('kaki_2', 'Kaki Besar 2', '$kaki2 ( STP )'),
                        customCardOneFour('kaki_3', 'Kaki Besar 3', '$kaki3 ( STP )'),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(8.0),
                              child: InkWell(
                                onTap: (){
                                  setState(() {isLoadingShare=true;});
                                  share('$kdReferral');
                                },
                                child: Container(
                                  padding:EdgeInsets.all(15.0),
                                  width: (MediaQuery.of(context).size.width / 3.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 0.0),
                                        child: Center(
                                            child:isLoadingShare?CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)):SvgPicture.network(ApiService().iconUrl+"share_rev.svg", height: MediaQuery.of(context).size.height/20,)
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Padding(
                                        padding: EdgeInsets.only(left: 0.0),
                                        child: Center(
                                          child: Text('Bagikan Link',textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Rubik',fontSize: 12.0,color: Colors.black,fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            customCards('png','QR Code',  '$qr',(){_lainnyaModalBottomSheet(context,'barcode','$qr');}),
                            customCards('','Rp ${formatter.format(int.parse(omsetJaringan))}',  'wallet_rev',(){}),
                          ],
                        ),
                        SizedBox(height: 5.0,)
                      ],
                    )
                  ],
                )
              ],
            ),
            Flexible(
                flex: 1,
                child: RefreshIndicator(
                  child: ListView(
                    children: <Widget>[
                      customlistDetails('','Penukaran Bonus', Icons.monetization_on, Colors.green[100], Colors.red[400],PenukaranBonus(saldo: saldoMain, saldoBonus:saldoBonus)),
                      customlistDetails('','Riwayat Penarikan', Icons.history, Colors.red[50], Colors.red[300],HistoryPenarikan()),
                      customlistDetails('','Riwayat Pembelian', Icons.history, Colors.amber[200], Colors.white,IndexHistory()),
                      customlistDetails('','Riwayat Top Up', Icons.history, Colors.blue[100], Colors.white,HistoryDeposit()),
                      customlistDetails('','Sosial Media', Icons.perm_media, Colors.green, Colors.white,MyFeed()),
                      customlistDetails('','Kebijakan & Privasi', Icons.lock, Colors.orange[100], Colors.orange[300],PrivacyPolicy(privasi: privacyPolicy)),
                      customlistDetails('function','Keluar', Icons.power_settings_new, Colors.green[100], Colors.green[300],LoginPhone())
                    ],
                  ),
                  onRefresh: refresh
                )
            )
          ],
        ),
      ),
    );
  }

  Widget customCardOneFour(String pathImg, String titleOne, String titleTwo){
    return InkWell(
      onTap: () => Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => JaringanUI(kdReferral: kdReferral,name:name))),
      child: Column(
        children: <Widget>[
          SvgPicture.network(ApiService().iconUrl+'icon_'+pathImg+'.svg', height: 35,width:35),
          SizedBox(height: 5.0,),
          Text('$titleOne',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold,fontSize: 12.0)),
          SizedBox(height: 5.0,),
          Text('$titleTwo',style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold,fontSize: 12.0)),
        ],
      ),
    );
  }

  Widget customCards(String param,String title,String imagePath,Function callback) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        onTap: callback,
        child: Container(
          padding:EdgeInsets.all(15.0),
          width: (MediaQuery.of(context).size.width / 3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: Center(
                  child:param=='png'?Image.network(imagePath,height: MediaQuery.of(context).size.height/20):SvgPicture.network(ApiService().iconUrl+imagePath+'.svg', height: MediaQuery.of(context).size.height/20,)
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: Center(
                  child: Text(title,textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Rubik',fontSize: 12.0,color: Colors.black,fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customlistDetails(String param,String title, IconData icon, Color backgroundColor, Color iconColor,Widget xWidget) {
    return InkWell(
      onTap: () async {
        param == 'function' ? showDialog(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialogQ(
                alertTitle: richTitle("Keluar"),
                alertSubtitle: richSubtitle("Anda Yakin Akan Keluar Aplikasi ?"),
                alertType: RichAlertType.WARNING,
                actions: <Widget>[
                  Container(
                    color: Colors.green,
                    child: FlatButton(
                      child: Text("YA", style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        var res = await MemberProvider().logout();
                        if(res.status == 'success'){
                          prefs.clear();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => xWidget), (Route<dynamic> route) => false);
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    color:Colors.red,
                    child: FlatButton(
                      child: Text("TIDAK", style: TextStyle(color: Colors.white,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              );
            }
        ) : Navigator.of(context, rootNavigator: true).push(new CupertinoPageRoute(builder: (context) => xWidget));
      },
      child: ListTile(
        title: Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 12.0)),
        leading: CircleAvatar(
          backgroundColor: backgroundColor,
          child: Center(child: Icon(icon, color: iconColor)),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey,size: 20,),
      ),
    );
  }

  Widget _loading(){
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(height: 250.0,width: double.infinity,color: Color(0xFF30cc23),),
                Positioned(
                  bottom: 50.0,
                  right: 100.0,
                  child: Container(
                    width: 400.0,
                    height: 400.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(200.0),color: Color(0xFF116240).withOpacity(0.5)),
                  ),
                ),
                Positioned(
                  bottom: 100.0,
                  left: 150.0,
                  child: Container(
                    width: 300.0,
                    height: 300.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(200.0),color: Color(0xFF30cc23).withOpacity(0.5)),
                  ),
                ),
                Column(
                  children: <Widget>[

                    Row(
                      children: <Widget>[
                        SizedBox(width: 10.0),
                        Container(
                          width: 75.0,
                          height: 75.0,
                          child:ClipOval(child: SkeletonFrame(width: 75,height: 75)),
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SkeletonFrame(width: 100,height: 15),
                            SizedBox(height: 10.0),
                            SkeletonFrame(width: 100,height: 15),
                          ],
                        ),
                        SizedBox(width:140.0),
                        ClipOval(child: SkeletonFrame(width: 30,height: 30))
                      ],
                    ),
                    SizedBox(height: 25.0),
                    Padding(
                      padding: EdgeInsets.only(left:10.0,right:10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ClipOval(child: SkeletonFrame(width: 50,height: 50)),
                              SizedBox(height:10.0),
                              SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0)
                            ],
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ClipOval(child: SkeletonFrame(width: 50,height: 50)),
                              SizedBox(height:10.0),
                              SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ClipOval(child: SkeletonFrame(width: 50,height: 50)),
                              SizedBox(height:10.0),
                              SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ClipOval(child: SkeletonFrame(width: 50,height: 50)),
                              SizedBox(height:10.0),
                              SkeletonFrame(width: MediaQuery.of(context).size.width/5,height:12.0)
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SkeletonFrame(width: (MediaQuery.of(context).size.width / 3.5),height: 70),
                            SizedBox(width: 5.0),
                            SkeletonFrame(width: (MediaQuery.of(context).size.width / 3.5),height: 70),
                            SizedBox(width: 5.0),
                            SkeletonFrame(width: (MediaQuery.of(context).size.width / 3.5),height: 70),
                            SizedBox(width: 5.0),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 10.0,),
            ListTile(
              title: SkeletonFrame(width: 150.0,height: 15,),
              leading: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
              trailing: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
            ),
            ListTile(
              title: SkeletonFrame(width: 150.0,height: 15,),
              leading: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
              trailing: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
            ),
            ListTile(
              title: SkeletonFrame(width: 150.0,height: 15,),
              leading: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
              trailing: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
            ),
            ListTile(
              title: SkeletonFrame(width: 150.0,height: 15,),
              leading: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
              trailing: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
            ),
            ListTile(
              title: SkeletonFrame(width: 150.0,height: 15,),
              leading: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
              trailing: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
            ),
            ListTile(
              title: SkeletonFrame(width: 150.0,height: 15,),
              leading: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
              trailing: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
            ),
            ListTile(
              title: SkeletonFrame(width: 150.0,height: 15,),
              leading: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
              trailing: ClipOval(child: SkeletonFrame(width: 30,height: 30)),
            ),
          ],
        )
      ],
    );
  }

  void _lainnyaModalBottomSheet(context, String param,String _qr){
    showModalBottomSheet(
        isScrollControlled: param == 'barcode' ? false : true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc){
          return Wrap(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width/1,
                child: Material(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                    elevation: 5.0,
                    color:Colors.grey[50],
                    child: Column(
                        children: <Widget>[
                          SizedBox(height: 20,),
                          Text("Scan Kode Referral Anda ..", style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
                          SizedBox(height: 10.0,),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Image.network(_qr,fit: BoxFit.contain,),
                          )
                        ]
                    )
                ),
              )
            ],
          );
        }
    );
  }

  Future share(param) async{
    setState(() {
      isLoadingShare = true;
    });
    Timer(Duration(seconds: 1), () async {
      setState(() {
        isLoadingShare = false;
      });
      await WcFlutterShare.share(
        sharePopupTitle: 'Thaibah Share Link',
        subject: 'Thaibah Share Link',
        text: "https://thaibah.com/signup/$param\n\n\nAyo Buruan daftar",
        mimeType: 'text/plain'
      );
    });

  }
  Future<void> loadData() async{
    final prefs = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if(prefs.get('pin') == null || prefs.get('pin') == ''){
      print('pin kosong');
      setState(() {
        isLoading = false;modeUpdate = true;
      });
      GagalHitProvider().fetchRequest('profile','kondisi = pin kosong, brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');
    }else{
      if(counterHit >= 2){
        setState(() {
          isLoading = false;
          moreThenOne = true;
        });
        GagalHitProvider().fetchRequest('profile','kondisi = percobaan 2x gagal, brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');

      }else{
        var res = await ProfileProvider().fetchProfile();
        if(res is ProfileModel){
          setState(() {
            isLoading = false; retry = false;
            var result = res.result;
            jumlahJaringan=result.jumlahJaringan;
            name=result.name;picture=result.picture;qr=result.qr;kdReferral=result.kdReferral;saldo=result.saldo;rawSaldo=result.rawSaldo;saldoMain=result.saldoMain;
            saldoBonus=result.saldoBonus;downline=result.downline;kaki1=result.kaki1;kaki2=result.kaki2;kaki3=result.kaki3;privacyPolicy=result.privacy;omsetJaringan=result.omsetJaringan;
            id=result.id;
          });
        }
        else{
          GagalHitProvider().fetchRequest('profile','brand = ${androidInfo.brand}, device = ${androidInfo.device}, model = ${androidInfo.model}');
          setState(() {
            isLoading = false;retry = true;
          });
        }
      }

    }

  }
  Future<void> refresh() async {
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = true;
      });
    });
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    loadData();
  }
}

