import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/shadowsocks/server.dart';
import 'package:sphia/view/widget/widget.dart';

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
  final _encryptionController = TextEditingController();
  final _pluginController = TextEditingController();
  final _pluginOptsController = TextEditingController();
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
      WidgetBuild.buildDropdownButtonFormField(
        _encryptionController.text,
        S.of(context).encryption,
        [
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
        ],
        (value) {
          if (value != null) {
            setState(() {
              _encryptionController.text = value;
            });
          }
        },
      ),
      WidgetBuild.buildTextFormField(
          _pluginController, S.of(context).plugin, null),
      WidgetBuild.buildTextFormField(
          _pluginOptsController, S.of(context).pluginOpts, null),
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
              final server = ShadowsocksServer(
                protocol: widget.server.protocol,
                address: _addressController.text,
                port: int.parse(_portController.text),
                remark: _remarkController.text,
                password: _passwordController.text,
                encryption: _encryptionController.text,
                plugin: _pluginController.text.trim().isNotEmpty
                    ? _pluginController.text
                    : null,
                pluginOpts: _pluginOptsController.text.trim().isNotEmpty
                    ? _pluginOptsController.text
                    : null,
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
    _encryptionController.text = server.encryption;
    _pluginController.text = server.plugin ?? '';
    _pluginOptsController.text = server.pluginOpts ?? '';
  }

  void _disposeControllers() {
    _remarkController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _passwordController.dispose();
    _encryptionController.dispose();
    _pluginController.dispose();
    _pluginOptsController.dispose();
  }
}
