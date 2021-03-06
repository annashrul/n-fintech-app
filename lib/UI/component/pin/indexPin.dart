import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:n_fintech/Model/generalModel.dart';
import 'package:n_fintech/UI/Homepage/index.dart';
import 'package:n_fintech/UI/Widgets/lockScreenQ.dart';
import 'package:n_fintech/UI/saldo_ui.dart';
import 'package:n_fintech/bloc/memberBloc.dart';
import 'package:n_fintech/config/user_repo.dart';


class Pin extends StatefulWidget {
  final String saldo,param;
  Pin({this.saldo,this.param});
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var onTapRecognizer;
  bool hasError = false;
  String currentText = "";
  final userRepository = UserRepository();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  bool _isLoading = false;
  Future _check(var txtPin, BuildContext context) async {
    print("PIN AKU DI UBAH $txtPin ");
    final name = await userRepository.getName();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await updatePinMemberBloc.fetchUpdatePinMember(txtPin);
    if(res is General){
      General result = res;
      print(result.result);
      if(result.status == 'success'){
        setState(() {_isLoading  = false;});
        if(widget.param == 'beranda'){
          prefs.setBool('isPin', true);
          Timer(Duration(seconds: 3), () {
            prefs.setString('pin', txtPin);
            Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(
              builder: (BuildContext context) => DashboardThreePage()
            ), (Route<dynamic> route) => false);
          });
        }else{
          Timer(Duration(seconds: 3), () {
            prefs.setString('pin', txtPin);
            Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(
                builder: (BuildContext context) => widget.param=='topup' ? SaldoUI(saldo: widget.saldo,name: name) : DashboardThreePage()
            ), (Route<dynamic> route) => false);
          });
        }
        String note = widget.param == 'topup' ? 'Pembuatan PIN Berhasil Dilakukan, Anda Akan Diarahkan Kehalaman Topup Saldo' : 'Pembuatan PIN Berhasil Dilakukan, Anda Akan Diarahkan Kehalaman Beranda';
        return showInSnackBar(note,Colors.green);
      }else{
        setState(() {_isLoading = false;});
        return showInSnackBar(result.msg,Colors.redAccent);
      }
    }else{
      General results = res;
      setState(() {_isLoading = false;});
      return showInSnackBar(results.msg,Colors.redAccent);
    }

  }
  void showInSnackBar(String value,background) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: background,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        leading: IconButton(
//          icon: Icon(Icons.keyboard_backspace,color: Colors.white),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
//        centerTitle: false,
//        flexibleSpace: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.centerLeft,
//              end: Alignment.centerRight,
//              colors: <Color>[
//                Color(0xFF116240),
//                Color(0xFF30cc23)
//              ],
//            ),
//          ),
//        ),
//        elevation: 1.0,
//        automaticallyImplyLeading: true,
//        title: new Text("Ubah PIN", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
//      ),
      key: _scaffoldKey,
      body: Container(

        child: LockScreenQ(
//            showFingerPass: true,
//            forgotPin: 'Lupa Pin ? Klik Disini',
//            fingerFunction: biometrics,
            title: "Keamanan",
            passLength: 6,
            bgImage: "assets/images/bg.jpg",
            borderColor: Colors.black,
            showWrongPassDialog: true,
            wrongPassContent: "Pin Tidak Boleh Diawali Angka 0",
            wrongPassTitle: "Opps!",
            wrongPassCancelButtonText: "Oke",
            deskripsi: 'Buat PIN Untuk Keamanan Akun Anda',
            passCodeVerify: (passcode) async{
              var concatenate = StringBuffer();
              passcode.forEach((item){
                concatenate.write(item);
              });
              setState(() {
                currentText = concatenate.toString();
              });
              if(currentText[0] == 0 || currentText[0] == '0'){
                return false;
              }
              return true;
            },
            onSuccess: () {
              print(currentText[0]);
//              if(currentText[0] == 0 || currentText[0] == '0'){
//                return showInSnackBar("Mohon Maaf, PIN Tidak Boleh Diawali Oleh Angka 0",Colors.redAccent);
//              }else{
//
//              }
              _check(currentText.toString(),context);
//              if(currentText)

            }
        ),
      )
//      body: GestureDetector(
//        onTap: () {
//          FocusScope.of(context).requestFocus(new FocusNode());
//        },
//        child: Container(
//          height: MediaQuery.of(context).size.height,
//          width: MediaQuery.of(context).size.width,
//          child: ListView(
//            children: <Widget>[
//              SizedBox(height: 30),
//              Image.asset(
//                'assets/images/verify.png',
//                height: MediaQuery.of(context).size.height / 3,
//                fit: BoxFit.fitHeight,
//              ),
//              SizedBox(height: 8),
//              Padding(
//                padding: const EdgeInsets.symmetric(vertical: 8.0),
//                child: Text(
//                  'Masukan Pin',
//                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,fontFamily: 'Rubik'),
//                  textAlign: TextAlign.center,
//                ),
//              ),
//              SizedBox(
//                height: 20,
//              ),
//              Padding(
//                  padding:
//                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
//                  child: Builder(
//                    builder: (context) => Padding(
//                      padding: const EdgeInsets.all(5.0),
//                      child: Center(
//                        child: PinPut(
//                          fieldsCount: 6,
//                          isTextObscure: true,
//                          onSubmit: (String txtPin){
//                            setState(() {
//                              _isLoading=true;
//                            });
//                            _check(txtPin, context);
//                          },
//                          actionButtonsEnabled: false,
//                          clearInput: true,
//                        ),
//                      ),
//                    ),
//                  )
//              ),
//
//            ],
//          ),
//        ),
//      ),
    );
  }
}


