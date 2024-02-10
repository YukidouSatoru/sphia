import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/widget/widget.dart';

class RuleGroupDialog extends StatefulWidget {
  final String title;
  final String groupName;

  const RuleGroupDialog({
    super.key,
    required this.title,
    required this.groupName,
  });

  @override
  State<StatefulWidget> createState() => _RuleGroupDialogState();
}

class _RuleGroupDialogState extends State<RuleGroupDialog> {
  final groupNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    groupNameController.text = widget.groupName;
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      scrollable: true,
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SphiaWidget.textInput(
              groupNameController,
              S.of(context).groupName,
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return S.of(context).groupNameEnterMsg;
                }
                return null;
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
                groupNameController.text.trim(),
              );
            }
          },
        ),
      ],
    );
  }
}
