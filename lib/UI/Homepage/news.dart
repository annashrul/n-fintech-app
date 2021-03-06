import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:n_fintech/Constants/constants.dart';
import 'package:n_fintech/Model/newsModel.dart';
import 'package:n_fintech/UI/Widgets/skeletonFrame.dart';
import 'package:n_fintech/UI/detail_berita_ui.dart';
import 'package:n_fintech/bloc/newsBloc.dart';


class NewsHomePage extends StatefulWidget {
  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> with AutomaticKeepAliveClientMixin   {
  final _bloc = NewsBloc();
  SwiperController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller = new SwiperController();
    _bloc.fetchNewsList(1, 6);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _bloc.allNews,
      builder: (context, AsyncSnapshot<NewsModel> snapshot) {
        if (snapshot.hasData) {
          return buildContent(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Container(
          padding: EdgeInsets.all(50.0),
            child:Center(
                child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green))
            )
        );
      },
    );
  }

  Widget buildContent(AsyncSnapshot<NewsModel> snapshot, BuildContext context){
//    final scrollController = ScrollController(initialScrollOffset: 0);
    return Container(
      height: MediaQuery.of(context).size.height/4,
      color: Colors.transparent,
      padding: EdgeInsets.only(left:15.0,right:15.0),
      child: Swiper(
        key: _scaffoldKey,
        controller: controller,
//        physics: const NeverScrollableScrollPhysics(),
        autoplay: true,
        fade: 0.0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailBeritaUI(id: snapshot.data.result.data[index].id, category: snapshot.data.result.data[index].category)
                ),
              );
            },
            child: Column(
              children: <Widget>[
                Container(
                  height:  MediaQuery.of(context).size.height/5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(snapshot.data.result.data[index].picture==''||snapshot.data.result.data[index].picture==null?IconImgs.noImage:snapshot.data.result.data[index].picture),
//                                image: CachedNetworkImageProvider(IconImgs.noImage),
                          fit: BoxFit.fill
                      )
                  ),
                ),

              ],
            ),
          );
        },
        itemCount: snapshot.data.result.data.length,
        viewportFraction: 1,
        scale: 1,
        pagination: new SwiperPagination(
            builder: new DotSwiperPaginationBuilder(
                color: Colors.grey, activeColor: Colors.green
            )
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
