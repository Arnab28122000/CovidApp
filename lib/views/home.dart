import 'package:covid/controller/searchBar.dart';
import 'package:covid/views/detail.dart';
import 'package:flutter/material.dart';
import '../models/CovidData.dart';
import 'package:covid/controller/getData.dart';
import '../theme/extention.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<CovidData>> futureData;
  @override
  void initState() {
    super.initState();
    futureData = fetchdata();
  }

  Widget _category() {
    return FutureBuilder<List<CovidData>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("List of countries", style: TextStyles.titleNormal
                                    .copyWith(color: Theme.of(context).primaryColor),),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppTheme.fullHeight(context) * .7,
                        width: AppTheme.fullWidth(context),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return _categoryCard(
                                  snapshot.data[index].country, 
                                  snapshot.data[index].cases, 
                                  snapshot.data[index].deaths,
                                  snapshot.data[index].recovered,
                                  snapshot.data[index].active,
                                  snapshot.data[index].critical,
                                  snapshot.data[index].totalTests,
                                  );
                            },
                        ),
                      ),
                    ],
                  );
              }else{
                return Text("Oops! Data not found.");
              }    
            } 
    );
  }

  Widget _categoryCard(
    String country,
    int cases,
    int deaths,
    int recovered,
    int active,
    int critical,
    int totalTests,
  ) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
      subtitleStyle = TextStyles.bodySm.bold.white;
    }
    return  GestureDetector(
                                          onTap: (){
                                            print("Routing to detail page");
                                            Navigator.of(context).pushNamed(Detail.routeName,
                                            arguments: ScreenArguments(
                                                                      country, 
                                                                      cases, 
                                                                      deaths,
                                                                      recovered,
                                                                      active,
                                                                      critical,
                                                                      totalTests,
                                            ));
                                          },
                      child:  Container(
              height: 180,
              width: AppTheme.fullWidth(context) * .3,
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: -20,
                        left: -20,
                        child: CircleAvatar(
                          backgroundColor: Colors.lightBlue,
                          radius: 60,
                        ),
                      ),
                      Row(
                                              children:<Widget>[Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Flexible(
                              child: Text(country, style: titleStyle).hP8,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Flexible(
                              child: Text(
                                cases.toString(),
                                style: subtitleStyle,
                              ).hP8,
                            ),
                          ],
                        ).p16,
                        SizedBox(width: 50,),
                        Column(children: <Widget>[
                          SizedBox(height:15),
                          Row(children: <Widget>[
                               Text("Deaths:",style: subtitleStyle),
                               Text(deaths.toString(), style: subtitleStyle)
                               ]
                               ),
                               SizedBox(height:15),
                          Row(children: <Widget>[
                               Text("Active:", style:subtitleStyle),
                               Text(active.toString(), style: subtitleStyle,)
                               ]
                               ), 
                          SizedBox(height:15),
                          Row(children: <Widget>[
                               Text("Recovered:",style: subtitleStyle),
                               Text(recovered.toString(), style: subtitleStyle)
                               ]
                               ),
                          SizedBox(height:15),
                          Row(children: <Widget>[
                               Text("Critical:",style: subtitleStyle),
                               Text(critical.toString(), style: subtitleStyle)
                               ]
                               ),  
                        ],)
                        ]
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello,", style: TextStyles.title.subTitleColor),
        Text("Visualize Covid data of different countries", style: TextStyle(color:Colors.blue, fontWeight: FontWeight.bold, fontSize: 20)),
      ],
    ).p16;
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Covid App'),
        ),
        body: Center(
          child: FutureBuilder<List<CovidData>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
          padding: const EdgeInsets.all(8.0),
           child:CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                 _header(),
                SearchBar(),
                _category(),
              ],
            ),
          ),
        ],
           ));
              }else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      );
  }
}