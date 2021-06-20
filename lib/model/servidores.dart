class Servidores {
  Servidores();

  final String NOME_COLUNA_SERVIDOR =
      "URLColuna"; //Mesmo nome da coluna no Banco de dados
  final String NOME_COLUNA_ID =
      "idColuna"; //Mesmo nome da coluna no Banco de dados
  final String NOME_COLUNA_DISPONIVEL =
      "disponivelColuna"; //Mesmo nome da coluna no Banco de dados

  String URLServidor = "";
  int? id;
  String disponivel = "0";


  Servidores.fromMap(Map map) {
    id = map[NOME_COLUNA_ID];
    URLServidor = map[NOME_COLUNA_SERVIDOR];
    disponivel = map[NOME_COLUNA_DISPONIVEL];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      NOME_COLUNA_SERVIDOR: URLServidor,
      NOME_COLUNA_DISPONIVEL: disponivel
    };
    if (id != null) {
      map[NOME_COLUNA_ID] = id;
    }
    //print(map);
    return map;
  }
}
