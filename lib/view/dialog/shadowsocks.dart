import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/view/widget/widget.dart';

const shadowsocksEncryption = [
  'none',
  'plain',
  'aes-128-gcm',
  'aes-192-gcm',
  'aes-256-gcm',
  'chacha20-ietf-poly1305',
  'xchacha20-ietf-poly1305',
  '2022-blake3-aes-128-gcm',
  '2022-blake3-aes-256-gcm',
  '2022-blake3-chacha20-poly1305',
  'aes-128-ctr',
  'aes-192-ctr',
  'aes-256-ctr',
  'aes-128-cfb',
  'aes-192-cfb',
  'aes-256-cfb',
  'rc4-md5',
  'chacha20-ietf',
  'xchacha20',
];

class ShadowsocksServerDialog extends StatefulWidget {
  final String title;
  final Server server;

  const ShadowsocksServerDialog({
    super.key,
    required this.title,
    required this.server,
  });

  @override
  State<StatefulWidget> createState() => _ShadowsocksServerDialogState();
}

class _ShadowsocksServerDialogState extends State<ShadowsocksServerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _remarkController = TextEditingController();
  final _addressController = TextEditingController();
  final _portController = TextEditingController();
  final _passwordController = TextEditingController();
  late String _encryption;
  final _pluginController = TextEditingController();
  final _pluginOptsController = TextEditingController();
  int? _routingProvider;
  int? _protocolProvider;
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
      SphiaWidget.textInput(
        controller: _remarkController,
        labelText: S.of(context).remark,
      ),
      SphiaWidget.textInput(
        controller: _addressController,
        labelText: S.of(context).address,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).addressEnterMsg;
          }
          return null;
        },
      ),
      SphiaWidget.textInput(
        controller: _portController,
        labelText: S.of(context).port,
        validator: (value) {
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
      SphiaWidget.passwordTextInput(
        controller: _passwordController,
        labelText: S.of(context).password,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).passwordEnterMsg;
          }
          return null;
        },
        obscureText: _obscureText,
        onToggle: (value) {
          setState(() {
            _obscureText = value;
          });
        },
      ),
      SphiaWidget.dropdownButton(
        value: _encryption,
        labelText: S.of(context).encryption,
        items: shadowsocksEncryption,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _encryption = value;
            });
          }
        },
      ),
      SphiaWidget.textInput(
        controller: _pluginController,
        labelText: S.of(context).plugin,
      ),
      SphiaWidget.textInput(
        controller: _pluginOptsController,
        labelText: S.of(context).pluginOpts,
      ),
      SphiaWidget.routingDropdownButton(
        value: _routingProvider,
        labelText: S.of(context).routingProvider,
        onChanged: (value) {
          setState(() {
            _routingProvider = value;
          });
        },
      ),
      SphiaWidget.shadowsocksDropdownButton(
        value: _protocolProvider,
        labelText: S.of(context).shadowsocksProvider,
        onChanged: (value) {
          setState(() {
            _protocolProvider = value;
          });
        },
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
              final server = widget.server.copyWith(
                protocol: widget.server.protocol,
                address: _addressController.text,
                port: int.parse(_portController.text),
                remark: _remarkController.text,
                authPayload: _passwordController.text,
                encryption: Value(_encryption),
                plugin: Value(_pluginController.text.trim().isNotEmpty
                    ? _pluginController.text
                    : null),
                pluginOpts: Value(_pluginOptsController.text.trim().isNotEmpty
                    ? _pluginOptsController.text
                    : null),
                routingProvider: Value(_routingProvider),
                protocolProvider: Value(_protocolProvider),
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
    _passwordController.text = server.authPayload;
    _encryption = server.encryption ?? 'aes-128-gcm';
    _pluginController.text = server.plugin ?? '';
    _pluginOptsController.text = server.pluginOpts ?? '';
    _routingProvider = server.routingProvider;
    _protocolProvider = server.protocolProvider;
  }

  void _disposeControllers() {
    _remarkController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _passwordController.dispose();
    _pluginController.dispose();
    _pluginOptsController.dispose();
  }
}
