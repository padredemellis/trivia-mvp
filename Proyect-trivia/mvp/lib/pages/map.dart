import 'package:mvp/core/constants/app_color.dart';
import 'package:mvp/widget/node_button.dart';
import 'package:flutter/material.dart';
import 'package:mvp/data/models/node.dart';
import 'package:mvp/core/enums/difficulty.dart';
import 'package:mvp/core/constants/text_styles.dart';
import 'package:mvp/core/di/injection_container.dart' as di;
import 'package:mvp/domain/engine/game_engine.dart';

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
    final engine = di.sl<GameEngine>();

    final List<String> themes = [
      'Cultura',
      'Ciencias',
      'Actualidad',
      'Hobbies',
    ];

    return StreamBuilder(
      stream: engine.stateStream,
      builder: (context, snapshot) {
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
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text('Mapa', style: TextStyles.bar),
            backgroundColor: AppColor.backgroundVerde.withValues(),
            elevation: 0,
          ),
          body: Stack(
            children: [
              Positioned.fill(child: background()),
              SingleChildScrollView(
                child: Column(children: buildLevelCards(items)),
              ),
            ],
          ),
        );
      },
    );
  }
}
