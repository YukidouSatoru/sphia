import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/view/widget/widget.dart';

class TrojanServerDialog extends StatefulWidget {
  final String title;
  final TrojanServer server;

  const TrojanServerDialog({
    Key? key,
    required this.title,
    required this.server,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrojanServerDialogState();
}

class _TrojanServerDialogState extends State<TrojanServerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _remarkController = TextEditingController();
  final _addressController = TextEditingController();
  final _portController = TextEditingController();
  final _passwordController = TextEditingController();
  final _sniController = TextEditingController();
  final _fingerPrintController = TextEditingController();
  final _allowInsecureController = TextEditingController();
  bool _obscureText = true;

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
      WidgetBuild.buildTextFormField(
          _remarkController, S.of(context).remark, null),
      WidgetBuild.buildTextFormField(
        _addressController,
        S.of(context).address,
        (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).addressEnterMsg;
          }
          return null;
        },
      ),
      WidgetBuild.buildTextFormField(
        _portController,
        S.of(context).port,
        (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).portEnterMsg;
          }
          late final int? newValue;
          if ((newValue = int.tryParse(value)) == null ||
              newValue! < 0 ||
              newValue > 65535) {
            return S.of(context).portInvalidMsg;
          }
          return null;
        },
      ),
      WidgetBuild.buildPasswordTextFormField(
        _passwordController,
        S.of(context).password,
        (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).passwordEnterMsg;
          }
          return null;
        },
        _obscureText,
        (value) {
          setState(() {
            _obscureText = value;
          });
        },
      ),
      WidgetBuild.buildTextFormField(_sniController, S.of(context).sni, null),
      WidgetBuild.buildDropdownButtonFormField(
        _fingerPrintController.text,
        S.of(context).fingerPrint,
        [
          'none',
          'random',
          "randomized",
          'chrome',
          'firefox',
          'safari',
          'ios',
          'android',
          'edge',
          '360',
          'qq'
        ],
        (value) {
          if (value != null) {
            setState(() {
              _fingerPrintController.text = value;
            });
          }
        },
      ),
      WidgetBuild.buildDropdownButtonFormField(
        _allowInsecureController.text,
        S.of(context).allowInsecure,
        ['false', 'true'],
        (value) {
          if (value != null) {
            setState(() {
              _allowInsecureController.text = value;
            });
          }
        },
      ),
    ];

    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          ),
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
              final server = TrojanServer(
                protocol: widget.server.protocol,
                address: _addressController.text,
                port: int.parse(_portController.text),
                remark: _remarkController.text,
                password: _passwordController.text,
                serverName: _sniController.text.trim().isNotEmpty
                    ? _sniController.text
                    : null,
                fingerPrint: _fingerPrintController.text != 'none'
                    ? _fingerPrintController.text
                    : null,
                allowInsecure: _allowInsecureController.text == 'true',
              );
              Navigator.pop(context, server);
            }
          },
          child: Text(S.of(context).save),
        ),
      ],
    );
  }

  void _initControllers() {
    final server = widget.server;
    _remarkController.text = server.remark;
    _addressController.text = server.address;
    _portController.text = server.port.toString();
    _passwordController.text = server.password;
    _sniController.text = server.serverName ?? '';
    _fingerPrintController.text = server.fingerPrint ?? 'chrome';
    _allowInsecureController.text = server.allowInsecure.toString();
  }

  void _disposeControllers() {
    _remarkController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _passwordController.dispose();
    _sniController.dispose();
    _fingerPrintController.dispose();
    _allowInsecureController.dispose();
  }
}
