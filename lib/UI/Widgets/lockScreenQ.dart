
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

typedef void DeleteCode();
typedef Future<bool> PassCodeVerify(List<int> passcode);
class LockScreenQ extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback fingerFunction;
  final bool fingerVerify;
  final String title;
  final int passLength;
  final bool showWrongPassDialog;
  final bool showFingerPass;
  final String wrongPassTitle;
  final String wrongPassContent;
  final String wrongPassCancelButtonText;
  final String bgImage;
  final Color numColor;
  final String fingerPrintImage;
  final Color borderColor;
  final Color foregroundColor;
  final PassCodeVerify passCodeVerify;
  final String deskripsi;
  final String forgotPin;
  LockScreenQ({
    this.onSuccess,
    this.title,
    this.borderColor,
    this.foregroundColor = Colors.transparent,
    this.passLength,
    this.passCodeVerify,
    this.fingerFunction,
    this.fingerVerify = false,
    this.showFingerPass = false,
    this.bgImage,
    this.numColor = Colors.black,
    this.fingerPrintImage,
    this.showWrongPassDialog = false,
    this.wrongPassTitle,
    this.wrongPassContent,
    this.wrongPassCancelButtonText,
    this.deskripsi,
    this.forgotPin,
  })  : assert(title != null),
        assert(passLength <= 8),
        assert(bgImage != null),
        assert(borderColor != null),
        assert(foregroundColor != null),
        assert(passCodeVerify != null),
        assert(onSuccess != null);
  @override
  _LockScreenQState createState() => _LockScreenQState();
}


class _LockScreenQState extends State<LockScreenQ> {
  var _currentCodeLength = 0;
  var _inputCodes = <int>[];
  var _currentState = 0;
  Color circleColor = Colors.white;

  _onCodeClick(int code) {
    if (_currentCodeLength < widget.passLength) {
      setState(() {
        _currentCodeLength++;
        _inputCodes.add(code);
      });

      if (_currentCodeLength == widget.passLength) {
        widget.passCodeVerify(_inputCodes).then((onValue) {
          if (onValue) {
            setState(() {
              _currentState = 1;
            });
            widget.onSuccess();
          } else {
            _currentState = 2;
            new Timer(new Duration(milliseconds: 1000), () {
              setState(() {
                _currentState = 0;
                _currentCodeLength = 0;
                _inputCodes.clear();
              });
            });
            if (widget.showWrongPassDialog) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: AlertDialog(
                        title: Text(
                          widget.wrongPassTitle,
                          style: TextStyle(fontFamily: "Rubik"),
                        ),
                        content: Text(
                          widget.wrongPassContent,
                          style: TextStyle(fontFamily: "Rubik"),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              widget.wrongPassCancelButtonText,
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            }
          }
        });
      }
    }
  }

  _fingerPrint() {
    if (widget.fingerVerify) {
      widget.onSuccess();
    }
  }

  _deleteCode() {
    setState(() {
      if (_currentCodeLength > 0) {
        _currentState = 0;
        _currentCodeLength--;
        _inputCodes.removeAt(_currentCodeLength);
      }
    });
  }

  _deleteAllCode() {
    setState(() {
      if (_currentCodeLength > 0) {
        _currentState = 0;
        _currentCodeLength = 0;
        _inputCodes.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 200), () {
      _fingerPrint();
    });
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.circular(10.0),
//                        bottomRight: Radius.circular(10.0),
//                      ),
//                      gradient: LinearGradient(
//                        begin: Alignment.centerLeft,
//                        end: Alignment.centerRight,
//                        colors: <Color>[Color(0xFF116240),Color(0xFF30cc23)],
//                      ),
//                    ),
                    child: Stack(
                      children: <Widget>[
                        ClipPath(
//                          clipper: BgClipper(),
//                          SizedBox(height: 60.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
//                            decoration: BoxDecoration(
//                              image: DecorationImage(
//                                image: AssetImage(widget.bgImage),
//                                fit: BoxFit.cover,
//                                colorFilter: ColorFilter.mode(
//                                  Colors.grey.shade800,
//                                  BlendMode.hardLight,
//                                ),
//                              ),
//                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: Platform.isIOS ? 50 : 50,
                                ),
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Rubik"
                                  ),
                                ),
                                SizedBox(
                                  height: Platform.isIOS ? 40 : 15,
                                ),
                                Text(
                                  widget.deskripsi,
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "Rubik", fontSize: 10),
                                ),
                                SizedBox(
                                  height: Platform.isIOS ? 40 : 15,
                                ),
                                CodePanel(
                                  codeLength: widget.passLength,
                                  currentLength: _currentCodeLength,
                                  borderColor: widget.borderColor,
                                  foregroundColor: widget.foregroundColor,
                                  deleteCode: _deleteCode,
                                  fingerVerify: widget.fingerVerify,
                                  status: _currentState,
                                ),
                                widget.showFingerPass ?SizedBox(
                                  height: Platform.isIOS ? 40 : 15,
                                ):Container(),
                                widget.showFingerPass ? forgotScreen() :Container(),
                                widget.showFingerPass ?SizedBox(
                                  height: Platform.isIOS ? 40 : 15,
                                ):Container(),
//                                widget.showFingerPass?
//                                Text(
//                                  widget.forgot,
//                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: "Rubik", fontSize: 10),
//                                ),

                              ],
                            ),
                          ),
                        ),
//                        widget.showFingerPass
//                            ? Positioned(
//                                top: MediaQuery.of(context).size.height / (Platform.isIOS ? 4 : 5),
//                                left: 20,
////                                top: 30,
//                                bottom: 10,
//                                child: GestureDetector(
//                                  onTap: () {
//                                    widget.fingerFunction();
//                                  },
//                                  child: Center(
//                                    child: Text(widget.forgotPin,style: TextStyle(color:Colors.green,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
//                                  ),
//                                ),
//                              )
//                            : Container(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: Platform.isIOS ? 5 : 6,
                  child: Container(
                    padding: EdgeInsets.only(left: 0, top: 0),
                    child:
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                        return null;
                      },
                      child: GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: 1.6,
                        mainAxisSpacing: 35,
                        padding: EdgeInsets.all(8),
                        children: <Widget>[
                          buildContainerCircle(1),
                          buildContainerCircle(2),
                          buildContainerCircle(3),
                          buildContainerCircle(4),
                          buildContainerCircle(5),
                          buildContainerCircle(6),
                          buildContainerCircle(7),
                          buildContainerCircle(8),
                          buildContainerCircle(9),
                          buildRemoveIcon(Icons.close),
                          buildContainerCircle(0),
                          buildContainerIcon(Icons.arrow_back),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget forgotScreen(){
    return InkResponse(
      onTap: (){
        widget.fingerFunction();
      },
      child: Center(
        child: Text(widget.forgotPin,style: TextStyle(color:Colors.green,fontFamily: 'Rubik',fontWeight: FontWeight.bold),),
      ),
    );
  }

  Widget buildContainerCircle(int number) {
    return InkResponse(
      highlightColor: Colors.red,
      onTap: () {
        _onCodeClick(number);
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green,
                blurRadius: 10,
                spreadRadius: 0,
              )
            ]),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: widget.numColor),
          ),
        ),
      ),
    );
  }


  Widget buildRemoveIcon(IconData icon) {
    return InkResponse(
      onTap: () {
        if (0 < _currentCodeLength) {
          _deleteAllCode();
        }
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green,
                blurRadius: 10,
                spreadRadius: 0,
              )
            ]),
        child: Center(
          child: Text('Ulangi',style:TextStyle(fontSize:16.0,color:widget.numColor,fontWeight:FontWeight.bold,fontFamily: 'Rubik')),
//          child: Icon(
//            icon,
//            size: 30,
//            color: widget.numColor,
//          ),
        ),
      ),
    );
  }

  Widget buildContainerIcon(IconData icon) {
    return InkResponse(
      onTap: () {
        if (0 < _currentCodeLength) {
          setState(() {
            circleColor = Colors.grey.shade300;
          });
          Future.delayed(Duration(milliseconds: 200)).then((func) {
            setState(() {
              circleColor = Colors.white;
            });
          });
        }
        _deleteCode();
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green,
                blurRadius: 10,
                spreadRadius: 0,
              )
            ]),
        child: Center(
          child: Text('Hapus',style:TextStyle(fontSize:16.0,color:widget.numColor,fontWeight:FontWeight.bold,fontFamily: 'Rubik')),

//          child: Icon(
//            icon,
//            size: 30,
//            color: widget.numColor,
//          ),
        ),
      ),
    );
  }
}

class CodePanel extends StatelessWidget {
  final codeLength;
  final currentLength;
  final borderColor;
  final bool fingerVerify;
  final foregroundColor;
  final H = 30.0;
  final W = 30.0;
  final DeleteCode deleteCode;
  final int status;
  CodePanel(
      {this.codeLength,
        this.currentLength,
        this.borderColor,
        this.foregroundColor,
        this.deleteCode,
        this.fingerVerify,
        this.status})
      : assert(codeLength > 0),
        assert(currentLength >= 0),
        assert(currentLength <= codeLength),
        assert(deleteCode != null),
        assert(status == 0 || status == 1 || status == 2);

  @override
  Widget build(BuildContext context) {
    var circles = <Widget>[];
    var color = borderColor;
    int circlePice = 1;

    if (fingerVerify == true) {
      do {
        circles.add(
          SizedBox(
            width: W,
            height: H,
            child: new Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(color: color, width: 1.0),
                color: Colors.green.shade500,
              ),
            ),
          ),
        );
        circlePice++;
      } while (circlePice <= codeLength);
    } else {
      if (status == 1) {
        color = Colors.green.shade500;
      }
      if (status == 2) {
        color = Colors.red.shade500;
      }
      for (int i = 1; i <= codeLength; i++) {
        if (i > currentLength) {
          circles.add(SizedBox(
              width: W,
              height: H,
              child: Container(
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: new Border.all(color: color, width: 2.0),
                    color: foregroundColor),
              )));
        } else {
          circles.add(new SizedBox(
              width: W,
              height: H,
              child: new Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(color: color, width: 1.0),
                  color: color,
                ),
              )));
        }
      }
    }

    return new SizedBox.fromSize(
      size: new Size(MediaQuery.of(context).size.width, 30.0),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox.fromSize(
                size: new Size(40.0 * codeLength, H),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: circles,
                )),
          ]),
    );
  }
}

class BgClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height / 1.5);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
