import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/theme.dart';

class CheckboxCard extends ConsumerWidget {
  final String title;
  final bool Function(SphiaConfig value) selector;
  final void Function(bool value) updater;
  final bool enabled;

  const CheckboxCard({
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
      trailing: Container(
        alignment: Alignment.centerRight,
        width: 20,
        child: Checkbox(
          value: value,
          onChanged: enabled ? (value) => updater(value!) : null,
        ),
      ),
      onTap: enabled ? () => updater(!value) : null,
    );
  }
}
