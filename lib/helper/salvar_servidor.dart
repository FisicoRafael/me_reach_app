import 'package:me_reach_app/model/servidores.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:core';

const String NOME_BANCO_DADOS = "bancoURLsServidores.db";
const String NOME_TABELA = "tabela_servidores03";
const int VERSION = 1;
const String idColuna = "idColuna";
const String URLColuna = "URLColuna";
const String disponivelColuna = "disponivelColuna";

class BancoURLServidores {
  static final BancoURLServidores _instance = BancoURLServidores.internal();

  factory BancoURLServidores() => _instance;

  BancoURLServidores.internal();

  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, NOME_BANCO_DADOS);
    return await openDatabase(path, version: VERSION,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE $NOME_TABELA($idColuna INTEGER PRIMARY KEY, $URLColuna TEXT, $disponivelColuna TEXT)");
    });
  }

  Future<void> salvarURL(Servidores servidor) async {
    Database? dbURL = await db;
    await dbURL!.insert(NOME_TABELA, servidor.toMap());
    //print("Salvando servidor $servidor");
  }

  Future<List<Servidores>> getAllURLs() async {
    Database? dbURL = await db;
    String sql = "SELECT * FROM $NOME_TABELA";
    List listMaps = await dbURL!.rawQuery(sql);
    List<Servidores> listaServidores = [];
    for (Map map in listMaps) {
      listaServidores.add(Servidores.fromMap(map));
    }
    //print(listaServidores);
    return listaServidores;
  }

  Future<int> deleteURLServidor(int? id) async {
    Database? dbURL = await db;
    return await dbURL!
        .delete(NOME_TABELA, where: "$idColuna = ?", whereArgs: [id]);
  }

  Future<int> updateDisponivelServidor(Servidores servidor) async {
    Database? dbURL = await db;
    return await dbURL!.update(NOME_TABELA, servidor.toMap(),
        where: "$idColuna = ?", whereArgs: [servidor.id]);
  }

  Future close() async {
    Database? dbURL = await db;
    dbURL!.close();
  }
}
