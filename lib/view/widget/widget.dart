import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/l10n/generated/l10n.dart';

class SphiaWidget {
  static Widget iconButton({
    required IconData icon,
    required void Function()? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon),
        ),
      ),
    );
  }

  static Widget popupMenuIconButton({
    required IconData icon,
    required List<PopupMenuEntry<String>> items,
    required void Function(String) onItemSelected,
  }) {
    return Builder(
      builder: (context) => iconButton(
        icon: icon,
        onTap: () async {
          final renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          final result = await showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              position.dx,
              position.dy,
              position.dx + renderBox.size.width,
              position.dy + renderBox.size.height,
            ),
            items: items,
          );
          if (result != null) {
            onItemSelected(result.toString());
          }
        },
      ),
    );
  }

  static SnackBar snackBar(String message) {
    return SnackBar(
      content: Text(
        message,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      duration: const Duration(seconds: 5),
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

  static Widget textInput({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    bool isEditable = true,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
      enabled: isEditable,
    );
  }

  static Widget passwordTextInput({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    required bool obscureText,
    required ValueChanged<bool> onToggle,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: iconButton(
          icon: obscureText ? Icons.visibility : Icons.visibility_off,
          onTap: () => onToggle(!obscureText),
        ),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }

  static Widget pathInput({
    required TextEditingController controller,
    required String labelText,
    required String configFromat,
    String? Function(String?)? validator,
    required String editorPath,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconButton(
              icon: Icons.folder,
              onTap: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: [configFromat],
                  allowMultiple: false,
                );
                if (result != null && result.files.isNotEmpty) {
                  final path = result.files.first.path;
                  if (path != null) {
                    controller.text = path;
                  }
                }
              },
            ),
            popupMenuIconButton(
              icon: Icons.edit,
              items: [
                const PopupMenuItem(
                  value: 'kate',
                  child: Text('kate'),
                ),
                const PopupMenuItem(
                  value: 'notepad',
                  child: Text('notepad'),
                ),
                PopupMenuItem(
                  value: editorPath,
                  child: Text(editorPath),
                ),
              ],
              onItemSelected: (value) async {
                final path = controller.text;
                if (path.isEmpty) {
                  logger.w('Path is empty');
                  return;
                }
                final pathEnv = Platform.environment['PATH'];
                final paths = pathEnv?.split(':') ?? [];
                final isPath = paths.any((element) => value.contains(element));
                if (isPath) {
                  try {
                    await Process.start(value, [controller.text]);
                  } catch (e) {
                    logger.e('Failed to open file: $e');
                  }
                } else {
                  logger.e('Invalid editor path: $value');
                }
              },
            ),
          ],
        ),
      ),
      validator: validator,
    );
  }

  static Widget dropdownButton({
    required String value,
    required String labelText,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
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

  static Widget routingDropdownButton({
    required int? value,
    required String labelText,
    required void Function(int?) onChanged,
  }) {
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

  static Widget vmessDropdownButton({
    required int? value,
    required String labelText,
    required void Function(int?) onChanged,
  }) {
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

  static Widget vlessDropdownButton({
    required int? value,
    required String labelText,
    required void Function(int?) onChanged,
  }) {
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

  static Widget shadowsocksDropdownButton({
    required int? value,
    required String labelText,
    required void Function(int?) onChanged,
  }) {
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

  static Widget trojanDropdownButton({
    required int? value,
    required String labelText,
    required void Function(int?) onChanged,
  }) {
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

  static Widget hysteriaDropdownButton({
    required int? value,
    required String labelText,
    required void Function(int?) onChanged,
  }) {
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

  static Widget customConfigServerDropdownButton({
    required int value,
    required String labelText,
    required void Function(int) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: labelText),
      value: customServerProviderList[value],
      items: customServerProviderList.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          final index = customServerProviderList.indexOf(value);
          onChanged(index);
        }
      },
    );
  }

  static Future<void> showDialogWithMsg({
    required BuildContext context,
    required String message,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 4),
            child: Text(message, style: const TextStyle(fontSize: 14)),
          ),
          actions: [
            TextButton(
              child: Text(S.of(context).ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
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
const customServerProviderList = ['sing-box', 'xray-core', 'hysteria'];
const tunProviderList = ['sing-box'];
const tunStackList = ['system', 'gvisor', 'mixed'];
