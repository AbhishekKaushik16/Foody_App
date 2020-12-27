import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
var randomFoods = List<Food>();
Future<List<Food>> getRandom() async{
  var futures = List<Future>() ;
  for(int i=0;i<8;++i) {
    futures.add(fetchFood());
  }
  await Future.wait(futures);
  return randomFoods;
}

Future<List<Food>> searchQuery(String query) async{
  // TODO
  String url = "https://www.themealdb.com/api/json/v1/1/search.php?s=";
  url += query;
  final response = await http.get(url);
  if(response.statusCode == 200) {
    List<Food> searchResult = json.decode(response.body)['meals'].map<Food>((data) => Food.fromJson(data)).toList();
    return searchResult;
  }else{
    throw Exception('Failed to get search');
  }
}

Future<Food> fetchFood() async{
  final response = await http.get('https://www.themealdb.com/api/json/v1/1/random.php');
  if(response.statusCode == 200) {
    // print(response.body);
    randomFoods.add(Food.fromJson(jsonDecode(response.body)['meals'][0]));
    return Food.fromJson(jsonDecode(response.body)['meals'][0]);
  }else{
    throw Exception('Failed to get data');
  }
}

class Food {
  final String mealId;
  final String mealName;
  final String mealLocality;
  final String mealUrl;
  Food({this.mealId, this.mealName, this.mealLocality, this.mealUrl});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      mealId: json['idMeal'],
      mealName: json['strMeal'],
      mealLocality: json['strArea'],
      mealUrl: json['strMealThumb'],
    );
  }
}

Future<DetailedMeal> fetchById(String id) async{
  String url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=";
  url += id;
  final response = await http.get(url);
  if(response.statusCode == 200) {
    // print(response.body);
    // print(jsonDecode(response.body)['meals'][0]);
    return DetailedMeal.fromJson(jsonDecode(response.body)['meals'][0]);
  }else{
    throw Exception('Failed to get data');
  }
}

class DetailedMeal {
  final String mealId;
  final String mealName;
  final String mealLocality;
  final String mealUrl;
  final String mealTags;
  final String mealInstructions;
  final String mealSource;
  final String mealYoutube;
  final List<List<String>> measures;
  DetailedMeal({this.mealId, this.mealName, this.mealLocality, this.mealUrl, this.mealTags, this.measures, this.mealInstructions, this.mealSource, this.mealYoutube});

  factory DetailedMeal.fromJson(Map<String, dynamic> json) {
    List<List<String>> recipe = List<List<String>>();
    for(int i=1;i<=20;++i ){
      String ingredient = "strIngredient";
      ingredient += i.toString();
      String measure = "strMeasure";
      measure += i.toString();
      if(json[ingredient] != null && json[ingredient] != "" && json[measure] != "") {
        recipe.add(List.of([json[ingredient], json[measure]]));
      }else{
        break;
      }
    }
    // print(recipe);
    return DetailedMeal(
      mealId: json['idMeal'],
      mealName: json['strMeal'],
      mealLocality: json['strArea'],
      mealUrl: json['strMealThumb'],
      mealTags: json['strTags'],
      measures: recipe,
      mealInstructions: json['strInstructions'],
      mealSource: json['strSource'],
      mealYoutube: json['strYoutube']
    );
  }
}
