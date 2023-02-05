

import 'package:best_flutter_ui_templates/munch_app/model/spoonacular_api.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'munch_app_theme.dart';

class MunchDataScreen extends StatefulWidget{
  final int id;
  MunchDataScreen(this.id);
  @override
  State<StatefulWidget> createState() => _MunchDataScreenState(id);
}

class MunchData{
  Map<dynamic, dynamic> basic;
  Map<dynamic, dynamic> price;
  List<dynamic> instructions;
  Map<dynamic, dynamic> nutrition;
  MunchData(this.basic, this.price, this.instructions, this.nutrition);
}

class _MunchDataScreenState extends State<MunchDataScreen> {
  int id;
  _MunchDataScreenState(this.id);
  final ScrollController _scrollController = ScrollController();
  Future<MunchData> getData(id) async {
    var basicInfo = await getRecipeInformation(id);
    var priceInfo = await priceBreakdownQuery(id.toString());
    var instructions = await stepBreakdownQuery(id.toString());
    var nutrition = await nutritionQuery(id.toString());
    return MunchData(basicInfo!, priceInfo, instructions!, nutrition);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    getAppBarUI(),
                    Expanded(
                      child: getListUI(id),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


Widget getListUI(id) {
  return Container(
    decoration: BoxDecoration(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(0, -2),
            blurRadius: 8.0),
      ],
    ),
    child: Column(
      children: <Widget>[
        Expanded(
            child:Container(
              height: MediaQuery.of(context).size.height - 156 - 50,
              child: FutureBuilder<MunchData>(
                future: getData(id),
                builder: (BuildContext context, AsyncSnapshot<MunchData> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(color: HotelAppTheme.buildLightTheme().primaryColor),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting results...'),
                          ),
                        ]
                    )
                    );
                  } else {
                    return ListView(
                      scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                      children: <Widget>[
                        Image.network(snapshot.data!.basic["image"]),
                        Text(
                        snapshot.data!.basic["title"] + "\n\n" + ingredientsToString(getIngredientList(snapshot.data!.price)) + "\nApproximate Total Cost: \$" + getTotalCost(snapshot.data!.price).toStringAsFixed(2) + "\n\nInstructions:\n" + getRecipeSteps(snapshot.data!.instructions) + "\n\n" + nutrientsToString(snapshot.data!.nutrition),
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ]
                    );
                  }
                },
              ),
            )
        )
      ],
    ),
  );
}

  String ingredientsToString(Map<dynamic, dynamic> ingredientsDict){
    var returnstring = "Ingredients:\n";
    ingredientsDict.forEach((key, value) {
      returnstring += key.toString() + ": " + value.toString() + "\n";
    });
    return returnstring;
  }

  String nutrientsToString(Map<dynamic, dynamic> nutrientsDict){
    var returnstring = "Nutrition Facts:\n";
    nutrientsDict["bad"].forEach((element) {
      returnstring += element["title"] + ": " + element['amount'].toString() + "\n" + element["percentOfDailyNeeds"].toString() + "% of Daily Needs\n\n";
    });
    nutrientsDict["good"].forEach((element) {
      returnstring += element["title"] + ": " + element['amount'].toString() + "\n" + element["percentOfDailyNeeds"].toString() + "% of Daily Needs\n\n";
    });
    return returnstring;
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme
            .buildLightTheme()
            .backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery
                .of(context)
                .padding
                .top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Recipe Data',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.favorite_border),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.locationDot),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}