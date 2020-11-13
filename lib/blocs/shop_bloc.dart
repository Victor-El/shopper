import 'dart:async';

import 'package:shopper/data/local/cart_data_provider.dart';
import 'package:shopper/data/local/data_provider_wrapper.dart';
import 'package:shopper/data/local/db_contract.dart';
import 'package:shopper/data/local/shop_data_provider.dart';
import 'package:shopper/models/shop_item_data.dart';

class ShopBloc {

  ShopDataProvider _shopDataProvider;
  CartDataProvider _cartDataProvider;
  DataProviderWrapper _dataProviderWrapper;

  final shopStreamController = StreamController<List<ShopItemData>>.broadcast();
  final cartStreamController = StreamController<List<ShopItemData>>.broadcast();

  List<ShopItemData> shopList = List<ShopItemData>();
  List<ShopItemData> cartList = List<ShopItemData>();

  Stream<List<ShopItemData>> get shopStream => shopStreamController.stream;
  Stream<List<ShopItemData>> get cartStream => cartStreamController.stream;

  ShopBloc() {
    _shopDataProvider = new ShopDataProvider();
    _cartDataProvider = new CartDataProvider();
    _dataProviderWrapper = new DataProviderWrapper();
  }

  Future init() async {
    await _shopDataProvider.open(SHOP_DATABASE);
    await _cartDataProvider.open(SHOP_DATABASE);
  }

  void moveToCart(ShopItemData shopItemData) {
    _cartDataProvider.insertShopItem(shopItemData).then((value) {
      updateListeners();
    });
  }

  void moveToShop(ShopItemData shopItemData) {
    _cartDataProvider.deleteShopItemData(shopItemData).then((value) {
      updateListeners();
    });
  }

  void add(ShopItemData shopItemData) {
    _shopDataProvider.insertShopItem(shopItemData).then((value) {
      updateListeners();
    });
  }

  void remove(ShopItemData shopItemData) {
    _shopDataProvider.deleteShopItemData(shopItemData).then((value) {
      updateListeners();
    });
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
    _dataProviderWrapper.removeItemFromShopList(shopItemData).then((value) {
      updateListeners();
    });
  }

  void restoreShopItem(ShopItemData shopItemData, int index) {
    _shopDataProvider.insertShopItem(shopItemData).then((value) {
      updateListeners();
    });
  }

  void clearShopAndCart() {
    _dataProviderWrapper.clearShopAndCart().then((value) {
      updateListeners();
    });
  }

  Future persistStateOnPause() async {
    _dataProviderWrapper.persistStateOnPause(shopList, cartList).then((value) {
      updateListeners();
    });
  }

  Future updateListeners() async {
    shopList = (await _shopDataProvider.getAll()).map((e) => ShopItemData.fromMap(e)).toList();
    cartList = (await _cartDataProvider.getAll()).map((e) => ShopItemData.fromMap(e)).toList();
    shopStreamController.sink.add(shopList);
    cartStreamController.sink.add(cartList);
  }

  void dispose() {
    shopStreamController.close();
    cartStreamController.close();
  }

}

final shopBloc = ShopBloc();