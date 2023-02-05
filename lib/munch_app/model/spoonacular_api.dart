import 'dart:convert';

import 'package:best_flutter_ui_templates/munch_app/model/recipes_list_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserAgentClient extends http.BaseClient {
  final http.Client _inner;
  final String userAgent;
  UserAgentClient(this.userAgent, this._inner);
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['X-RapidAPI-Key'] = 'API-KEY';
    request.headers['X-RapidAPI-Host'] = 'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com';
    return _inner.send(request);
  }
}

Set<String> CuisineType = {
  "African",
  "American",
  "British",
  "Cajun",
  "Caribbean",
  "Chinese",
  "Eastern European",
  "European",
  "French",
  "German",
  "Greek",
  "Indian",
  "Irish",
  "Italian",
  "Japanese",
  "Jewish",
  "Korean",
  "Latin American",
  "Mediterranean",
  "Mexican",
  "Middle Eastern",
  "Nordic",
  "Southern",
  "Spanish",
  "Thai",
  "Vietnamese"
};

Set<String> Diet =
{
  "Pescetarian",
  "Lacto-Vegetarian",
  "Ovo-Vegetarian",
  "Vegan",
  "Paleo",
  "Primal",
  "Vegetarian"
};

Set<String> Intolerances = {
  "Dairy",
  "Egg",
  "Gluten",
  "Peanut",
  "Sesame",
  "Seafood",
  "Shellfish",
  "Soy",
  "Sulfite",
  "Tree Nut",
  "Wheat"
};

Future<List<RecipesListData>> searchRecipesQuery(String query, {String cuisine = '', String diet = '', String intolerances = '', String equipment = ''}) async{
  var client = UserAgentClient("MunchClient", http.Client());
  List searchResults = List.empty();
  List<RecipesListData> returnlist = <RecipesListData>[];
  if(query == '')
  {
    return returnlist;
  }
  try{
    var response = await client.get(Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/complexSearch', {'query': query, 'cuisine': cuisine, 'diet': diet,
          'intolerances': intolerances, 'equipment': equipment}));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    searchResults = decodedResponse["results"];
  }
  finally {
    client.close();
  }
  int counter = 1;
  searchResults.forEach((element) {
    RecipesListData recipe = RecipesListData(imageUrl: element["image"], titleTxt: element["title"], subTxt: element["id"].toString(), likes: 0, position: counter);
    returnlist.add(recipe);
    counter++;
  });
  return returnlist;
}

Future<List<RecipesListData>> randomRecipes()async{
  var client = UserAgentClient("MunchClient", http.Client());
  List searchResults = List.empty();
  List<RecipesListData> returnlist = <RecipesListData>[];
  try{
    var response = await client.get(Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/random', {'number': '3'}));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    searchResults = decodedResponse["recipes"];
  }
  finally {
    client.close();
  }
  int counter = 1;
  searchResults.forEach((element) {
    RecipesListData recipe = RecipesListData(imageUrl: element["image"], titleTxt: element["title"], subTxt: element["id"].toString(), likes: 0, position: counter);
    returnlist.add(recipe);
    counter++;
  });
  return returnlist;
}

Future<List<RecipesListData>> searchIngredientsQuery(String ingredients) async{
  var client = UserAgentClient("MunchClient", http.Client());
  var searchResults = List.empty();
  List<RecipesListData> returnlist = <RecipesListData>[];
  if(ingredients == '')
  {
    return returnlist;
  }
  try{
    var response = await client.get(Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/findByIngredients', {'ingredients': ingredients, 'number': '10', 'ignorePantry': 'true',
          'ranking': '1'}));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    searchResults = decodedResponse;
  }
  finally {
    client.close();
  }
  int counter = 1;
  searchResults.forEach((element) {
    RecipesListData recipe = RecipesListData(imageUrl: element["image"], titleTxt: element["title"], subTxt: element["id"].toString(), likes: 0, position: counter);
    returnlist.add(recipe);
    counter++;
  });
  return returnlist;
}

Future<Map?> getRecipeInformation(int id) async{
  var strId = id.toString();
  var client = UserAgentClient("MunchClient", http.Client());
  var recipe = Map();
  try {
    var response = await client.get(Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com', '/recipes/$strId/information'));
    recipe = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  }
  finally{
    client.close();
  }
  return recipe;
}

Future<Map> priceBreakdownQuery(String id) async {
  var client = UserAgentClient("MunchClient", http.Client());
  Map searchResults = Map();
  try {
    var response = await client.get(Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com', '/recipes/' + id + '/priceBreakdownWidget.json'));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    searchResults = decodedResponse;
  } finally {
    client.close();
  }
  return searchResults;
}

Future<List?> stepBreakdownQuery(String id) async {
  var client = UserAgentClient("MunchClient", http.Client());
  List searchResults = List.empty();
  try {
    var response = await client.get(Uri.https(
        'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com', '/recipes/' + id + '/analyzedInstructions'));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    searchResults = decodedResponse;
  } finally {
    client.close();
  }
  return searchResults;
}

Future<Map> nutritionQuery(String id) async {
  var client = UserAgentClient("MunchClient", http.Client());
  Map searchResults = Map();
  try {
    var response = await client.get(Uri.https(
        'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com', '/recipes/' + id + '/nutritionWidget.json'));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    searchResults = decodedResponse;
  } finally {
    client.close();
  }
  return searchResults;
}

Map getIngredientList(Map info){
  //based on recipe map it returns the ingredients in the format of
  // ingredient_dict['pasta'] = '6 oz' (key = food, val = amount)
  //info is the result of Price breakdown by ID
  Map ingredientDict = {};
  for (var i = 0; i < info['ingredients'].length; i++) {
    String temp = '';
    if (info['ingredients'][i]['name'] != '') {
      temp = info['ingredients'][i]['name'];
    }
    String temp_2 = '';
    if (info['ingredients'][i]['amount']['us']['value'] != 0) {
      temp_2 = info['ingredients'][i]['amount']['us']['value'].toString();
    }
    if (info['ingredients'][i]['amount']['us']['unit'] != '') {
      temp_2 += ' ' + info['ingredients'][i]['amount']['us']['unit'];
    }
    if (temp != '' && temp_2 != '') {
      ingredientDict[temp] = temp_2;
    }
  }
  return ingredientDict;
}

String getRecipeSteps(List info){
  //returns a string that contains all the lines of ingredients in one
  //string, each step separated by a new line ('\n')
  //info is the result of Get Analyzed Recipe Instructions.
  String allSteps = '';
  for (var x = 0; x < info.length; x++) {
    int count = 1;
    if (info[x]['name'] != '') {
      allSteps += info[x]['name'] + ':\n';
    }
    for (var i = 0; i < info[x]['steps'].length; i++) {
      if (info[x]['steps'][i]['step'] != '') {
        allSteps += count.toString() + '. ' + info[x]['steps'][i]['step'] + '\n';
      }
      count++;
    }
  }
  return allSteps;
}

Map getMissingIngredients(
    Set pantry, Map dictofIngredients){
  //returns the missing ingredients in a dictionary that is denoted
  //by missing_ingredients['pasta'] = '6 oz'
  //pantry is a set of all ingredients that the user has.
  Map<String, String> missingIngredients = {};
  for (var ingredient in dictofIngredients.keys) {
    if (pantry.contains(ingredient) == false) {
      missingIngredients[ingredient] = dictofIngredients[ingredient];
    }
  }

  return missingIngredients;
}

double getTotalCost(Map info){
  //returns the total cost for a specific recipe
  //info is the result of Price Breakdown by ID
  double totalCost = 0;
  for (var i = 0; i < info['ingredients'].length; i++) {
    totalCost += info['ingredients'][i]['price'];
  }

  return totalCost / 100;
}

double getMoneySaved(Map info, Set<String> pantry) {
  //returns the cost of ingrediens in pantry
  //info is the result of Price Breakdown by ID
  //pantry is a set of ingredient strings, all the ingredients the user has.
  double totalCost = 0;
  for (var i = 0; i < info['ingredients'].length; i++) {
    if (pantry.contains(info['ingredients'][i]['name'])) {
      totalCost += info['ingredients'][i]['price'];
    }
  }

  return totalCost / 100;
}

String getNutritionalInfo(Map info) {
  //info is the result of Get Recipe Information
  String nutrition = '';
  if (info['dairyFree']) {
    nutrition += 'Dairy Free\n';
  }
  if (info['glutenFree']) {
    nutrition += 'Gluten Free\n';
  }
  if (info['ketogenic']) {
    nutrition += 'Keto\n';
  }
  if (info['vegan']) {
    nutrition += 'Vegan\n';
  }
  if (info['vegetarian']) {
    nutrition += 'Vegetarian\n';
  }
  if (info['veryHealthy']) {
    nutrition += 'Very Healthy\n';
  }
  return nutrition;
}