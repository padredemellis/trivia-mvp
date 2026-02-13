import 'package:mvp/widget/node_button.dart';
import 'package:flutter/material.dart';
import 'package:mvp/models/node.dart';
import 'package:mvp/core/enums/difficulty.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget background() {
    return IgnorePointer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  List<Widget> buildLevelCards(List<Node> items) {
    List<Widget> widgets = [];
    int i = 0;

    while (i < items.length) {
      widgets.add(NodeButton(box: items[i]));
      i++;

      if (i < items.length - 1) {
        widgets.add(
          Row(
            children: [
              Expanded(child: NodeButton(box: items[i])),
              Expanded(child: NodeButton(box: items[i + 1])),
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
    final List<String> themes = [
      'Cultura',
      'Ciencias',
      'Actualidad',
      'Hobbies',
    ];

    final items = List.generate(30, (index) {
      String theme = themes[index % themes.length];
      return Node(
        nodeId: index + 1,
        title: theme,
        description: '',
        difficulty: Difficulty.easy,
        poolQuestionIds: [],
        questionsToShow: 0,
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('DITSY QUIZ')),
      body: Stack(
        children: [
          Positioned.fill(child: background()),
          SingleChildScrollView(
            child: Column(children: buildLevelCards(items)),
          ),
        ],
      ),
    );
  }
}
