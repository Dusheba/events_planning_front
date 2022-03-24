import 'package:events_planning/data/client.dart';
import 'package:events_planning/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../utils/app_theme.dart';

/// A Custom Dialog that displays a single question & list of answers.
class MultiSelectDialog extends StatelessWidget {
  /// List to display the answer.
  final List<Client> answers;

  final Widget question;
  final List<Client> selectedItems = [];
  static Map<Client, bool>? mappedItem;
  TextEditingController searchController = TextEditingController();

  MultiSelectDialog({Key? key, required this.answers, required this.question}) : super(key: key);

  /// Function that converts the list answer to a map.
  Map<Client, bool> initMap() {
    print(answers);
    return mappedItem = Map.fromIterable(answers,
        key: (k) => k,
        value: (v) {
          if (v != true && v != false)
            return false;
          else
            return v as bool;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (mappedItem == null) {
      initMap();
    }
    return SimpleDialog(
      title: question,
      contentPadding: EdgeInsets.all(10),
      children: [
        TextFormField(
          style: AppTheme.eventPanelHeadline.withBlack,
          controller: searchController,
          decoration: InputDecoration(
              hintText: 'Введите имя...',
              hintStyle: AppTheme.hintsText,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(
                      color: AppTheme.borderPurple
                  )
              )
          ),
        ),
        ...mappedItem!.keys.map((Client key) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) => CheckboxListTile(
                title: Text(key.username), // Displays the option
                value: mappedItem![key], // Displays checked or unchecked value
                controlAffinity: ListTileControlAffinity.platform,
                onChanged: (value) => setState(() => mappedItem![key] = value!)),
          );
        }).toList(),
        Align(
            alignment: Alignment.center,
            child: ElevatedButton(
                style: ButtonStyle(visualDensity: VisualDensity.comfortable,
                    backgroundColor: MaterialStateProperty.all<Color>(AppTheme.bottomAddSheetDate)),
                child: Text('Пригласить'),
                onPressed: () {
                  // Clear the list
                  selectedItems.clear();

                  // Traverse each map entry
                  mappedItem!.forEach((key, value) {
                    if (value == true) {
                      selectedItems.add(key);
                    }
                  });

                  // Close the Dialog & return selectedItems
                  Navigator.pop(context, selectedItems);
                }))
      ],
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<Client, bool>>('mappedItem', mappedItem));
    properties.add(DiagnosticsProperty<Map<Client, bool>>('mappedItem', mappedItem));
  }
}