# labcalc2

A new Flutter project.

# Commits

## 2024/12/18 - version 0.3.1:
This release introduces significant enhancements across various components of the calculator, including new functionalities and adjustments in styles and colors, detailed below:

* lib/common/constants/constants.dart:
  - addition of the calculator's command list, removalSeq, in descending order of length. This list is used in the backspace method.
* lib/common/models/display/display_controller.dart:
  - this class will manage the TextEditingController and the stack of commands passed to the calculator, stackLines$.
* lib/common/models/key_model/key_model.dart:
  - this class manages the keys and offsets of the buttons.
* lib/common/themes/colors/app_colors.dart:
  - added the fontBlue color.
* lib/common/themes/styles/app_text_styles.dart:
  - adjusted letter sizes in textStyleDisplay and textStyleSecondDisplay styles.
* lib/common/widgets/fix_spin_button.dart:
  - added a specific SpinButton for the fix button.
* lib/features/calculator/widgets/button_hub/button_hub.dart:
  - the following methods were implemented:
    - _insertKey(KeyModel key);
    - _insertAtSelectionPosition(String text, int startPositionSelection, KeyModel key, int endPositionSelection);
    - _insertAtCurrentPosition(int endPositionSelection, String text, KeyModel key);
    - _moveKeyButtons(DirectionKeys key);
    - _moveCursorLeft();
    - _moveCursorRight();
    - _moveCursor(int position);
    - _clearButton();
    - _pmButton(KeyModel key);
    - _backSpaceButton();
    - _fixButton(KeyModel key);
    - (String?, int) _tryRemoveSpecialSequence(String text, int position);
    - _removeLastCharacter(text, position);
    - _updateDisplay(String text, TextSelection newSelection);
    - List<Widget> _createDirectionalButtons();
    - List<Widget> _createMemoryButtons();
    - List<Widget> _createNumbersButtons(String numbers).
* lib/features/calculator/widgets/button_hub/calc_button.dart:
  - adjusted to use the KeyModel class.
* lib/features/calculator/widgets/display/display_widget.dart:
  - some adjustments made to the DisplayWidget.
* lib/features/calculator/widgets/status_bar/status_bar_widget.dart:
  - adjustments in the representation of fix.
* lib/features/settings/settings_page.dart:
  - now using the FixSpinButton.
* lib/main_app.dart:
  - adjustments to the colors of the textSelectionTheme.


## 2024/12/15 - version 0.3.0:

In this version marks a significant advancement in the project, introducing new functionalities for handling measurements and uncertainties, along with the implementation of unit tests to ensure greater robustness and reliability. Details of the changes are described below:

* lib/common/models/measure.dart:
  - addition of the Measure library.
* lib/common/models/measure_functions.dart:
  - addition of functions for the Measure library.
* lib/common/singletons/app_settings.dart:
  - ValueNotifier attributes of the class have been made final (constants);
  - added the reset() method to restart the attributes of the AppSettings class. This was necessary for testing the Measure library and functions.
* test/common/models/measure_test.dart:
  - addition of unit testing for the Measure class, with 93% coverage.
* test/common/models/measure_functions_test.dart:
  - addition of unit testing for the functions in measure_functions, with 96% coverage.


## 2023/12/13 - version 0.2.0:

This commit introduces significant improvements and important additions to the functionalities and interface of the scientific calculator, detailed as follows:

* lib/common/themes/styles/app_text_styles.dart:
  - addition of textStyleDisplay and textStyleButton styles;
  - adjustments to the styles.
* lib/features/calculator/calculator_page.dart:
  - removal of the drawer to the AppDrawer class;
  - adjustments to the proportions of the screen areas;
  - addition of reactivity for the StatusBarWidget.
* lib/features/calculator/widgets/app_drawer.dart:
  - main page drawer.
* lib/features/calculator/widgets/button_hub/button_hub.dart:
  - addition of the ButtonHub class for managing the calculator buttons.
* lib/features/calculator/widgets/button_hub/calc_button.dart:
  - addition of the CalcButton class for the construction of the buttons.
* lib/features/calculator/widgets/display/display_widget.dart:
  - addition of the DisplayWidget class for managing the display.
* lib/features/calculator/widgets/status_bar/status_bar_widget.dart:
  - addition of the StatusBarWidget class to build the status bar of the calculator.
* lib/main_app.dart:
  - the default font of the app has been changed to Roboto.
* pubspec.yaml:
  - addition of fonts and images to the app.


## 2023/12/12 - version 0.1.0:

This commit marks the beginning of version 2 of the scientific calculator specialized in handling uncertainty, LabCalc2. This stage includes crucial additions to the project's visual aspects, encompassing constants, singletons, visual themes, and application pages. Check the details below:
* lib/common/constants/constants.dart:
  - Enums TypeMean and TypeDeviation declared;
  - Maps with the labels meanSignature and deviationSignature established.
* lib/common/singletons/app_settings.dart:
  - AppSettings class created to manage the ValueNotifiers themeMode, mean, deviation, fix, isRadians, and truncate.
* lib/common/themes/colors/color_schemes.g.dart:
  - Color theme added.
* lib/common/themes/styles/app_text_styles.dart:
  - AppTextStyle class added to encapsulate the textStyle, currently with textStyleTitle, textStyleMedium, and textStyleNormal.
* lib/features/about/about_page.dart:
* lib/features/about/about_page_controller.dart:
* lib/features/about/about_page_state.dart:
  - AboutPage created and configured;
  - The controller was necessary to initialize the PackageInfo.
* lib/features/calculator/calculator_page.dart:
  - Addition of the main page, still blank;
  - Drawer of the page added.
* lib/features/settings/settings_page.dart:
  - Page added and already configured.
* lib/features/splash/splash_page.dart:
* lib/features/splash/splash_page_controller.dart:
* lib/features/splash/splash_page_state.dart:
  - Addition of the splash page, blank.
* lib/main_app.dart:
  - MainApp, page with MaterialApp, already has a color theme and configured themeMode;
  - Main font selected as RopaSans;
  - Routes established.
* pubspec.yaml:
  - flutter_launcher_icons configured and icon already installed.

