import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/l10n/generated/l10n.dart';

class WidgetBuild {
  static SnackBar snackBar(String message, [Duration? duration]) {
    return SnackBar(
      content: Text(
        message,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  static Widget buildPopupMenuButton({
    required BuildContext context,
    required List<PopupMenuItem<String>> items,
    required void Function(String) onItemSelected,
  }) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => items,
      onSelected: onItemSelected,
    );
  }

  static PopupMenuItem<String> buildPopupMenuItem({
    required String value,
    required Widget child,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: child,
    );
  }

  static Widget buildCheckboxCard(
    bool value,
    String title,
    void Function(bool?)? onChanged,
  ) {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    return ListTile(
      shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
      title: Text(title),
      trailing: Container(
        alignment: Alignment.centerRight,
        width: 20,
        child: Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ),
      onTap: () {
        onChanged!(!value);
      },
    );
  }

  static Widget buildTextCard(
    String value,
    String title,
    void Function(String?) update,
    BuildContext context,
  ) {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    return ListTile(
      shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
      title: Text(title),
      trailing: Text(value),
      onTap: () async {
        TextEditingController controller = TextEditingController();
        controller.text = value;
        String? newValue = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: TextFormField(
                controller: controller,
              ),
              actions: [
                TextButton(
                  child: Text(S.of(context).cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(S.of(context).save),
                  onPressed: () {
                    Navigator.of(context).pop(controller.text);
                  },
                ),
              ],
            );
          },
        );
        update(newValue);
      },
    );
  }

  static Widget buildItemsCard(
    String value,
    String title,
    List<String> items,
    void Function(String?) update,
    BuildContext context,
  ) {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    return ListTile(
      shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
      title: Text(title),
      trailing: Text(value),
      onTap: () async {
        String? newValue = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: double.minPositive,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(items[index]),
                      trailing: Icon(
                        items[index] == value ? Icons.check : null,
                      ),
                      onTap: () {
                        Navigator.of(context).pop(items[index]);
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
        update(newValue);
      },
    );
  }

  static Widget buildColorsCard(
    int value,
    String title,
    Map<int, String> items,
    void Function(int?) update,
    BuildContext context,
  ) {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    return ListTile(
      shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
      title: Text(title),
      trailing: Text(
        "❖ ${items[value] ?? "Sphia"}",
        style: TextStyle(
          color: Color(value),
        ),
      ),
      onTap: () async {
        int? newValue = await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: double.minPositive,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    final color = items.keys.elementAt(index);
                    return ListTile(
                      title: Text(
                        "❖ ${items[color]}",
                        style: TextStyle(
                          color: Color(color),
                        ),
                      ),
                      trailing: Icon(
                        color == value ? Icons.check : null,
                      ),
                      onTap: () {
                        Navigator.of(context).pop(items.keys.elementAt(index));
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
        update(newValue);
      },
    );
  }

  static Widget buildTextFormField(
    TextEditingController controller,
    String labelText,
    String? Function(String?)? validator,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
    );
  }

  static Widget buildPasswordTextFormField(
    TextEditingController controller,
    String labelText,
    String? Function(String?)? validator,
    bool obscureText,
    ValueChanged<bool> onToggle,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            onToggle(!obscureText);
          },
        ),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }

  static Widget buildDropdownButtonFormField(
    String value,
    String labelText,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: labelText),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
