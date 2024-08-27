# labcalc2

A new Flutter project.

# Commits

## 2024/08/27 - version: 1.0.10+28

Added GNU General Public License (GPL-3.0) to Project and Updated License Headers

Description:

This commit introduces the following changes:

1. LICENSE File Added:
   - Added the `LICENSE` file containing the full text of the GNU General Public License, Version 3, 29 June 2007.

2. Updated License Headers:
   - Updated the license headers in multiple source files to reflect the use of the GPL-3.0 license. These changes include the following files:
     - `lib/common/constants/app_info.dart`
     - `lib/common/constants/buttons_label.dart`
     - `lib/common/constants/constants.dart`
     - `lib/common/models/app_settings_model.dart`
     - `lib/common/models/display/display_controller.dart`
     - `lib/common/models/key_model/key_model.dart`
     - `lib/common/models/math_expression/function_map.dart`
     - `lib/common/models/math_expression/math_expression.dart`
     - `lib/common/models/measure/measure.dart`
     - `lib/common/models/measure/measure_functions.dart`
     - `lib/common/models/measure/statistic.dart`
     - `lib/common/models/measure/vector.dart`
     - `lib/common/models/memories/app_memories.dart`
     - `lib/common/models/memories/memory.dart`
     - `lib/common/singletons/app_settings.dart`
     - `lib/common/singletons/settings_repository.dart`
     - `lib/common/themes/colors/app_colors.dart`
     - `lib/common/themes/colors/color_schemes.g.dart`
     - `lib/common/themes/styles/app_button_styles.dart`
     - `lib/common/themes/styles/app_text_styles.dart`
     - `lib/common/widgets/fix_spin_button.dart`
     - `lib/features/about/about_page.dart`
     - `lib/features/calculator/calculator_page.dart`
     - `lib/features/calculator/widgets/app_drawer.dart`
     - `lib/features/calculator/widgets/button_hub/button_hub.dart`
     - `lib/features/calculator/widgets/button_hub/calc_button.dart`
     - `lib/features/calculator/widgets/button_hub/utilities/create_button.dart`
     - `lib/features/calculator/widgets/button_hub/utilities/display_utilities.dart`
     - `lib/features/calculator/widgets/button_hub/utilities/string_edit.dart`
     - `lib/features/calculator/widgets/dialog_reset/dialog_reset.dart`
     - `lib/features/calculator/widgets/display/display_widget.dart`
     - `lib/features/calculator/widgets/status_bar/status_bar_widget.dart`
     - `lib/features/calculator/widgets/updade_message/update_message.dart`
     - `lib/features/settings/settings_page.dart`
     - `lib/features/splash/splash_page.dart`
     - `lib/features/splash/splash_page_controller.dart`
     - `lib/features/splash/splash_page_state.dart`
     - `lib/main.dart`
     - `lib/main_app.dart`

3. Dependency Updates in `pubspec.lock`:
   - Updated several dependencies to newer versions. Key updates include:
     - `crypto` from 3.0.3 to 3.0.5
     - `ffi` from 2.1.2 to 2.1.3
     - `leak_tracker` from 10.0.4 to 10.0.5
     - `leak_tracker_flutter_testing` from 3.0.3 to 3.0.5
     - `material_color_utilities` from 0.8.0 to 0.11.1
     - `meta` from 1.12.0 to 1.15.0
     - `path_provider_android` from 2.2.9 to 2.2.10
     - `test_api` from 0.7.0 to 0.7.2
     - `url_launcher_android` from 6.3.8 to 6.3.10
     - `url_launcher_linux` from 3.1.1 to 3.2.0
     - `url_launcher_web` from 2.3.1 to 2.3.3
     - `vm_service` from 14.2.1 to 14.2.4
     - `web` from 0.5.1 to 1.0.0
     - `win32` from 5.5.3 to 5.5.4

This commit ensures all source code files are now compliant with the GNU GPL-3.0 and reflects these changes consistently across the entire project.


## 2024/05/06 - version: 1.0.7+25

Privacy Policy Address Corrections and Functional Enhancements

- **Privacy Policy and Developer Page Corrections**:
  - Corrected the URLs for the privacy policy and developer page in the `measure.dart` to point to the new blog, ensuring compliance and up-to-date information is accessible to the users.

- **Equality Operator Update**:
  - Updated the equality operator (`==`) in `measure.dart` to accept a non-null parameter, improving the robustness of model comparisons by enforcing type safety.

- **UI Enhancement in About Page**:
  - Introduced a new method `simpleAddress` in `about_page.dart` to strip 'https://' from URLs displayed on the About page. This adjustment helps in fitting the text neatly on the page, enhancing the visual presentation without compromising the information's integrity.

- **Version Update**:
  - Incremented the application's version to `1.0.7+25` to mark the introduction of these improvements and fixes.

This commit ensures that the application maintains accurate and user-friendly information display, while also enhancing data handling and UI presentation.

## 2024/01/31 - Version: 1.0.6+23:

In this update, we've made a few improvements and added new features to enhance your application experience:

* android/app/src/main/AndroidManifest.xml:
  - Internet access to visit the privacy policy page.
* lib/features/calculator/widgets/updade_message/update_message.dart:
  - Update message upgrades.
  

## 2024/01/04 - version: 1.0.5+18:

This update enhances the functionality related to accessing external resources like the Privacy Policy page and streamlines communication features within the app. Key changes include:

* android/app/src/main/AndroidManifest.xml:
  - Added permissions to access internet pages through the browser. This is used to access the Privacy Policy page.
* lib/common/constants/app_info.dart:
  - Adjusted the AppInfo to include new methods:
    - static Future<void> launchUrl(String url) for opening a URL in the browser.
    - static Future<void> copyUrl(String url) to copy a URL to the clipboard.
    - static Future<void> launchMailto() for email communication.
* lib/features/about/about_page.dart:
  - The Privacy Policy page link now opens in the browser for direct access.
* lib/features/calculator/widgets/update_message/update_message.dart:
  - Updated the message content.
  - Added a button linking to the Privacy Policy for easy access.


## 2024/01/03b - version: 1.0.5+17:

This update of LabCalc marks a significant shift in the app's data storage approach, enhancing the overall stability and security. Key changes in this version include:

* android/app/build.gradle:
  - Removed "ndk { abiFilters 'armeabi-v7a' }". This key was initially added to resolve the 'couldn't find "libflutter.so"' error. However, after reconsideration, I've replaced Realm with flutter_secure_storage for a more streamlined experience.
* lib/common/models/app_settings_model.dart:
  - Adjusted to save the attributes isRadian and truncate.
  - Added the method Map<String, dynamic> toMap() to generate a map for stored settings.
  - Introduced the factory method AppSettingsModel.fromMap(Map<String, String> map) for importing a <String, String> map.
* lib/common/singletons/app_settings.dart:
  - Updated the methods toggleIsRadians() and toggleTruncate() to refresh the flutter_secure_storage upon changes.
* lib/common/singletons/settings_repository.dart:
  - This class has been rewritten to operate with flutter_secure_storage;
    - Methods init(), _openRealm(), and dispose() are no longer necessary.
    - Methods Future<void> saveSettings(AppSettingsModel app) and Future<void> loadSettings() have been rewritten.
* lib/database/model/settings.dart:
* lib/database/model/settings.g.dart:
  - These codes are no longer needed and have been removed.
* lib/features/calculator/widgets/update_message/update_message.dart:
  - The message has been separated from the body of the updateMessage function for better clarity and maintainability.


## 2024/01/03 - version: 1.0.4+15:

This update of LabCalc focuses on technical enhancements and usability adjustments, particularly regarding compatibility with different platforms and user experience on the About page. The changes are as follows:

* android/app/build.gradle:
  - Added the option "ndk { abiFilters 'armeabi-v7a' }" to defaultConfig. This change addresses an issue related to the Realm package that affected compiling the app on 32Bit devices, as discussed in [Flutter app: couldn’t find “libflutter.so”](https://medium.com/codechai/flutter-app-couldnt-find-libflutter-so-c95ad81cbccd).
* android/app/src/main/AndroidManifest.xml:
  - Removed direct link calls to the browser. Now, links are copied to the user's clipboard, enhancing security and usability.
* lib/common/singletons/app_settings.dart:
  - The file lib/database/settings_repository.dart was moved to the lib/common/singletons folder.
  - The _openRealm() method was updated to accommodate changes in the database schema that occurred after adding the app version attribute to the table.
* lib/features/about/about_page.dart:
  - The _launchUrl method was renamed to _copyUrl and now performs the function of copying URLs to the clipboard.
  - Made changes to the layout of the About page to enhance presentation and user experience.


## 2023/12/31 - version: 1.0.4+7:

This version of LabCalc introduces significant enhancements, with a special highlight on the inclusion of the Privacy Policy in the About page, meeting Google's requirements. The changes also include improvements in usability and functionality of the app. The changes are as follows:

* android/build.gradle:
  - updated ext.kotlin_version to 1.9.22.
* lib/common/constants/buttons_label.dart:
  - corrected an error in the pow10 function label.
* lib/common/models/measure/measure.dart:
  - removed spaces around the '±' character in toString... and truncate() methods;
  - added the method toStringByFunc(String Function(double) fixFunction) to print a Measure after applying a filter function fixFunction to its elements.
* lib/common/models/measure/measure_functions.dart:
  - added the method toStringByFunc(String Function(double) fixFunction) with the same purpose above for the PolarRepresentation and RectRepresentation classes.
* lib/common/singletons/app_settings.dart:
  - adjusted the management of the fix value to allow better external control in updating through Realm, avoiding excessive writings.
* lib/common/widgets/fix_spin_button.dart:
  - a FixSpinButton object now supports longPress for its adjustment.
* lib/features/about/about_page.dart:
  - **added the Privacy Policy and the copy link to the device's clipboard**;
  - tooltip messages were added to inform about the copy to the clipboard of the links.
* lib/features/calculator/widgets/button_hub/button_hub.dart:
  - the filter for repetition of operators was moved to the method expressionBasicFilter(String text);
  - replaced value.toString() with value.toStringByFunc(_removeTrailingZeros) in preparing the results to be displayed;
  - added the method String _removeTrailingZeros(double value) to remove trailing zeros from a double if after a decimal point;
  - adjusted the method memoriesLettersKey so that the memory call is appropriately inserted into the expression;
  - added the method showStack() to display the statistical value stack;
  - rearranged some calculator buttons for better user convenience;
  - added longPress to the statistics stack button to display its content.
* lib/features/calculator/widgets/button_hub/calc_button.dart:
  - the CalcButton class was changed to allow the use of longPress.
* lib/features/calculator/widgets/display/display_widget.dart:
  - length for changing the font size of the primary display was increased to 64.
* lib/features/calculator/widgets/update_message/update_message.dart:
  - adjusted the app launch message.
* lib/features/settings/settings_page.dart:
  - another change in the FixSpinButton was the removal of attribute passing. AppSettings is now read directly by the class.


## 2023/12/28b - version: 1.0.4+6:

This update of LabCalc introduces an initial system to detect app updates and inform users about the new features. This system is still in its early stage and will be further improved in future versions. The changes are as follows:

* lib/common/models/app_settings_model.dart:
* lib/database/settings_repository.dart:
  - added the String attribute 'version' to manage the app version saved by Realm.
* boot/common/singletons/app_settings.dart:
  - added the String attribute '_version' to keep a copy of the app version at the last boot;
  - the setter 'version(String newVersion)' updates the app version in Realm when changed.
* lib/database/model/settings.dart:
  - added the new String attribute 'version' to record the app version in Realm.
* lib/features/calculator/calculator_page.dart:
  - added a call to the 'updateMessage(context)' function to check if the app version stored in Realm is the same as the currently running version.
* lib/features/calculator/widgets/update_message/update_message.dart:
  - this function checks if the app version recorded in Realm is different from the installed version. If so, it means that the app has been updated, and a message with the new features is displayed. Otherwise, the dialog is simply closed.


## 2023/12/28 - version: 1.0.4+5:

This version of LabCalc introduces key adjustments in branding, accessibility improvements, and optimizations for testing. The changes include:

* android/app/build.gradle:
* android/app/src/main/kotlin/br/com/jrblog/labcalc/MainActivity.kt:
  - the app's name changed from br.com.jrblog.labcalc2 to br.com.jrblog.labcalc, due to registration on Google Play.
* android/app/src/main/AndroidManifest.xml:
  - added access to the app's page on the author's blog.
* lib/common/constants/app_info.dart:
  - this class is updated when generating new builds for the app, through the flutterbuild command, a personal script used for final testing.
* lib/common/singletons/app_settings.dart:
  - added a _testMode flag to indicate the test mode in AppSettings. This was necessary to avoid data recording during app testing.
* lib/common/themes/colors/app_colors.dart:
  - added AppColors.darkPrimary color to improve contrast on the Settings and About pages of the app.
* lib/common/themes/colors/color_schemes.g.dart:
  - additional color adjustments to improve contrast in the app.
* lib/features/about/about_page.dart:
  - page colors adjusted to improve contrast;
  - with the addition of AppInfo.version, AboutPage has become a static page, not requiring state control.
* lib/features/about/about_page_controller.dart:
* lib/features/about/about_page_state.dart:
  - these files were removed from the project as AboutPage no longer requires state control.
* lib/features/settings/settings_page.dart:
  - page colors adjusted to improve contrast.
* pubspec.yaml:
  - removed the package_info_plus package, no longer needed.
* test/common/models/math_expression/math_expression_test.dart:
* test/common/models/measure_functions_test.dart:
* test/common/models/measure_test.dart:
* test/common/models/memories/app_memories_test.dart:
* test/common/models/memories/memory_test.dart:
  - tests adjusted for the addition of realm to the project.


## 2023/12/26 - version: 0.9.3:

This update of LabCalc2 brings significant improvements to the user interface, new functionalities, and lays the groundwork for future expansions. Details of the changes:

* android/app/build.gradle: 
  - added a keystore for the app and changed the build mode to release.
* assets/images:
  - added images for Pol/Rec buttons;
  - added images for a 512x512 icon and a 1024x500 image for the Google Play console.
* lib/common/constants/buttons_label.dart:
  - added labels for the Pol and Rec buttons.
* lib/common/constants/constants.dart:
  - registered character sequences for the new Pol/Rec buttons in the removalSeq list.
* lib/common/models/math_expression/function_map.dart:
  - registered functions and parameter numbers for the new Pol/Rec buttons.
* lib/common/models/math_expression/math_expression.dart:
  - added new functions to the filters of the MathExpression class.
* lib/common/models/measure/measure_functions.dart:
  - created new functions dynamic pol(dynamic x, dynamic y) and dynamic rec(dynamic r, dynamic o) for the Pol/Rec buttons;
  - Created PolarRepresentation and RectRepresentation classes to represent the outputs of the new buttons.
* lib/common/models/measure/vector.dart:
  - this class is a proposal for a future version with support for vectors and vector algebra. Currently, the code is not incorporated into LabCalc2.
* lib/common/themes/styles/app_text_styles.dart:
  - added new textStyleBig model for use in ...
* lib/common/widgets/fix_spin_button.dart:
  - fix button now shows an 'off' also in the SpinBox when fix is set to -1.
* lib/features/calculator/widgets/app_drawer.dart:
  - reset button has been moved to the app drawer;
  - 'Future.delayed(Duration.zero, () => DialogReset.execute(context)' was necessary to wait for the drawer to close and take the context of the main page, instead of the drawer's context.
* lib/features/calculator/widgets/button_hub/button_hub.dart:
  - corrected cursor positioning filter in the insertKey method to support the new Pol/Rec functions;
  - added filters in the insertKey method to remove possible repetitions of the operators '+-*/';
  - adjusted the result outputs in the equalKey method to support the new functions;
  - added the measureKey method to manage the entry of Measures in the equation. This prevents unnecessary successive openings of parentheses in the function;
  - ResetButton replaced by Pol/Rec buttons on the keyboard.
* lib/features/calculator/widgets/button_hub/utilities/display_utilities.dart:
  - adjusted the regex in the moveCursorLeft/moveCursorRight methods to add support for movement through variables for the new functions.
* lib/features/calculator/widgets/dialog_reset/dialog_reset.dart:
  - this class now manages the call for the dialog that presents the calculator reset.
* lib/features/calculator/widgets/dialog_reset/dialog_reset.dart.old:
  - the old ResetButton class is still backed up at the moment but should be removed soon.
* lib/features/splash/splash_page.dart:
* lib/features/splash/splash_page_controller.dart:
  - completed the SplashPage to display a simple page with the app's name and icon.
* lib/main_app.dart:
  - made another color adjustment.


## 2023/12/22b - version: 0.9.2:

This release introduces improvements in the management of settings and data storage for the calculator, focusing on optimizing the persistence and retrieval of configuration information. Details of the changes:

* lib/common/models/app_settings_model.dart:
  - a simple class to maintain data loaded by Realms during the app's initialization, within the SettingsRepository class.
* lib/common/singletons/app_settings.dart:
  - added the _updateSettings() method to save changes in the calculator's attributes. A call to this method is made after each modification of properties that should be restored at app initialization;
  - added the loadRealmSettings() method to load data read by Realms during initialization;
  - added transformation methods _stringToThemeMode, _themeModeToString, _meanToInt, _intToMean, _deviationToInt, _intToDeviation;
  - added the toSettingsModel method to generate the AppSettingsModel and send it to the SettingsRepository.
* lib/database/model/settings.dart:
  - data model for Realms.
* lib/database/model/settings.g.dart:
  - automatically generated by the command 'dart run realm generate'.
* lib/database/settings_repository.dart:
  - a singleton to manage data stored in Realms;
  - the init() method currently just calls _openRealm();
  - the dispose() method closes the Realm database;
  - the _openRealm() method opens the Realm database;
  - the saveSettings(AppSettingsModel app) method saves the changes from the AppSettingsModel app in database record 1;
  - the loadSettings() method reads the database and stores information in the internal variable _settings.
* lib/features/calculator/calculator_page.dart:
  - initState() method added to CalculatorPage, scheduling a call to _app.updateAppSettings() after page load;
  - added a dispose() method to release the AppSettings.instance's NotifierValues and close the Realm database.
* lib/features/calculator/widgets/button_hub/reset_button.dart:
  - added a call to AppSettings.instance.reset() in the app's reset button.
* lib/features/splash/splash_page_controller.dart:
  - animation() method now includes a call to SettingsRepository.instance to initiate and load data from Realm.


## 2023/12/22 - version: 0.9.1:

In this update, we're introducing a range of enhancements and optimizations to the calculator's functionalities, particularly in mathematical expression processing, measure parsing, and statistical calculations, along with UI improvements. Here are the details:

* lib/common/models/math_expression/math_expression.dart:
  - added a filter to remove spaces in the mathematical expression;
  - introduced the _constantsEvaluator method to evaluate constants before starting the resolution of mathematical expressions.
* lib/common/models/measure/measure.dart:
  - added the tryParse method, to parse a string into a Measure;
  - modified outputs of the toString and toStringAsFixed methods to add parentheses.
* lib/common/models/measure/measure_functions.dart:
  - removed the dynamicStringParse method. No longer necessary.
* lib/common/models/measure/statistic.dart:
  - added a singleton StatisticController for statistical processing.
* lib/common/models/memories/app_memories.dart:
  - removed some unnecessary memories.
* lib/common/singletons/app_settings.dart:
  - AppSettings gained two more ValueNotifiers: expressionError$ and counter$. The former communicates errors in the mathematical expression, and the latter stores the number of elements in the statistical base.
* lib/common/themes/colors/app_colors.dart:
  - added some colors for fonts and buttons.
* lib/features/calculator/calculator_page.dart:
  - the theme selection button moved to the top bar of the main app page;
  - the DisplayWidget was moved inside a ListenableBuilder to trigger a red border in case of an error in processing a mathematical expression;
  - added a statistical counter display in the app's information bar.
* lib/features/calculator/widgets/button_hub/button_hub.dart:
  - added some comments to the code;
  - adjusted the equalKey method to work with memories;
  - in this method, an incorrect expression no longer clears the display but only lights up a red border to indicate an error in the operation.
  - added the _formatResult method to apply truncation or adjust decimal places when fix is configured;
  - made further adjustments in navigation with the pmMeasureKey method, now supporting scientific notation;
  - completed the implementation of the memoriesLettersKey method;
  - added the addStackKey method, to add new values to the statistical stack;
  - added the removeStackKey method, to remove the last value from the stack;
  - added the meanKey method to call the mean calculation;
  - added the clearStatKey method to clear the statistical stack;
  - added the _getCalculatorValue method to get the value from Ans, entered via display or evaluated from an expression on the display. These values are used in the entry of the statistical stack;
  - more color adjustments on buttons, images, and icons.
* lib/features/calculator/widgets/button_hub/calc_button.dart:
  - added support to select color for icons in CalcButton.
* lib/features/calculator/widgets/button_hub/reset_button.dart:
  - added calls to erase memories and statistical functions in the _resetCalculator method;
  - fixed the reset button icon color to white.
* lib/features/calculator/widgets/button_hub/utilities/create_button.dart:
  - adjusted the colors of some buttons.
* lib/features/calculator/widgets/display/display_widget.dart:
  - DisplayWidget now receives an errorMode boolean to trigger an error indicator border.
* lib/features/calculator/widgets/status_bar/status_bar_widget.dart:
  - completed the implementation of the statistical stack counter in the StatusBarWidget.
* lib/features/settings/settings_page.dart:
  - removed the theme selection button from the settings page.


## 2023/12/21b - version: 0.9.0:

This release introduces significant improvements in interacting with the expression history and managing memories, while laying the groundwork for additional functionalities. Details of the changes:

* lib/common/models/display/display_controller.dart:
  - _secondaryLine, secondaryLine: line from the secondary display to be posted on the primary display;
  - downSecondLine and upSecondLine select the line of the secondary display above and below;
  - selectHistoryLine scrolls to the selected line.
* lib/common/models/memories/app_memories.dart:
  - added the ValueNotifier<bool> storageOn$ to notify when the memory storage button is pressed.
  - added the toggleStorageOn() method to switch the state of storageOn.
* lib/common/themes/colors/app_colors.dart:
  - added color for the STO button's font when enabled.
* lib/features/calculator/widgets/button_hub/button_hub.dart:
  - added the memoriesKey method to enable and disable the STO button;
  - added the memoriesLettersKey method to manage input and access to memories. Implementation is still in progress;
  - CalcButton for the STO button was wrapped with a ListenableBuilder to display the state change.
* lib/features/calculator/widgets/button_hub/calc_button.dart:
  - added support for Tooltips, but not yet implemented.
* lib/features/calculator/widgets/button_hub/utilities/create_button.dart:
  - minor changes for the addition of tooltips, but not yet completed.
* lib/features/calculator/widgets/button_hub/utilities/display_utilities.dart: 
  - class renamed from DisplayControl to DisplayUtilities, to avoid confusion with DisplayController and be more precise in its application;
  - added the methods moveHistoryUp and moveHistoryDown to update the screen movement through the expression history.
* lib/features/calculator/widgets/display/display_widget.dart:
  - added a change in the color of the selected line from the expression history.


## 2023/12/21 - version: 0.8.0:

In this version, we have made significant improvements in the usability and maintenance of the calculator's code, introducing constants and enhanced methods for handling mathematical expressions and memories. Details of the changes:

* lib/common/constants/bottons_label.dart:
  - a set of constant strings to represent the control strings of the calculator keys. These are necessary to prevent incorrect writing of these strings throughout the code, as well as to reduce the possibility of errors in eventual changes to these strings.
* lib/common/constants/constants.dart:
  - addition of the 'dx' label.
* lib/common/models/math_expression/math_expression.dart:
  - added two .replaceAllMapped lines to the string newExpression to replace the sequence \dπ with \d*π and π\d with π*\d. This allows the insertion of 2π, or vice versa, without the need to put the product sign between them.
* lib/common/models/memories/app_memories.dart:
  - 'Ans' and 'xm' have been replaced with the constants ansLabel and xmLabel;
  - added calls via getters and setters for the memories.
* lib/features/calculator/widgets/button_hub/button_hub.dart:
  - improvements in the code of the insertKey method to encompass possible user inputs;
  - preOperatorsKey adds the previous answer (Ans) if one of the operation keys is pressed.
  - preAnsKey adds the previous answer (Ans) to the display if it is not null.
  - preNumbersKey: this method was initially created to process the addition of numbers to the display, inserting new numbers pressed in normal mode, or clearing the display and then adding the numbers to the display. However, this behavior proved necessary for the insertion of functions and is now used for entering numbers, functions, and possibly memory values.
  - pmMeasureKey, this method manages the press of the '±' key, moving through the elements of a Measure, or even creating one if executed between empty parentheses;
  - the method _itsBetween returns true if the passed position is between the outermost characters of the ER passed as a pattern;
  - the method _getMeasureElement(String text, int position) returns the Measure element not selected by the cursor. This method allows for switching between the elements of a Measure;
  - _checkMeasureInCursor(String text, int position), this method checks if the cursor is within a Measure sentence and, if so, returns the start and end positions of the sentence;
  - some more adjustments in the backSpaceKey method, to properly move through parentheses without breaking them in the expression;
  - otherwise, this code has been commented and applied with the new constants declared in buttons_labels.


## 2023/12/20 - version: 0.5.1:

This release enhances the mathematical expression processing and memory management of the calculator, introducing new methods for evaluation and data storage. Details of the changes:

* lib/common/models/math_expression/math_expression.dart:
  - in the parse method, support was added to accept the app's internal memories, functions with two variables, and Measure objects;
  - added the _functionEvaluator method to apply functions to the passed expression;
  - added the _measureEvaluator method to convert into Measure when the '±' token is encountered;
  - added the _memoriesEvaluator method to convert the app's memories into their numeric values;
  - the _basicSolve method applies these methods in the order _memoriesEvaluator -> _measureEvaluator -> _functionEvaluator. This ensures that all memories are applied, then the Measures are created, and finally the functions can be evaluated. Only after this will the remaining expression be solved.
* lib/common/models/memories/memory.dart:
  - added the Memory class to manage the app's memories.
* lib/common/models/memories/app_memories.dart:
  - added the singleton class AppMemories to manage the app's memories and possible constants.
* lib/features/calculator/widgets/button_hub/button_hub.dart:
  - the AppMemories class has been instantiated and is ready to be integrated into the app;
  - the equalKey method is storing the successfully executed expression and its result in the Ans memory.
* test/common/models/math_expression/math_expression_test.dart:
  - added tests for trigonometric functions in rad and deg;
  - added tests for functions with parameters;
  - added tests for functions with Measure.
* test/common/models/memories/app_memories_test.dart:
  - added tests for the app's memories.
* test/common/models/memories/memory_test.dart:
  - added tests for the Memory class.


## 2023/12/19 - version: 0.5.0

This release of version 0.5.0 brings comprehensive improvements and new functionalities to the calculator, focusing on advanced manipulation of mathematical expressions and enhancements to the user interface. The changes include enhancements to display controls, additional styles, and the introduction of methods for evaluating mathematical expressions. Details of the changes:

* lib/common/models/display/display_controller.dart:
  - adjusted control of the secondary display;
  - added method addInSecondaryDisplay, to add expressions to the secondary display;
  - added method resetSecondaryDisplay, to reset the control of the secondary display;
  - resetDisplay, added method to reset the entire display.
* lib/common/models/math_expression/math_expression.dart:
  - added the MathExpressionError error class;
  - added the dynamic evaluation() method, to evaluate the mathematical expression;
  - added the _findNextParentheses(List<dynamic> solve) method, to find the innermost pair of parentheses in an expression;
  - added the _basicSolve(List<dynamic>) method to solve mathematical expressions without parentheses.
* lib/common/themes/colors/app_colors.dart:
  - added color for the reset button.
* lib/common/themes/styles/app_button_styles.dart:
  - added the primaryButton style for dialog buttons.
* lib/common/themes/styles/app_text_styles.dart:
  - added the textStyleBold text style;
  - adjusted font sizes in some styles.
* lib/features/calculator/widgets/button_hub/button_hub.dart:
  - more adjustments in the insertKey method;
  - added the insertEEKey method, for the 'EE' key;
  - added the equalKey method, for the '=' key;
  - added the (int, int, TextSelection) selectionPositions() method to load the selection information of the main display;
  - mapped reset button for the calculator.
* lib/features/calculator/widgets/button_hub/calc_button.dart:
  - some adjustments in the CalcButton class for icon support.
* lib/features/calculator/widgets/button_hub/reset_button.dart:
  - addition of the ResetButton class to manage the interface reset process.
* lib/features/calculator/widgets/display/display_widget.dart:
  - added a font size control in the main display;
  - adjustments in the display layout.
* test/common/models/math_expression/math_expression_test.dart:
  - addition of unit tests for the evaluation method with expressions with and without parentheses.


## 2023/12/18c - version: 0.4.0:

This release introduces significant advancements in mathematical expression processing, including the creation of a function map and improvements in expression parsing. These changes aim to enhance the functionality and efficiency of the calculator. Details of the changes:

* lib/common/models/math_expression/function_map.dart:
  - creates a function map;
  - declares the CallFunction class, to register a function.
* lib/common/models/math_expression/math_expression.dart:
  - declares the MathExpression class to parse a string into a List<dynamic>, with numeric values, Measure, operators, and functions;
* lib/features/calculator/widgets/button_hub/button_hub.dart:
  - changed EE to 'e', used in scientific notations.
* test/common/models/math_expression/math_expression_test.dart:
  - added tests for the parsing of functions and expressions.

  
## 2023/12/18b - version: 0.3.2

This commit focuses on refactoring and reorganizing the code, bringing greater clarity and efficiency to the calculator's functionalities. The changes include the refactoring of the ButtonHub class into new, more specialized classes, as well as renaming functions for improved readability and maintainability. Details of the changes are as follows:

* lib/common/models/measure/measure.dart:
  - the pow10 function in measure_functions.dart was renamed to mathPow10, as it directly accesses the functions in math to define it.
* lib/common/models/measure/measure_functions.dart:
  - added an 'as math' to the math import;
  - added a direct call to math.pi's pi;
  - functions sqrt, pow, sin, cos, tan, asin, acos, atan, log, log10, exp, pow10, and abs had 'math.' added to their call;
  - numAdd renamed to addition;
  - numSub renamed to subtraction;
  - numMult renamed to multiplication;
  - numDiv renamed to division;
  - numAbs, numLn, numLog, numPow, numPowi, numPow2, numPow3, numPowi3, numPow10, numExp, numSqrt, numCos, numSin, numTan, numAcos, numAsin, numAtan were renamed to abs, ln, log, pow, powi, pow2, pow3, sqr3, pow10, exp, sqr, cos, sin, tan, acos, asin, atan.
* lib/features/calculator/widgets/button_hub/button_hub.dart:
  - this code was refactored, generating the StringEdit, DisplayControl, and CreateButton classes;
  - various methods were renamed from _nameButton to nameKey, aiming to manage key presses.
* lib/features/calculator/widgets/button_hub/utilities/create_button.dart:
  - class specialized in creating buttons.
* lib/features/calculator/widgets/button_hub/utilities/display_control.dart:
  - class specialized in controlling the cursor movement and the update of the display's TextEditingController.
* lib/features/calculator/widgets/button_hub/utilities/string_edit.dart:
  - class specialized in editing and manipulating the display string content.
* test/common/models/measure_functions_test.dart:
  - all tests were updated and tested.


## 2023/12/18 - version 0.3.1:
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


## 2023/12/15 - version 0.3.0:

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

