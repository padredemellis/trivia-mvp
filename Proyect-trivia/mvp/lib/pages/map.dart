import 'package:mvp/widget/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:mvp/class/item_class.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<Widget> buildLevelCards(List<ItemClass> items) {
    List<Widget> widgets = [];
    int i = 0;

    while (i < items.length) {
      widgets.add(CardWidget(box: items[i]));
      i++;

      if (i + 1 < items.length) {
        widgets.add(
          Row(
            children: [
              Expanded(child: CardWidget(box: items[i])),
              Expanded(child: CardWidget(box: items[i + 1])),
            ],
          ),
        );
        i += 2;
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      30,
      (index) => ItemClass(nivel: index + 1),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('DITSY QUIZ')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/leaf_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: buildLevelCards(items),
          ),
        ),
      ),
    );
  }
}