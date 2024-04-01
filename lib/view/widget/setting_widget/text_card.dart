import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/l10n/generated/l10n.dart';

class TextCard extends ConsumerWidget {
  final String title;
  final String Function(SphiaConfig value) selector;
  final void Function(String value) updater;
  final bool enabled;

  const TextCard({
    super.key,
    required this.title,
    required this.selector,
    required this.updater,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useMaterial3 = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.useMaterial3));
    final value = ref.watch(sphiaConfigNotifierProvider.select(selector));
    return ListTile(
      enabled: enabled,
      shape: SphiaTheme.listTileShape(useMaterial3),
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
        if (newValue != null) {
          updater(newValue);
        }
      },
    );
  }
}
