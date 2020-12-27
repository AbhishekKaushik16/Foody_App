import 'package:flutter/material.dart';
import 'package:foody_app/designs.dart';
import 'package:foody_app/services/getDataApi.dart';
import 'package:url_launcher/url_launcher.dart';


class DetailsPage extends StatefulWidget {
  final String mealId;
  DetailsPage({Key key, @required this.mealId}):super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Future<DetailedMeal> meal;
  @override
  void initState() {
    super.initState();
    meal = fetchById(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder<DetailedMeal>(
        future: meal,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return SizedBox(
              child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )
              ),
            );
          }else {
            DetailedMeal data = snapshot.data;
            return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.black,
                  ],
                  stops: [0.4, 1],
                  begin: Alignment.topLeft,
                ),
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextTitleVariation1(data.mealName),
                          buildTextSubTitleVariation1(data.mealTags?? ''),
                        ],
                      ),
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(data.mealUrl),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      buildTextTitleVariation1("Ingredients"),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.measures.length,
                          itemBuilder: (context, index){
                            return Row(
                              children: [
                                buildTextSubTitleVariation1((index+1).toString() + ' '),
                                buildTextSubTitleVariation1(data.measures[index][0]),
                                SizedBox(width: 5,),
                                buildTextSubTitleVariation1('(' + data.measures[index][1] + ')'),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10,),
                      buildTextTitleVariation1("DIY"),
                      buildTextSubTitleVariation1(data.mealInstructions),
                      SizedBox(height: 10,),
                      buildTextTitleVariation1("Useful Links"),
                      data.mealYoutube == null && data.mealSource == null ?
                      buildTextSubTitleVariation1("No Links available"): Text(""),
                      data.mealSource != null ?
                      InkWell(
                          child: buildTextSubTitleVariation1('1 Website Link'),
                          onTap: () => launch(data.mealSource)
                      ): Text(""),
                      data.mealYoutube != null ?
                      InkWell(
                          child: buildTextSubTitleVariation1('2 Youtube Link'),
                          onTap: () => launch(data.mealYoutube)
                      ): Text(""),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      ),
    );
  }
}
