
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:n_fintech/Model/detailNewsPerCategoryModel.dart';
import 'package:n_fintech/UI/Widgets/skeletonFrame.dart';
import 'package:n_fintech/UI/detail_berita_ui.dart';
import 'package:n_fintech/bloc/newsBloc.dart';
import 'package:n_fintech/UI/Widgets/theme.dart' as AppTheme;

class CategoryNewsDetail extends StatefulWidget {
  String category;
  CategoryNewsDetail({this.category});
  @override
  _CategoryNewsDetailState createState() => _CategoryNewsDetailState();
}

class _CategoryNewsDetailState extends State<CategoryNewsDetail> {

  int perpage = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsDetailPerCategory.fetchDetailNewsPerCategory(1,perpage,widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: newsDetailPerCategory.allDetailNewsPerCategory,
      builder: (context, AsyncSnapshot<DetailNewsPerCategoryModel> snapshot) {
        if (snapshot.hasData) {
          return buildContent(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,i) {
                return Padding(
                  padding: const EdgeInsets.only(left: 13,right: 13),
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            flex: 3,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.9,
                              child: CachedNetworkImage(
                                imageUrl: "http://lequytong.com/Content/Images/no-image-02.png",
                                placeholder: (context, url) => Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: AppTheme.Colors.grayTwo,
                                    child: LinearProgressIndicator(backgroundColor: AppTheme.Colors.primaryColor),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>  Center(child: Icon(Icons.error)),
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SkeletonFrame(width: 215,height: 16)
                                    ],
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }

          ),
        );
      },
    );
  }
  Widget buildContent(AsyncSnapshot<DetailNewsPerCategoryModel> snapshot, BuildContext context){
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          itemCount: snapshot.data.result.data.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,i) {
            var tit = "";
            if(snapshot.data.result.data[i].title.length > 27){
              tit = snapshot.data.result.data[i].title.substring(0,27)+' ...';
            }else{
              tit = snapshot.data.result.data[i].title;
            }
            return Padding(
              padding: const EdgeInsets.only(left: 13,right: 13),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailBeritaUI(id: snapshot.data.result.data[i].id, category: snapshot.data.result.data[i].category,)));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.9,
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data.result.data[i].picture,
                            placeholder: (context, url) => Center(
                              child: Container(
                                alignment: Alignment.center,
                                color: AppTheme.Colors.grayTwo,
                                child: LinearProgressIndicator(backgroundColor: AppTheme.Colors.primaryColor),
                              ),
                            ),
                            errorWidget: (context, url, error) =>  Center(child: Icon(Icons.error)),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(tit,style: TextStyle(color:Colors.black, fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'Rubik'),),
                            ],
                          )
                        )
                      )
                    ],
                  ),
                ),
              ),
            );
          }

      ),
    );
  }
}
