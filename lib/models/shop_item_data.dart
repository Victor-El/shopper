import 'package:shopper/data/local/db_contract.dart';

class ShopItemData {
  int _id;
  String _item;
  double _price;
  bool _checked;

  ShopItemData(this._item, this._price, this._checked);


  ShopItemData.fromMap(Map<String, dynamic> shopItemDataMap) {
    this._id = shopItemDataMap[ID] as int;
    this._item = shopItemDataMap[ITEM_COLUMN] as String;
    this._price = shopItemDataMap[PRICE_COLUMN] as double;
    this._checked = (shopItemDataMap[CHECKED_COLUMN] as int) == 1;
  }

  Map<String, dynamic>toMap() {
    var map = {
      ITEM_COLUMN: this._item,
      PRICE_COLUMN: this._price,
      CHECKED_COLUMN: this._checked == true ? 1 : 0
    };
    if (this._id != null) {
      map[ID] = this._id;
    }
    return map;
  }

  int get id => _id;

  set id(int value) => _id = value;

  String get item => _item;

  set item(String value) {
    _item = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  bool get checked => _checked;

  set checked(bool value) {
    _checked = value;
  }

}