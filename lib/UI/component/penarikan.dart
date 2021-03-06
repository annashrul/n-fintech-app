import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:n_fintech/Model/generalInsertId.dart';
import 'package:n_fintech/Model/generalModel.dart';
import 'package:n_fintech/Model/myBankModel.dart' as prefix0;
import 'package:n_fintech/UI/Homepage/index.dart';
import 'package:n_fintech/UI/Widgets/cardHeader.dart';
import 'package:n_fintech/UI/Widgets/pin_screen.dart';
import 'package:n_fintech/UI/component/bank/indexBank.dart';
import 'package:n_fintech/bloc/myBankBloc.dart';
import 'package:n_fintech/bloc/withdrawBloc.dart';
import 'package:n_fintech/config/flutterMaskedText.dart';
import 'package:n_fintech/config/richAlertDialogQ.dart';

import '../saldo_ui.dart';

class Penarikan extends StatefulWidget {
  final String saldoMain;
  Penarikan({this.saldoMain});
  @override
  _PenarikanState createState() => _PenarikanState();
}

class _PenarikanState extends State<Penarikan> {
  List<RadioModel> sampleData = new List<RadioModel>();
  double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 2;
  int _crossAxisCount = 3;
  var moneyController = MoneyMaskedTextControllerQ(decimalSeparator: '.', thousandSeparator: ',');

  var scaffoldKey = GlobalKey<ScaffoldState>();
  double _height;
  double _width;
  bool _isLoading = false;
  String bankCodeController=null;
  TextEditingController saldoController = TextEditingController();
  TextEditingController accHolderNameController = TextEditingController();
  TextEditingController accNumberController = TextEditingController();
  final FocusNode saldoFocus = FocusNode();

  int selectedRadioTile;
  int selectedRadio;
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }
  var amount;
  Future allReplace(String saldo) async {
    print(saldo);
    var rplcComa = saldo.replaceAll(",", "");
    var sbtrLast3 = rplcComa.substring(0,rplcComa.length-3);
    moneyController.updateValue(double.parse(sbtrLast3));
    amount = sbtrLast3;
    print(amount);
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add(new RadioModel(false, '100,000.00', 'Rp 100,000.00'));
    sampleData.add(new RadioModel(false, '200,000.00', 'Rp 200,000.00'));
    sampleData.add(new RadioModel(false, '300,000.00', 'Rp 300,000.00'));
    sampleData.add(new RadioModel(false, '400,000.00', 'Rp 400,000.00'));
    sampleData.add(new RadioModel(false, '500,000.00', 'Rp 500,000.00'));
    sampleData.add(new RadioModel(false, '1,000,000.00', 'Rp 1,000,000.00'));

  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Rubik"),
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          title: new Text("Penarikan", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
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

        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding:EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black26,
                      offset: new Offset(0.0, 2.0),
                      blurRadius: 25.0,
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32)
                  )
              ),
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CardHeader(saldo: widget.saldoMain),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _bank(context)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Nominal",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: moneyController,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                            prefixText: 'Rp.',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          textInputAction: TextInputAction.done,
                          focusNode: saldoFocus,
                          onFieldSubmitted: (value){
                            saldoFocus.unfocus();
                            if(moneyController.text == '0.00' || moneyController.text == null || bankCodeController == '' || bankCodeController == null){
                              return showInSnackBar("Lengkapi Form Yang Tersedia");
                            }
                            else{
                              setState(() {
                                _isLoading = true;
                              });

                              _pinBottomSheet(context);
                            }
                          },
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Pilih Nominal Cepat",style: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold)),
                        GridView.builder(
                          padding: EdgeInsets.only(top:10, bottom: 10, right: 2),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _crossAxisCount,
                            crossAxisSpacing: _crossAxisSpacing,
                            mainAxisSpacing: _mainAxisSpacing,
                            childAspectRatio: _aspectRatio,
                          ),
                          itemCount: sampleData.length,
                          itemBuilder: (BuildContext context, int index){
                            return new InkWell(
                              onTap: () {
                                setState(() {
                                  sampleData.forEach((element) => element.isSelected = false);
                                  sampleData[index].isSelected = true;
                                  FocusScope.of(context).requestFocus(FocusNode());
                                });
                                allReplace(sampleData[index].buttonText);
                              },
                              child: RadioItem(sampleData[index]),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            if(moneyController.text == '0.00' || moneyController.text == null ||  bankCodeController == '' || bankCodeController == null){
                              return showInSnackBar("Lengkapi Form Yang Tersedia");
                            }
                            else{
//                              setState(() {
//                                _isLoading = true;
//                              });
                              _isLoading = true;
                              _pinBottomSheet(context);
                            }

                          },
                          icon: _isLoading?CircularProgressIndicator():Icon(Icons.arrow_forward),
                        ),
                      )
                  ),
                ],
              ),
            ),
          ],
        )

    );

  }

  void _onDropDownItemSelectedBank(String newValueSelected) async{
    final val = newValueSelected;
    setState(() {
      bankCodeController = val;
    });
  }

  _bank(BuildContext context) {
    myBankBloc.fetchMyBankList();
    return StreamBuilder(
        stream: myBankBloc.allBank,
        builder: (context,AsyncSnapshot<prefix0.MyBankModel> snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          if(snapshot.hasData){
            if(snapshot.data.result.length > 0){
              return InputDecorator(
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color:Colors.black,fontFamily: 'Rubik',fontWeight: FontWeight.bold),
                  labelText: 'Bank',
                ),
                isEmpty: bankCodeController == null,
                child: new DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                    value: bankCodeController,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _onDropDownItemSelectedBank(newValue);
                      });
                    },
                    items: snapshot.data.result.map((prefix0.Result items){
                      return new DropdownMenuItem<String>(
                          value: items.id,

                          child: Text(items.bankname!=''?items.bankname:'kosong',style: TextStyle(fontSize: 12,fontFamily: 'Rubik'),maxLines: 2,softWrap: true,overflow: TextOverflow.ellipsis,)
                      );
                    }).toList(),
                  ),
                ),
              );
            }else{
              return Card(
                color: Colors.white,
                elevation: 1.0,
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text('Anda Belum Mempuya Akun Bank',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0),),
                        ),
                        SizedBox(height: 10.0,),
                        InkWell(
                          onTap: (){
                            Navigator.of(context, rootNavigator: true).push(
                              new CupertinoPageRoute(builder: (context) =>  Bank()),
                            );
//                            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(CupertinoPageRoute(builder: (BuildContext context) => Bank()), (Route<dynamic> route) => false);
                          },
                          child:Center(
                            child: Text('Buat Akun Bank ? Klik Disini',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),),
                          ),
                        )
                      ],
                    )
                ),
              );
            }

          }else{
            return new Center(
                child: new LinearProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF30CC23))
                )
            );
          }
        }
    );
  }



  Future<void> _pinBottomSheet(context) async {
//    setState(() {
//
//    });
    _isLoading = false;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinScreen(callback: _callBackPin),
      ),
    );
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    if(isTrue){
      setState(() {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: LinearProgressIndicator(),
            );
          },
        );
      });
      print(saldoController.text);
      var rplcComa = moneyController.text.replaceAll(",", "");
      var sbtrLast3 = rplcComa.substring(0,rplcComa.length-3);
      var res = await withdrawBloc.fetchWithdraw(sbtrLast3, bankCodeController);
      Navigator.of(context).pop();
      if(res is GeneralInsertId){
        GeneralInsertId results = res;
        if(results.status=="success"){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialogQ(
                alertTitle: richTitle("Transaksi Berhasil"),
                alertSubtitle: richSubtitle("Terimakasih Telah Melakukan Transaksi"),
                alertType: RichAlertType.SUCCESS,
                actions: <Widget>[
                  FlatButton(
                    child: Text("Kembali"),
                    onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardThreePage()), (Route<dynamic> route) => false);
                    },
                  ),
                ],
              );
            }
          );
        }
        else{
          Navigator.of(context).pop();
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(results.msg)));
        }
      }else{
        General results = res;
        Navigator.of(context).pop();
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(results.msg)));
      }
    }else{
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pin Salah!"),
            content: new Text("Masukan pin yang sesuai."),
            actions: <Widget>[
              FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}