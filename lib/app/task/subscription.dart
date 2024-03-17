import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/task/task.dart';
import 'package:sphia/app/tray.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/uri/uri.dart';
import 'package:sphia/view/widget/widget.dart';

class SubscriptionTask {
  static const name = 'Update Subscription';

  static Task generate() {
    return Task(
      name,
      updateSubscriptionDuration(),
      updateSubscriptions,
    );
  }

  static Duration updateSubscriptionDuration() {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final serverConfig = GetIt.I.get<ServerConfigProvider>().config;
    late final Duration duration;
    if (serverConfig.updatedSubscriptionTime == 0) {
      // first time
      updateSubscriptions(showDialog: false);
      duration = Duration(minutes: sphiaConfig.updateSubscriptionInterval);
    } else {
      final interval = DateTime.now()
          .difference(
            DateTime.fromMillisecondsSinceEpoch(
              serverConfig.updatedSubscriptionTime,
            ),
          )
          .inMinutes;
      if (interval >= sphiaConfig.updateSubscriptionInterval) {
        // if the interval is greater than the update interval
        // update the subscriptions immediately
        updateSubscriptions(showDialog: false);
        duration = Duration(minutes: sphiaConfig.updateSubscriptionInterval);
      } else {
        // update the subscriptions after the remaining time
        duration = Duration(
            minutes: sphiaConfig.updateSubscriptionInterval - interval);
      }
    }
    return duration;
  }

  static Future<bool> updateSubscriptions({
    required bool showDialog,
    BuildContext? context,
  }) async {
    logger.i('Updating All Server Groups');
    int count = 0;
    bool flag = false; // if any group is updated
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    serverConfigProvider.config.updatedSubscriptionTime =
        DateTime.now().millisecondsSinceEpoch;
    final serverGroups = await serverGroupDao.getOrderedServerGroups();
    for (var serverGroup in serverGroups) {
      final subscription = serverGroup.subscription;
      if (subscription.isEmpty) {
        continue;
      }
      logger.i('Updating Server Group: ${serverGroup.name}');
      try {
        await UriUtil.updateSingleGroup(serverGroup.id, subscription);
        flag = true;
        count++;
      } on Exception catch (e) {
        logger.e('Failed to update group: ${serverGroup.name}\n$e');
        continue;
      }
    }
    final shouldShowDialog = showDialog && context != null;
    if (shouldShowDialog && context.mounted) {
      final total = serverGroups.length;
      SphiaWidget.showDialogWithMsg(
        context,
        S.of(context).numSubscriptionsHaveBeenUpdated(count, total),
      );
    }
    if (flag) {
      serverConfigProvider.servers =
          await serverDao.getOrderedServerModelsByGroupId(
              serverConfigProvider.config.selectedServerGroupId);
      // remember to update the server items in the tray
      SphiaTray.generateServerItems();
      SphiaTray.setMenu();
    }
    serverConfigProvider.saveConfig();
    return flag;
  }
}
