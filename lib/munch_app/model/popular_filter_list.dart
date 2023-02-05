class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<PopularFilterListData> dietList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: 'No Restrictions',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Pescetarian',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Vegetarian',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Vegan',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Paleo',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Primal',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> restrictionsList = [
    PopularFilterListData(
      titleTxt: 'All',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Egg',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Gluten',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Peanut',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Sesame',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Seafood',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Shellfish',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Soy',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Sulfite',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Tree Nut',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Wheat',
      isSelected: true,
    ),
  ];
}
