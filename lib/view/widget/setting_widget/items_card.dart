import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/theme.dart';

class ItemsCard extends ConsumerWidget {
  final String title;
  final List<String> items;
  final int Function(SphiaConfig value) selector;
  final void Function(int value) updater;

  const ItemsCard({
    super.key,
    required this.title,
    required this.items,
    required this.selector,
    required this.updater,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useMaterial3 = ref.watch(
        sphiaConfigNotifierProvider.select((value) => value.useMaterial3));
    final value = ref.watch(sphiaConfigNotifierProvider.select(selector));
    return ListTile(
      shape: SphiaTheme.listTileShape(useMaterial3),
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
                      shape: SphiaTheme.listTileShape(useMaterial3),
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
        if (newValue != null) {
          updater(newValue);
        }
      },
    );
  }
}
