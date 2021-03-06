import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:n_fintech/Constants/constants.dart';
import 'package:n_fintech/Model/PPOB/PPOBPascaCheckoutModel.dart';
import 'package:n_fintech/Model/generalModel.dart';
import 'package:n_fintech/UI/Homepage/index.dart';
import 'package:n_fintech/UI/Widgets/SCREENUTIL/ScreenUtilQ.dart';
import 'package:n_fintech/UI/Widgets/pin_screen.dart';
import 'package:n_fintech/config/richAlertDialogQ.dart';
import 'package:n_fintech/config/user_repo.dart';
import 'package:n_fintech/resources/PPOB/PPOBPascaProvider.dart';

class DetailPpobPasca extends StatefulWidget {
  DetailPpobPasca({
    this.param,
    this.tagihan_id,
    this.code,
    this.product_name,
    this.type,
    this.phone,
    this.no_pelanggan,
    this.nama,
    this.periode,
    this.jumlah_tagihan,
    this.admin,
    this.jumlah_bayar,
    this.status,
    this.nominal
  });
  final String param;
  final String tagihan_id;
  final String code;
  final String product_name;
  final String type;
  final String phone;
  final String no_pelanggan;
  final String nama;
  final String periode;
  final String jumlah_tagihan;
  final String admin;
  final String jumlah_bayar;
  final String status;
  final String nominal;

  @override
  _DetailPpobPascaState createState() => _DetailPpobPascaState();
}

class _DetailPpobPascaState extends State<DetailPpobPasca> {
  bool isExpanded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final userRepository = UserRepository();
  double _height;
  double _width;
  bool _isLoading = false;
  final formatter = new NumberFormat("#,###");



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("TAGIHAN ID = "+widget.tagihan_id);
    print("CODE = "+widget.code);
    print("PRODUCT NAME = "+widget.product_name);
    print("TYPE = "+widget.type);
    print("PHONE = "+widget.phone);
    print("NO PELANGGAN = "+widget.no_pelanggan);
    print("NAMA = "+widget.nama);
    print("PERIODE = "+widget.periode);
    print("JUMLAH TAGIHAN = "+widget.jumlah_tagihan);
    print("ADMIN = "+widget.admin);
    print("JUMLAH BAYAR = "+widget.jumlah_bayar);
    print("STATUS = "+widget.status);
    print("NOMINAL = "+widget.nominal);

  }

  @override
  Widget build(BuildContext context) {
    // getPin();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace,color: Colors.white),
            onPressed: (){Navigator.of(context).pop();},
          ),
          centerTitle: false,
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
          elevation: 1.0,
          automaticallyImplyLeading: true,
          title: new Text("Detail Pembayaran ${widget.param}", style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Rubik')),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                child: homePageContent(nominal: formatter.format(int.parse(widget.jumlah_tagihan)),nama: widget.nama,periode: widget.periode),
                top: 0,
                right: 0,
                left: 0,
              ),
              Positioned(
                top: 160,
                bottom: 0,
                left: 0,
                right: 0,
                child: ListView(
                  children: <Widget>[
                    TokenCard(
                      param: widget.product_name,
                      iconUrl: IconImgs.noImage,
                      provider: widget.type,
                      no: widget.no_pelanggan,
                      price: widget.jumlah_bayar,
                      note: widget.status,
                    ),
                    Container(
//                      margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
                      padding: EdgeInsets.all(21),
                      child: Row(
                        children: <Widget>[
                          Material(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                child: Container(
                                  width: ScreenUtilQ.getInstance().setWidth(670),
                                  height: ScreenUtilQ.getInstance().setHeight(100),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [Color(0xFF116240),Color(0xFF30CC23)]),
                                      borderRadius: BorderRadius.circular(6.0),
                                      boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
//                                        print("${widget.no}, ${widget.code},${widget.raw_price},${widget.fee_charge}");
                                        _pinBottomSheet(context);
                                      },
                                      child: Center(
                                        child: Text("Bayar",style: TextStyle(color: Colors.white,fontFamily: "Rubik",fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 1.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  Future<void> _pinBottomSheet(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>PinScreen(callback: _callBackPin),
      ),
    );
  }

  _callBackPin(BuildContext context,bool isTrue) async{
    var price;
    if(widget.param == 'ZAKAT'){
      price = widget.nominal;
    }else{
      price = widget.jumlah_bayar;
    }
    print("CODE = ${widget.code}");
    print("ORDERID = ${widget.tagihan_id}");
    print("PRICE = ${price}");
    var res = await PpobPascaProvider().fetchPpobPascaCheckout(widget.code, widget.tagihan_id,price );

    print(res);
    if(res == 'gagal'){
      Navigator.pop(context);
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('terjadi kesalahan, request timeout')));
    }
    else if(res == 'error'){
      Navigator.pop(context);
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('error respon')));
    }
    else{
      if(res is PpobPascaCheckoutModel){
        PpobPascaCheckoutModel results = res;
        if(results.status=="success"){
          setState(() {
            Navigator.pop(context);
          });
          print("#####################################################BERHASIL#######################################");
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return RichAlertDialogQ(
                  alertTitle: richTitle("Transaksi Berhasil"),
                  alertSubtitle: richSubtitle("Transaksi Pembayaran ${widget.param} Berhasil Dilakukan"),
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
          print("#####################################################GAGAK#######################################");
          Navigator.pop(context);
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(results.msg)));
        }
      }
      else{
        General results = res;
        print("#####################################################BERHASIL#######################################");
        Navigator.pop(context);
        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(results.msg)));
      }
    }

  }


}


class homePageContent extends StatelessWidget {
  homePageContent({this.nominal,this.nama,this.periode});
  final String nominal,nama,periode;
  @override
  Widget build(BuildContext context) {
    return Container(
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
      height: 200,
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 21.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Nominal Yang Harus Dibayar", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
              SizedBox(height: 11),
              Divider(color: Colors.white),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: 'Rp. ${nominal} ',
                      style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24.0),
                      children: <TextSpan>[
                        TextSpan(text: '( Dari Saldo Utama )', style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily:'Rubik')),
                      ],
                    ),
                  ),

                ],
              ),
              Divider(color: Colors.white),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Atas Nama", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.0),
                  Text("  :", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.0),
                  Text("$nama", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Periode", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.0),
                  Text("        :", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.0),
                  Text("${periode.substring(0,4)} / ${periode.substring(5,periode.length)}", style: TextStyle(fontFamily:'Rubik',color: Colors.white,fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TokenCard extends StatelessWidget {
  final String param,iconUrl,provider, no, nominal, price, note;
  TokenCard(
      {Key key,
        this.param,
        this.iconUrl,
        this.provider,
        this.no,
        this.nominal,
        this.price,
        this.note,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cek = "";
    if(param == 'PULSA'){
      cek = provider + " ( " + price + " )";
    }else{
      cek = provider;
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 21.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
      ),
      padding: EdgeInsets.all(21.0),
      child: Container(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Image.network(iconUrl),
            ),
            SizedBox(width: 10),
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(cek,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 14),
                  ),
                  SizedBox(height: 10.0,),

                  Text("Nomor : " +
                      no ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 12)
                  ),
                  Divider(),
                  Text(
                      note.toLowerCase(),
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Rubik',fontSize: 14)
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }





}