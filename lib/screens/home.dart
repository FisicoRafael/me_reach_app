import 'dart:async';

import 'package:flutter/material.dart';
import 'package:me_reach_app/helper/requisicao_servidor.dart';
import 'package:me_reach_app/helper/salvar_servidor.dart';
import 'package:me_reach_app/model/servidores.dart';
import 'dart:convert';

class ListaDeServidores extends StatefulWidget {
  const ListaDeServidores({Key? key}) : super(key: key);

  @override
  _ListaDeServidoresState createState() => _ListaDeServidoresState();
}

class _ListaDeServidoresState extends State<ListaDeServidores> {
  TextEditingController controller = TextEditingController();
  List<Servidores> listaDeServidores = [];

  Future<bool> observarServidor(String url) async {
    return await RequesitarServidor(urlServidor: url).verificarServidor();
  }

  Future<void> atualizarLista() async {
    listaDeServidores = await BancoURLServidores.internal().getAllURLs();
    int i = 0;
    for (i = 0; i < listaDeServidores.length; i++) {
      bool disponivel =
          await observarServidor(listaDeServidores[i].URLServidor);
      print(jsonEncode(listaDeServidores[i].toMap()));
      print(disponivel);
      if (disponivel) {
        listaDeServidores[i].disponivel = "1";
        await BancoURLServidores.internal()
            .updateDisponivelServidor(listaDeServidores[i]);
      } else {
        listaDeServidores[i].disponivel = "0";
        await BancoURLServidores.internal()
            .updateDisponivelServidor(listaDeServidores[i]);
      }
    }
    setState(() {});
  }

  Future<void> _chamarAtualizacao() async {
    await Future.delayed(Duration(seconds: 1), () => atualizarLista());
  }

  @override
  void initState() {
    super.initState();
    atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Servidores"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _chamarAtualizacao,
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listaDeServidores.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(listaDeServidores[index].URLServidor),
                        trailing: listaDeServidores[index].disponivel == "0"
                            ? Text("OFFLINE")
                            : Text("ONLINE"),
                        onTap: () {
                          BancoURLServidores.internal()
                              .deleteURLServidor(listaDeServidores[index].id);
                        },
                      );
                    })),
            ElevatedButton(
                onPressed: () {
                  _showColocarURL(
                      context: context, controller: controller, altura: altura);
                },
                child: Text("ADICIONAR SERVIDOR"))
          ],
        ),
      ),
    );
  }
}

void _showColocarURL(
    {required BuildContext context,
    required TextEditingController controller,
    required double altura}) {
  showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
      context: context,
      builder: (context) {
        return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Digite a URL",
                        labelStyle: TextStyle(color: Colors.amber),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.amber, fontSize: 25),
                      controller: controller,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (controller.text != '') {
                          Servidores novoServidor = Servidores();
                          novoServidor.URLServidor = controller.text;
                          print("Controler: ${novoServidor.URLServidor}");
                          BancoURLServidores.internal().salvarURL(novoServidor);
                          _ListaDeServidoresState()._chamarAtualizacao();
                          Navigator.pop(context);
                          controller.clear();
                        }
                      },
                      child: Text("ADICIONAR")),
                  SizedBox(
                    height: altura * 0.5,
                  )
                ],
              );
            });
      });
}
