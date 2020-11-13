import 'package:shopper/data/local/cart_data_provider.dart';
import 'package:shopper/data/local/db_contract.dart';
import 'package:shopper/data/local/shop_data_provider.dart';
import 'package:shopper/models/shop_item_data.dart';
import 'package:sqflite/sqlite_api.dart';

class DataProviderWrapper {
  CartDataProvider _cartDataProvider;
  ShopDataProvider _shopDataProvider;
  Database _db;

  DataProviderWrapper() {
    this._cartDataProvider = new CartDataProvider();
    this._shopDataProvider = new ShopDataProvider();
    this._shopDataProvider.open(SHOP_DATABASE);
    this._cartDataProvider.open(SHOP_DATABASE).then((value) {
      this._db = this._shopDataProvider.db;
    });
  }

  CartDataProvider get cartDataProvider => _cartDataProvider;

  ShopDataProvider get shopDataProvider => _shopDataProvider;

  Database get db => _db;

  Future removeItemFromShopList(ShopItemData shopItemData) async {
    await db.transaction((txn) async {
      await txn.delete(SHOP_TABLE_NAME, where: "$ID = ?", whereArgs: [shopItemData.id]);
      await txn.delete(CART_TABLE_NAME, where: "$ID = ?", whereArgs: [shopItemData.id]);
    });
  }

  Future persistStateOnPause(List<ShopItemData> shopList, List<ShopItemData> cartList) async {
    await db.transaction((txn) async {
      await txn.delete(SHOP_TABLE_NAME);
      await txn.delete(CART_TABLE_NAME);
      for (var shopItemData in shopList) {
        await txn.insert(SHOP_TABLE_NAME, shopItemData.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      for (var shopItemData in cartList) {
        await txn.insert(CART_TABLE_NAME, shopItemData.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future clearShopAndCart() async {
    await db.transaction((txn) async {
      await txn.delete(SHOP_TABLE_NAME);
      await txn.delete(CART_TABLE_NAME);
    });
  }

}