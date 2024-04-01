import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/core/updater.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/view/card/core_card.dart';
import 'package:sphia/view/page/agent/update.dart';
import 'package:sphia/view/widget/widget.dart';
import 'package:sphia/view/wrapper/page.dart';

class UpdatePage extends ConsumerWidget with UpdateAgent {
  const UpdatePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBar = AppBar(
      title: Text(
        S.of(context).update,
      ),
      elevation: 0,
      actions: [
        Builder(
          builder: (context) => SphiaWidget.popupMenuButton(
            context: context,
            items: [
              PopupMenuItem(
                value: 'ScanCores',
                child: Text(S.of(context).scanCores),
              ),
              PopupMenuItem(
                value: 'ImportCore',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).import),
                    const Icon(Icons.arrow_left),
                  ],
                ),
              ),
            ],
            onItemSelected: (value) async {
              switch (value) {
                case 'ScanCores':
                  await ref.read(coreUpdaterProvider.notifier).scanCores();
                  if (context.mounted) {
                    await SphiaWidget.showDialogWithMsg(
                      context: context,
                      message: S.of(context).scanCoresCompleted,
                    );
                  }
                  break;
                case 'ImportCore':
                  final renderBox = context.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx,
                      position.dy,
                      position.dx + renderBox.size.width,
                      position.dy + renderBox.size.height,
                    ),
                    items: [
                      PopupMenuItem(
                        value: 'SingleCore',
                        child: Text(S.of(context).singleCore),
                      ),
                      PopupMenuItem(
                        value: 'MutilpleCores',
                        child: Text(S.of(context).multipleCores),
                      ),
                    ],
                  ).then((value) async {
                    if (value == null) {
                      return;
                    }
                    switch (value) {
                      case 'SingleCore':
                        final res = await ref
                            .read(coreUpdaterProvider.notifier)
                            .importCore(isMulti: false);
                        if (res == null || !context.mounted) {
                          return;
                        }
                        if (res) {
                          await SphiaWidget.showDialogWithMsg(
                            context: context,
                            message: S.of(context).importCoreSuccessfully,
                          );
                        } else {
                          await SphiaWidget.showDialogWithMsg(
                            context: context,
                            message: S.of(context).importCoreFailed,
                          );
                        }
                        break;
                      case 'MutilpleCores':
                        final res = await ref
                            .read(coreUpdaterProvider.notifier)
                            .importCore(isMulti: true);
                        if (res == null) {
                          return;
                        }
                        if (res) {
                          await ref
                              .read(coreUpdaterProvider.notifier)
                              .scanCores();
                          if (!context.mounted) {
                            return;
                          }
                          await SphiaWidget.showDialogWithMsg(
                            context: context,
                            message: S.of(context).importMultiCoresMsg(binPath),
                          );
                        }
                        break;
                      default:
                        break;
                    }
                  });
                  break;
                default:
                  break;
              }
            },
          ),
        )
      ],
    );
    final coreInfoList = ref.watch(coreInfoListProvider);
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: appBar,
        body: PageWrapper(
          child: ListView.builder(
            itemCount: coreInfoList.length,
            itemBuilder: (BuildContext context, int index) {
              final info = coreInfoList[index];
              return ProviderScope(
                overrides: [
                  currentCoreProvider.overrideWithValue(info),
                ],
                child: const CoreInfoCard(),
              );
            },
          ),
        ),
      ),
    );
  }
}
