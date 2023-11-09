import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/shadowsocks/server.dart';
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
  final ShadowsocksServer server;

  const ShadowsocksServerDialog({
    Key? key,
    required this.title,
    required this.server,
  }) : super(key: key);

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
        _remarkController,
        S.of(context).remark,
        null,
      ),
      SphiaWidget.textInput(
        _addressController,
        S.of(context).address,
        (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).addressEnterMsg;
          }
          return null;
        },
      ),
      SphiaWidget.textInput(
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
      SphiaWidget.passwordTextInput(
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
      SphiaWidget.dropdownButton(
        _encryption,
        S.of(context).encryption,
        shadowsocksEncryption,
        (value) {
          if (value != null) {
            setState(() {
              _encryption = value;
            });
          }
        },
      ),
      SphiaWidget.textInput(
        _pluginController,
        S.of(context).plugin,
        null,
      ),
      SphiaWidget.textInput(
        _pluginOptsController,
        S.of(context).pluginOpts,
        null,
      ),
      SphiaWidget.routingDropdownButton(
        _routingProvider,
        S.of(context).routingProvider,
        (value) {
          setState(() {
            _routingProvider = value;
          });
        },
      ),
      SphiaWidget.shadowsocksDropdownButton(
        _protocolProvider,
        S.of(context).shadowsocksProvider,
        (value) {
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
              final server = ShadowsocksServer(
                protocol: widget.server.protocol,
                address: _addressController.text,
                port: int.parse(_portController.text),
                remark: _remarkController.text,
                password: _passwordController.text,
                encryption: _encryption,
                plugin: _pluginController.text.trim().isNotEmpty
                    ? _pluginController.text
                    : null,
                pluginOpts: _pluginOptsController.text.trim().isNotEmpty
                    ? _pluginOptsController.text
                    : null,
                routingProvider: _routingProvider,
                protocolProvider: _protocolProvider,
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
    _encryption = server.encryption;
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
