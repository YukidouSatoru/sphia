import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/theme.dart';
import 'package:sphia/l10n/generated/l10n.dart';

class ColorsCard extends ConsumerWidget {
  final Map<int, String> items;
  final void Function(int value) updater;

  const ColorsCard({
    super.key,
    required this.items,
    required this.updater,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useMaterial3 = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.useMaterial3));
    final value = ref
        .watch(sphiaConfigNotifierProvider.select((value) => value.themeColor));
    return ListTile(
      shape: SphiaTheme.listTileShape(useMaterial3),
      title: Text(S.of(context).themeColor),
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
              title: Text(S.of(context).themeColor),
              content: SizedBox(
                width: double.minPositive,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final color = items.keys.elementAt(index);
                    return ListTile(
                      shape: SphiaTheme.listTileShape(useMaterial3),
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
        if (newValue != null) {
          updater(newValue);
        }
      },
    );
  }
}
