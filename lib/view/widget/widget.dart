import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/l10n/generated/l10n.dart';

class SphiaWidget {
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

  static Widget popupMenuButton({
    required BuildContext context,
    required List<PopupMenuItem<String>> items,
    required void Function(String) onItemSelected,
  }) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => items,
      onSelected: onItemSelected,
    );
  }

  static PopupMenuItem<String> popupMenuItem({
    required String value,
    required Widget child,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: child,
    );
  }

  static Widget checkboxCard(
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

  static Widget textCard(
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

  static Widget itemsCard(
    int value,
    String title,
    List<String> items,
    void Function(int?) update,
    BuildContext context,
  ) {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    return ListTile(
      shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
      title: Text(title),
      trailing: Text(items[value]),
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
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
                      title: Text(items[index]),
                      trailing: Icon(
                        index == value ? Icons.check : null,
                      ),
                      onTap: () {
                        Navigator.of(context).pop(index);
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

  static Widget colorsCard(
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
                      shape: SphiaTheme.listTileShape(sphiaConfig.useMaterial3),
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

  static Widget textInput(
    TextEditingController controller,
    String labelText,
    String? Function(String?)? validator, [
    bool isEditable = true,
  ]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
      enabled: isEditable,
    );
  }

  static Widget passwordTextInput(
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

  static Widget dropdownButton(
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

  static Widget routingDropdownButton(
    int? value,
    String labelText,
    void Function(int?) onChanged,
  ) {
    final items = List<String>.from(routingProviderList);
    items.insert(0, '');
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: labelText),
      value: items[value != null ? value + 1 : 0],
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) {
          onChanged(null);
        } else {
          final index = items.indexOf(value);
          onChanged(index != 0 ? index - 1 : null);
        }
      },
    );
  }

  static Widget vmessDropdownButton(
    int? value,
    String labelText,
    void Function(int?) onChanged,
  ) {
    final items = List<String>.from(vmessProviderList);
    items.insert(0, '');
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: labelText),
      value: items[value != null ? value + 1 : 0],
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) {
          onChanged(null);
        } else {
          final index = items.indexOf(value);
          onChanged(index != 0 ? index - 1 : null);
        }
      },
    );
  }

  static Widget vlessDropdownButton(
    int? value,
    String labelText,
    void Function(int?) onChanged,
  ) {
    final items = List<String>.from(vlessProviderList);
    items.insert(0, '');
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: labelText),
      value: items[value != null ? value + 1 : 0],
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) {
          onChanged(null);
        } else {
          final index = items.indexOf(value);
          onChanged(index != 0 ? index - 1 : null);
        }
      },
    );
  }

  static Widget shadowsocksDropdownButton(
    int? value,
    String labelText,
    void Function(int?) onChanged,
  ) {
    final items = List<String>.from(shadowsocksProviderList);
    items.insert(0, '');
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: labelText),
      value: items[value != null ? value + 1 : 0],
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) {
          onChanged(null);
        } else {
          final index = items.indexOf(value);
          onChanged(index != 0 ? index - 1 : null);
        }
      },
    );
  }

  static Widget trojanDropdownButton(
    int? value,
    String labelText,
    void Function(int?) onChanged,
  ) {
    final items = List<String>.from(trojanProviderList);
    items.insert(0, '');
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: labelText),
      value: items[value != null ? value + 1 : 0],
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) {
          onChanged(null);
        } else {
          final index = items.indexOf(value);
          onChanged(index != 0 ? index - 1 : null);
        }
      },
    );
  }

  static Widget hysteriaDropdownButton(
    int? value,
    String labelText,
    void Function(int?) onChanged,
  ) {
    final items = List<String>.from(hysteriaProviderList);
    items.insert(0, '');
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: labelText),
      value: items[value != null ? value + 1 : 0],
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) {
          onChanged(null);
        } else {
          final index = items.indexOf(value);
          onChanged(index != 0 ? index - 1 : null);
        }
      },
    );
  }
}

const navigationStyleList = ['rail', 'drawer'];
const userAgentList = ['chrome', 'firefox', 'safari', 'edge', 'none'];
const domainStrategyList = ['AsIs', 'IPIfNonMatch', 'IPOnDemand'];
const domainMatcherList = ['hybrid', 'linear'];
const logLevelList = ['none', 'warning', 'debug', 'error', 'info'];
const routingProviderList = ['sing-box', 'xray-core'];
const vmessProviderList = ['sing-box', 'xray-core'];
const vlessProviderList = ['sing-box', 'xray-core'];
const shadowsocksProviderList = ['sing-box', 'xray-core', 'shadowsocks-rust'];
const trojanProviderList = ['sing-box', 'xray-core'];
const hysteriaProviderList = ['sing-box', 'hysteria'];
const tunProviderList = ['sing-box'];
const tunStackList = ['system', 'gvisor'];
