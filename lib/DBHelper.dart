import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'products.dart';

class DBHelper {
  static Database _db;

  static const String DB_NAME = 'miniMarket.db';

  static const String TABLE = 'Products';

  static const String ID = 'id';
  static const String NAME = 'name';
  static const String PRICE = 'price';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT, $PRICE REAL)");
  }

  Future<Product> save(Product product) async {
    var dbClient = await db;
    product.id = await dbClient.insert(TABLE, product.toMap());
    return product;
  }

  Future<List<Product>> getProducts() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, PRICE]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Product> products = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        products.add(Product.fromMap(maps[i]));
      }
    }
    return products;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Product product) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, product.toMap(),
        where: '$ID = ?', whereArgs: [product.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}