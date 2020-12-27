import 'package:flutter/material.dart';
import 'package:foody_app/services/getDataApi.dart';
import '../constants.dart';
import '../designs.dart';
import 'detailsPage.dart';

class SearchScreen extends StatefulWidget {
  static const String id = "search";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: BouncingScrollPhysics(),
        children: [
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              "Search",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () {
                showSearch(context: context, delegate: Search());
              },
              child: Container(
                height: 60,
                width: 330,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                          children: [
                            WidgetSpan(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(Icons.search),
                              ),
                            ),
                            TextSpan(
                                text: "Search Meals By Name",
                                style: TextStyle(
                                    color: Colors.black, height: 1)),
                          ]),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: new Border.all(color: Colors.white, width: 2.0),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: Text(
                  "Meals You may like",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            FutureBuilder(
                future: getRandom(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GridView.builder(
                      itemCount: 8,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1, crossAxisCount: 2),
                      shrinkWrap: true,
                      controller: ScrollController(keepScrollOffset: false),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => DetailsPage(mealId: snapshot.data[index].mealId))
                            );
                          },
                          child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                boxShadow: [kBoxShadow],
                              ),
                              margin: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(snapshot.data[index].mealUrl),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    flex: 3,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Expanded(
                                    child: buildRecipeTitle(snapshot.data[index].mealName),
                                    flex: 1,
                                  )
                                ],
                              )
                          ),
                        );
                      },
                    );
                  }
                  return SizedBox(
                    child: Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )),
                  );
                }),
          ],
        ),
      ),
    ]);
  }
}

class Search extends SearchDelegate {
  List<Food> searchList;
  List<Food> recentList;
  // recentList.add(Food(mealName: "abc", mealId: "123", mealLocality: "karnal", mealUrl: "abc"));
  getSearch() async {
    searchList = await searchQuery(query);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textTheme: TextTheme(
          headline6: TextStyle(
        color: Colors.white,
        fontSize: 18,
      )),
      primaryColor: Color(0xFF292929),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Food selectedResult;
  @override
  Widget buildResults(BuildContext context) {
    return DetailsPage(mealId: selectedResult.mealId);
  }

  getFoods() async {
    recentList = await getRandom();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    query.isEmpty ? searchList = recentList : getSearch();
    if (searchList == null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            margin: EdgeInsets.only(top: 20, left: 10),
            height: 100,
            child: Text(
              "No search available",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )),
      );
    }
    return ListView.builder(
        itemCount: searchList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(searchList[index].mealName),
            leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
            onTap: () {
              selectedResult = searchList[index];
              showResults(context);
            },
          );
        });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }
}
