import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/rule/mixed.dart';
import 'package:sphia/view/widget/widget.dart';

class RuleDialog extends StatefulWidget {
  final String title;
  final MixedRule rule;

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
              final rule = MixedRule(
                name: _nameController.text,
                enabled: widget.rule.enabled,
                inboundTag: _inboundTagController.text,
                outboundTag: _outboundTagController.text,
                domain: _domainController.text.trim().isNotEmpty
                    ? _domainController.text.trim().split(',')
                    : null,
                ip: _ipController.text.trim().isNotEmpty
                    ? _ipController.text.trim().split(',')
                    : null,
                port: _portController.text.trim().isNotEmpty
                    ? _portController.text.trim().split(',')
                    : null,
                processName: _processNameController.text.trim().isNotEmpty
                    ? _processNameController.text.trim().split(',')
                    : null,
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
    _domainController.text = widget.rule.domain?.join(',') ?? '';
    _ipController.text = widget.rule.ip?.join(',') ?? '';
    _portController.text = widget.rule.port?.join(',') ?? '';
    _processNameController.text = widget.rule.processName?.join(',') ?? '';
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
