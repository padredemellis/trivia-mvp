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
            image: AssetImage('assets/images/leaf_background.png'),
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

      if (i + 1 < items.length) {
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
    final items = List.generate(
      30,
      (index) => Node(
        nodeId: index + 1,
        title: 'Level ${index + 1}',
        description: 'Level ${index + 1} Description',
        difficulty: Difficulty.medium,
        poolQuestionIds: [],
        questionsToShow: 5,
      ),
    );

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
