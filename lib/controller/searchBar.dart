import 'package:covid/controller/getData.dart';
import 'package:covid/models/CovidData.dart';
import 'package:covid/theme/light_color.dart';
import 'package:covid/theme/text_styles.dart';
import 'package:covid/views/detail.dart';
import 'package:flutter/material.dart';
import 'package:covid/theme/extention.dart';


class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  CovidData snapshot;

  TextEditingController _controller;
  List<CovidData> futureData;
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  Future<bool> isValid(String name) async{
    futureData= await fetchdata();
    for(int i=0;i<futureData.length;i++){
      if(name.toLowerCase()== futureData[i].country.toLowerCase()){
        setState(() {
          snapshot=futureData[i];
        });
        return true;
      }
    }
    return false;
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(13)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LightColor.grey.withOpacity(.3),
            blurRadius: 15,
            offset: Offset(5, 5),
          )
        ],
      ),
      child: TextField(
        decoration:InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          hintText: "Search for country specific data.",
          hintStyle: TextStyles.body.subTitleColor,
          suffixIcon: SizedBox(
                width: 50,
                child: Icon(Icons.search, color: LightColor.purple)),
        ) ,
        controller: _controller,
          onSubmitted: (String value) async {
            await isValid(value)? showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Country found'),
                  content: Text('You searched for "$value".'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("View Chart"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(Detail.routeName,
                        arguments: ScreenArguments(
                                                                      snapshot.country, 
                                                                      snapshot.cases, 
                                                                      snapshot.deaths,
                                                                      snapshot.recovered,
                                                                      snapshot.active,
                                                                      snapshot.critical,
                                                                      snapshot.totalTests,
                                            ));
                      },
            )
            ]
            );
            }
            ):
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Oops! Country not present'),
                  content: Text('You searched for "$value".'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Get back"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
            )
            ]
            );
            }
            );
          }
          ),
          );
  }
}
