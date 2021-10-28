import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String localTable = "localTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String addressColumn = "addressColumn";
final String typeColumn = "typeColumn";
final String imgColumn = "imgColumn";

class LocalHelper {
  static final LocalHelper _instance = LocalHelper.internal();
  factory LocalHelper() => _instance;
  LocalHelper.internal();
  Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "locals.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $localTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $addressColumn TEXT,"
          "$typeColumn TEXT, $imgColumn TEXT)");
    });
  }

  Future<Local> saveLocal(Local local) async {
    Database dbLocal = await db;
    local.id = await dbLocal.insert(localTable, local.toMap());
    return local;
  }

  Future<Local> getLocal(int id) async {
    Database dbLocal = await db;
    List<Map> maps = await dbLocal.query(localTable,
        columns: [idColumn, nameColumn, addressColumn, typeColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Local.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteLocal(int id) async {
    Database dbLocal = await db;
    return await dbLocal
        .delete(localTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateLocal(Local local) async {
    Database dbLocal = await db;
    return await dbLocal.update(localTable, local.toMap(),
        where: "$idColumn = ?", whereArgs: [local.id]);
  }

  Future<List> getAllLocals() async {
    Database dbLocal = await db;
    List listMap = await dbLocal.rawQuery("SELECT * FROM $localTable");
    List<Local> listLocal = List();
    for (Map m in listMap) {
      listLocal.add(Local.fromMap(m));
    }
    return listLocal;
  }

  Future<int> getNumber() async {
    Database dbLocal = await db;
    return Sqflite.firstIntValue(
        await dbLocal.rawQuery("SELECT COUNT(*) FROM $localTable"));
  }

  Future close() async {
    Database dbLocal = await db;
    dbLocal.close();
  }
}

class Local {
  int id;
  String name;
  String address;
  String type;
  String img;

  Local();

  Local.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    address = map[addressColumn];
    type = map[typeColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      addressColumn: address,
      typeColumn: type,
      imgColumn: img
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Local(id: $id, name: $name, address: $address, type: $type, img $img)";
  }
}
