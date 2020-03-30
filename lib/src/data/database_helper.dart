import 'dart:async';
import 'dart:io' as io;
import 'package:game/src/models/data_api_model.dart';
import 'package:game/src/models/data_global.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

///Inicia base de datos local.
///-Creación de tablas.
///-Funciones.

class DatabaseHelper {
  final String COUNTRY = "COUNTRY";
  final String GLOBAL = "GLOBAL";
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  List<String> listaTabla = new List();

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "cov.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  ///Creación de tablas
  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE " +
        COUNTRY +
        "("
            " country TEXT,"
            "cases INTEGER,"
            "todayCases INTEGER,"
            "countryInfo TEXT,"
            "deaths INTEGER,"
            "todayDeaths INTEGER,"
            "recovered INTEGER,"
            "active INTEGER,"
            "critical INTEGER"
            ")");

    await db.execute("CREATE TABLE " +
        GLOBAL +
        "("
            "cases INTEGER,"
            "deaths INTEGER,"
            "recovered INTEGER,"
            "updated INTEGER,"
            "active INTEGER"
            ")");

    print("Tablas creadas");
  }

  List<String> getTablas() {
    List<String> tablas = new List();
    tablas.add(COUNTRY);
    return tablas;
  }

  ///Inicio funciones utilitarias

  ///Elimina todos los datos de la tabla

  deleteAll(String tabla) async {
    var dbClient = await db;
    dbClient.rawDelete("delete from " + tabla);
    print("Datos de la tabla " + tabla + " eliminados");
  }

  ///Elimina todos los datos de la tabla
  Future<bool> deleteAllTable() async {
    var dbClient = await db;
    List<String> tablas = getTablas();
    for (String tabla in tablas) {
      dbClient.rawDelete("delete from " + tabla).then((value) {
        if (value > 0) {
          print("Datos de la tabla " + tabla + " eliminados");
        }
      });
    }
    return true;
  }

  ///Inserta toda una lista a una tabla
  Future<int> insertAll(String table, List<dynamic> objects) async {
    List<dynamic> listRes = new List();
    var res;
    var dbClient = await db;
    try {
      await dbClient.transaction((db) async {
        objects.forEach((obj) async {
          try {
            var iRes = await db.insert(table, obj.toJson());
            listRes.add(iRes);
          } catch (ex) {
            print(ex.toString());
          }
        });
      });
      res = listRes.length;
      print(res.toString() + " datos ingresados en la tabla " + table);
    } catch (er) {
      print(er.toString());
    }
    return res;
  }
  Future<int> saveUsDataGlobal(DataGlobal data) async {
    var dbClient = await db;
    int res = await dbClient.insert(GLOBAL, data.toJson());
    if(res > 0){
      print('Datos globales guardados');
    }
    return res;
  }
  ///Se busca usuario logeado en bd
  Future<DataGlobal> getDataGlobal() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(GLOBAL);

    if (maps.isNotEmpty) {
      DataGlobal loginData = DataGlobal.fromJson(maps[0]);
      return loginData;
    }

    return null;
  }

  Future<List<DataApiModel>> selectAllCountry() async {
    List<DataApiModel> list;
    var dbClient = await db;
    try {
      await dbClient.transaction((db) async {
        var res = await db.rawQuery("SELECT * FROM " + COUNTRY);
        list = res.isNotEmpty
            ? List<DataApiModel>.from(
            res.toList().map((i) => DataApiModel.fromJson(i)))
            : null;
      });
      if (list != null) {
        print("Se ha recuperado " +
            list.length.toString() +
            " de la tabla Moviles");
      }
    } catch (er) {
      print(er.toString());
    }
    return list;
  }
}
