class ShopItemData {
  String _item;
  double _price;
  bool _checked;

  ShopItemData(this._item, this._price, this._checked);

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