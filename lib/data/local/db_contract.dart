import 'package:sqflite/sqflite.dart';

const SHOP_DATABASE = "shop.db";
const DATABASE_VERSION = 1;

const SHOP_TABLE_NAME = "shop";
const CART_TABLE_NAME = "cart";

const ID = "_id";
const ITEM_COLUMN = "item";
const PRICE_COLUMN = "price";
const CHECKED_COLUMN = "checked";

const CREATE_SHOP_TABLE = """
        CREATE TABLE $SHOP_TABLE_NAME (
        $ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $ITEM_COLUMN TEXT NOT NULL,
        $PRICE_COLUMN REAL NOT NULL,
        $CHECKED_COLUMN INTEGER NOT NULL
        )
        """;

const CREATE_CART_TABLE = """
        CREATE TABLE $CART_TABLE_NAME (
        $ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $ITEM_COLUMN TEXT NOT NULL,
        $PRICE_COLUMN REAL NOT NULL,
        $CHECKED_COLUMN INTEGER NOT NULL
        )
        """;

Future createTables(Database db) async {
  await db.execute(CREATE_SHOP_TABLE);
  await db.execute(CREATE_CART_TABLE);
}