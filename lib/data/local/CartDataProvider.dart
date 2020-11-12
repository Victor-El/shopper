import 'package:path/path.dart';
import 'package:shopper/data/local/db_contract.dart';
import 'package:shopper/models/shop_item_data.dart';
import 'package:sqflite/sqflite.dart';

class ShopDataProvider {
  Database db;

  Future open(String path) async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, SHOP_DATABASE);

    db = await openDatabase(
      path,
      version: DATABASE_VERSION,
      singleInstance: true,
      onCreate: (Database db, int version) async {
        await createTables(db);
      },
    );
  }

  Future<ShopItemData> insertShopItem(ShopItemData shopItemData) async {
    shopItemData.id = await db.insert(CART_TABLE_NAME, shopItemData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return shopItemData;
  }

  Future<ShopItemData> getShopItemData(int id) async {
    var resultList =
    await db.query(CART_TABLE_NAME, where: "$ID = ?", whereArgs: [id]);

    if (resultList.length > 0) {
      return ShopItemData.fromMap(resultList.first);
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    var resultList = await db.query(CART_TABLE_NAME, orderBy: ID);
    return resultList;
  }

  Future<int> updateShopItemData(ShopItemData shopItemData) async {
    return await db.update(CART_TABLE_NAME, shopItemData.toMap(),
        where: "$ID = ?", whereArgs: [shopItemData.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteShopItemData(ShopItemData shopItemData) async {
    return await db.delete(CART_TABLE_NAME, where: "$ID = ?", whereArgs: [shopItemData.id]);
  }

  Future<int> deleteShopItemDataWithId(int id) async {
    return await db.delete(CART_TABLE_NAME, where: "$ID = ?", whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    return await db.delete(CART_TABLE_NAME, where: "1");
  }


}
