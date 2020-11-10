import 'dart:async';

import 'package:shopper/models/shop_item_data.dart';

class ShopBloc {
  final shopStreamController = StreamController<List<ShopItemData>>.broadcast();
  final cartStreamController = StreamController<List<ShopItemData>>.broadcast();

  List<ShopItemData> shopList = List<ShopItemData>();
  List<ShopItemData> cartList = List<ShopItemData>();

  Stream<List<ShopItemData>> get shopStream => shopStreamController.stream;
  Stream<List<ShopItemData>> get cartStream => cartStreamController.stream;

  void moveToCart(ShopItemData shopItemData) {
    cartList.add(shopItemData);
    cartStreamController.sink.add(cartList);
  }

  void moveToShop(ShopItemData shopItemData) {
    cartList.remove(shopItemData);
    cartStreamController.sink.add(cartList);
  }

  void add(ShopItemData shopItemData) {
    shopList.add(shopItemData);
    shopStreamController.sink.add(shopList);
  }

  void remove(ShopItemData shopItemData) {
    shopList.remove(shopItemData);
    shopStreamController.sink.add(shopList);
  }

  void toggleChecked(ShopItemData shopItemData, bool value) {
    if (value) {
      int index = shopList.indexOf(shopItemData);
      shopList.remove(shopItemData);
      shopItemData.checked = value;
      cartList.add(shopItemData);
      shopList.insert(index, shopItemData);
    } else {
      int index = shopList.indexOf(shopItemData);
      shopList.remove(shopItemData);
      cartList.remove(shopItemData);
      shopItemData.checked = value;
      shopList.insert(index, shopItemData);
    }
    shopStreamController.sink.add(shopList);
    cartStreamController.sink.add(cartList);
  }

  void removeItemFromShopList(ShopItemData shopItemData) {
    shopList.remove(shopItemData);
    cartList.remove(shopItemData);
    shopStreamController.sink.add(shopList);
  }

  void restoreShopItem(ShopItemData shopItemData, int index) {
    shopList.insert(index, shopItemData);
    shopStreamController.sink.add(shopList);
  }

  void clearShopAndCart() {
    shopList.clear();
    cartList.clear();
    shopStreamController.sink.add(shopList);
  }

  void dispose() {
    shopStreamController.close();
    cartStreamController.close();
  }

}

final shopBloc = ShopBloc();