import 'package:flutter/material.dart';
import 'package:foody_app/screens/detailsPage.dart';
import 'package:foody_app/services/getDataApi.dart';

import '../designs.dart';

class FavouriteScreen extends StatefulWidget {
  final List<Food> title;
  FavouriteScreen({Key key, this.title}): super(key: key);
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  Set<Food> favourites = Set<Food>();
  List<Food> foods;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                buildTextTitleVariation1('Favourite Meals'),
                SizedBox(height: 10,),
                widget.title.length != 0 ?
                ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  shrinkWrap: true,
                  itemCount: widget.title.length,
                  itemBuilder: (context, index) {
                    Food item = widget.title[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (dir) {
                        widget.title.removeAt(index);
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text("Favourite Removed")));
                      },
                      child: ListTile(
                        title: Text(item.mealName, style: TextStyle(color: Colors.white),),
                        leading: Image.network(
                          item.mealUrl,
                          fit: BoxFit.contain,
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => DetailsPage(mealId: item.mealId))
                          );
                        },
                      ),
                    );
                  },
                ):
                buildTextSubTitleVariation1('No Favourites')
              ],
            ),
          )
        ],
      ),
    );
  }
}