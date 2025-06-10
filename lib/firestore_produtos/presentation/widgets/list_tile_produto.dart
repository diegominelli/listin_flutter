import 'package:flutter/material.dart';
import '../../model/produto.dart';

class ListTileProduto extends StatelessWidget {
  final Produto produto;
  final bool isComprado;
  final Function showModel;

  const ListTileProduto({
    super.key,
    required this.produto,
    required this.isComprado,
    required this.showModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showModel(model: produto);
      },
      leading: Icon((isComprado) ? Icons.shopping_basket : Icons.check),
      title: Text(
        (produto.amount == null)
            ? produto.name
            : "${produto.name} (x${produto.amount!.toInt()})",
      ),
      subtitle: Text(
        (produto.price == null)
            ? "Clique para adicionar preço"
            : "R\$ ${produto.price!}",
      ),
    );
  }
}
