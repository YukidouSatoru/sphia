import 'package:flutter/material.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/widget/widget.dart';

class RuleDialog extends StatefulWidget {
  final String title;
  final Rule rule;

  const RuleDialog({
    super.key,
    required this.title,
    required this.rule,
  });

  @override
  State<StatefulWidget> createState() => _RuleDialogState();
}

class _RuleDialogState extends State<RuleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _inboundTagController = TextEditingController();
  final _outboundTagController = TextEditingController();
  final _domainController = TextEditingController();
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  final _processNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widgets = [
      SphiaWidget.textInput(
        _nameController,
        S.of(context).name,
        (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).nameEnterMsg;
          }
          return null;
        },
      ),
      SphiaWidget.textInput(
        _inboundTagController,
        'Inbound Tag',
        null,
        false,
      ),
      SphiaWidget.textInput(
        _outboundTagController,
        'Outbound Tag',
        null,
      ),
      SphiaWidget.textInput(
        _domainController,
        'Domain',
        null,
      ),
      SphiaWidget.textInput(
        _ipController,
        'IP',
        null,
      ),
      SphiaWidget.textInput(
        _portController,
        'Port',
        null,
      ),
      SphiaWidget.textInput(
        _processNameController,
        'Process Name',
        null,
      ),
    ];
    return AlertDialog(
      title: Text(widget.title),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              final rule = Rule(
                id: widget.rule.id,
                groupId: widget.rule.groupId,
                enabled: widget.rule.enabled,
                name: _nameController.text,
                inboundTag: _inboundTagController.text.isEmpty
                    ? null
                    : _inboundTagController.text,
                outboundTag: _outboundTagController.text.isEmpty
                    ? null
                    : _outboundTagController.text,
                domain: _domainController.text.isEmpty
                    ? null
                    : _domainController.text,
                ip: _ipController.text.isEmpty ? null : _ipController.text,
                port:
                    _portController.text.isEmpty ? null : _portController.text,
                processName: _processNameController.text.isEmpty
                    ? null
                    : _processNameController.text,
              );
              Navigator.pop(context, rule);
            }
          },
          child: Text(S.of(context).save),
        ),
      ],
    );
  }

  void _initControllers() {
    _nameController.text = widget.rule.name;
    _inboundTagController.text = widget.rule.inboundTag ?? '';
    _outboundTagController.text = widget.rule.outboundTag ?? '';
    _domainController.text = widget.rule.domain ?? '';
    _ipController.text = widget.rule.ip ?? '';
    _portController.text = widget.rule.port ?? '';
    _processNameController.text = widget.rule.processName ?? '';
  }

  void _disposeControllers() {
    _nameController.dispose();
    _inboundTagController.dispose();
    _outboundTagController.dispose();
    _domainController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _processNameController.dispose();
  }
}
