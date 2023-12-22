import 'package:flutter/material.dart';

import '../../common/singletons/app_settings.dart';
import 'widgets/app_drawer.dart';
import 'widgets/button_hub/button_hub.dart';
import 'widgets/display/display_widget.dart';
import 'widgets/status_bar/status_bar_widget.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  static const routeName = '/calculator';

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _app = AppSettings.instance;

  @override
  Widget build(BuildContext context) {
    final colorSheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Laboratory Calculator'),
        backgroundColor: colorSheme.primary,
        actions: [
          ListenableBuilder(
            listenable: _app.themeMode$,
            builder: (context, child) => IconButton(
              onPressed: _app.toggleThemeMode,
              icon: Icon(_app.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : _app.themeMode == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.android),
            ),
          ),
        ],
      ),
      backgroundColor: colorSheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: ListenableBuilder(
                  listenable: _app.expressionError$,
                  builder: (context, _) {
                    return DisplayWidget(erroMode: _app.expressionError);
                  }),
            ),
            Expanded(
              flex: 1,
              child: AnimatedBuilder(
                  animation: Listenable.merge(
                    [
                      _app.fix$,
                      _app.isRadians$,
                      _app.truncate$,
                      _app.mean$,
                      _app.deviation$,
                      _app.counter$,
                    ],
                  ),
                  builder: (context, _) {
                    return StatusBarWidget(
                      fix: _app.fix,
                      isRadians: _app.isRadians,
                      truncate: _app.truncate,
                      mean: _app.mean,
                      deviation: _app.deviation,
                      counter: _app.counter,
                    );
                  }),
            ),
            const Expanded(
              flex: 15,
              child: ButtonHub(),
            ),
          ],
        ),
      ),
    );
  }
}
