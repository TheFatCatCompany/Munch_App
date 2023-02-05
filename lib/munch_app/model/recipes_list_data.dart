class RecipesListData {
  RecipesListData({
    this.imageUrl = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.likes = 80,
    this.position = 180,
  });

  String imageUrl;
  String titleTxt;
  String subTxt;
  int likes;
  int position;
  List<RecipesListData> recipesList = <RecipesListData>[];
}
