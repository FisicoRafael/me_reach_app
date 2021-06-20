import 'package:http/http.dart' as http;

class RequesitarServidor {
  RequesitarServidor({required this.urlServidor});

  String urlServidor;

  Future<bool> verificarServidor() async {
    http.Response response;
    response = await http.get(Uri.parse(urlServidor));
    print(response.statusCode);
    if (response.statusCode == 503) {
      return false;
    } else {
      return true;
    }
  }
}
