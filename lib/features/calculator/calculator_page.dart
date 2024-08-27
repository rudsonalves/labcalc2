// Copyright (C) 2024 Rudson Alves
// 
// This file is part of labcalc2.
// 
// labcalc2 is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// labcalc2 is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with labcalc2.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import '../../common/singletons/app_settings.dart';
import 'widgets/app_drawer.dart';
import 'widgets/button_hub/button_hub.dart';
import 'widgets/display/display_widget.dart';
import 'widgets/status_bar/status_bar_widget.dart';
import 'widgets/updade_message/update_message.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  static const routeName = '/calculator';

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _app = AppSettings.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _app.loadSettings();
      updateMessage(context);
    });
  }

  @override
  void dispose() {
    _app.dispose();
    super.dispose();
  }

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
