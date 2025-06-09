import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/listin.dart';
import '../helpers/firestore_analytics.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Listin> listListins = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirestoreAnalytics analytics = FirestoreAnalytics();

  @override
  void initState() {
    refresh();
    analytics.incrementarAcessosTotais();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Listin - Feira Colaborativa")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body: (listListins.isEmpty)
          ? const Center(
              child: Text(
                "Nenhuma lista ainda.\nVamos criar a primeira?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                analytics.incrementarAtualizacoesManuais();
                return refresh();
              },
              child: ListView(
                children: List.generate(listListins.length, (index) {
                  Listin model = listListins[index];
                  return ListTile(
                    onTap: () {},
                    onLongPress: () {
                      showFormModal(model: model);
                    },
                    leading: const Icon(Icons.list_alt_rounded),
                    title: Text(model.name),
                    subtitle: Text(model.id),
                  );
                }),
              ),
            ),
    );
  }

  showFormModal({Listin? model}) {
    String title = "Adicionar Listin";
    String confirmationButton = "Salvar";
    String skipButton = "Cancelar";

    TextEditingController nameController = TextEditingController();

    // Caso esteja editando

    if (model != null) {
      title = "Editando ${model.name}";
      nameController.text = model.name;

      // Ao clicar no botão de excluir, remover o documento do Firestore
    }

    showModalBottomSheet(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32.0),
          child: ListView(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text("Nome do Listin"),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(skipButton),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Criar um objeto Listin com as infos
                      Listin listin = Listin(
                        id: const Uuid().v1(),
                        name: nameController.text,
                      );

                      // Usar id do model se estiver editando

                      if (model != null) {
                        listin.id = model.id;
                      }

                      // Salvar no Firestore
                      firestore
                          .collection("listins")
                          .doc(listin.id)
                          .set(listin.toMap());

                      analytics.incrementarListasAdicionadas();

                      // Atualizar a lista
                      refresh();

                      // Fechar o modal
                      Navigator.pop(context);
                    },
                    child: Text(confirmationButton),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  refresh() async {
    List<Listin> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection("listins")
        .get();

    for (var doc in snapshot.docs) {
      temp.add(Listin.fromMap(doc.data()));
    }

    setState(() {
      listListins = temp;
    });
  }
}
