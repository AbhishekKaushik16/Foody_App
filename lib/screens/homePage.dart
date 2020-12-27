import 'package:flutter/material.dart';
import 'package:foody_app/screens/detailsPage.dart';
import 'package:foody_app/screens/favourites.dart';
import 'package:foody_app/screens/search.dart';
import 'package:foody_app/services/getDataApi.dart';
import '../constants.dart';
import '../designs.dart';
import 'favourites.dart';


class MyHomePage extends StatefulWidget {
  static const String id = "home_page";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Food> foods;
  List<Food> updateChildTitle = List<Food>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFoods();
  }
  getFoods() async{
    foods = await getRandom();
    print(foods);
  }
  @override
  Widget build(BuildContext context) {
    // double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.85),
                      Colors.black,
                    ],
                    stops: [0.4, 1],
                    begin: Alignment.topLeft,
                  )),
            ),
            DefaultTabController(
              length: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(padding: EdgeInsets.all(8)),
                                buildTextTitleVariation1("Random Foods"),
                                SizedBox(
                                  height: 20,
                                ),
                                GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1, crossAxisCount: 2,
                                    ),
                                    itemCount: 8,
                                    shrinkWrap: true,
                                    controller: ScrollController(keepScrollOffset: false),
                                    itemBuilder: (context, index) {
                                      return FutureBuilder(
                                          future: getRandom(),
                                          builder: (context, snapshot) {
                                            if(snapshot.connectionState != ConnectionState.done){
                                              return SizedBox(
                                                child: Center(child: CircularProgressIndicator(backgroundColor: Colors.white,)),
                                                height: 10.0,
                                                width: 10.0,
                                              );
                                            }
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) => DetailsPage(mealId: foods[index].mealId))
                                                );
                                              },
                                              onDoubleTap: () {
                                                // addToFavourite(foods[index]);
                                                if(updateChildTitle.contains(foods[index])){
                                                  Scaffold.of(context)
                                                      .showSnackBar(SnackBar(content: Text("Already in Your Favourite")));
                                                }else {
                                                  setState(() {
                                                    updateChildTitle.add(
                                                        foods[index]);
                                                  });
                                                  Scaffold.of(context)
                                                      .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              "Added To Favourite")));
                                                }
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
                                                            image: NetworkImage(foods[index].mealUrl),
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
                                                      child: buildRecipeTitle(foods[index].mealName),
                                                      flex: 1,
                                                    )
                                                  ],
                                                )
                                              ),
                                            );
                                          }
                                      );
                                    }
                                ),
                              ],
                            ),
                          ),
                          SearchScreen(),
                          FavouriteScreen(title: updateChildTitle,),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Color(0xFF000000),
                    height: 1,
                    thickness: 1,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF282828),
                      ),
                      child: TabBar(
                        physics: ScrollPhysics(),
                        indicatorColor: Colors.transparent,
                        unselectedLabelColor: Colors.white.withOpacity(0.5),
                        labelColor: Colors.white,
                        tabs: [
                          Tab(
                            child: Column(
                              children: [
                                Icon(Icons.home, size: 30),
                                Text("Home", style: TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                          Tab(
                              child: Column(
                                children: [
                                  Icon(Icons.search, size: 30),
                                  Text("Search", style: TextStyle(fontSize: 10)),
                                ],
                              )),
                          Tab(
                              child: Column(
                                children: [
                                  Icon(Icons.favorite_border, size: 30),
                                  Text("Favourites",
                                      style: TextStyle(fontSize: 10)),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
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