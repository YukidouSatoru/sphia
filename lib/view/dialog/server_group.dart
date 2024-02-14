import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/widget/widget.dart';

class ServerGroupDialog extends StatefulWidget {
  final String title;
  final Map<String, dynamic> serverGroupMap;

  const ServerGroupDialog({
    super.key,
    required this.title,
    required this.serverGroupMap,
  });

  @override
  State<StatefulWidget> createState() => _ServerGroupDialogState();
}

class _ServerGroupDialogState extends State<ServerGroupDialog> {
  final groupNameController = TextEditingController();
  final subscriptionController = TextEditingController();
  bool fetchSubscription = false;
  late final bool isEdit;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    groupNameController.text = widget.serverGroupMap['groupName']!;
    subscriptionController.text = widget.serverGroupMap['subscription']!;
    isEdit = widget.serverGroupMap['groupName']!.isNotEmpty;
  }

  @override
  void dispose() {
    groupNameController.dispose();
    subscriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(widget.title),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SphiaWidget.textInput(
              controller: groupNameController,
              labelText: S.of(context).groupName,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return S.current.groupNameEnterMsg;
                }
                return null;
              },
            ),
            SphiaWidget.textInput(
              controller: subscriptionController,
              labelText: S.of(context).subscription,
            ),
            if (!isEdit)
              SphiaWidget.dropdownButton(
                value: S.of(context).no,
                labelText: S.of(context).fetchSubscription,
                items: [S.of(context).no, S.of(context).yes],
                onChanged: (value) {
                  if (value != null) {
                    fetchSubscription = value == S.of(context).yes;
                  }
                },
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(S.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(S.of(context).save),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.of(context).pop(
                {
                  'groupName': groupNameController.text.trim(),
                  'subscription': subscriptionController.text.trim(),
                  'fetchSubscription': fetchSubscription,
                },
              );
            }
          },
        ),
      ],
    );
  }
}
