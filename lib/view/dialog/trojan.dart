import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/view/dialog/xray.dart';
import 'package:sphia/view/widget/widget.dart';

class TrojanServerDialog extends StatefulWidget {
  final String title;
  final TrojanServer server;

  const TrojanServerDialog({
    super.key,
    required this.title,
    required this.server,
  });

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
  late String _fingerPrint;
  late String _allowInsecure;
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
      SphiaWidget.textInput(_sniController, S.of(context).sni, null),
      SphiaWidget.dropdownButton(
        _fingerPrint,
        S.of(context).fingerPrint,
        fingerPrint,
        (value) {
          if (value != null) {
            setState(() {
              _fingerPrint = value;
            });
          }
        },
      ),
      SphiaWidget.dropdownButton(
        _allowInsecure,
        S.of(context).allowInsecure,
        allowInsecure,
        (value) {
          if (value != null) {
            setState(() {
              _allowInsecure = value;
            });
          }
        },
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
      SphiaWidget.trojanDropdownButton(
          _protocolProvider, S.of(context).trojanProvider, (value) {
        setState(() {
          _protocolProvider = value;
        });
      }),
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
              final server = TrojanServer(
                protocol: widget.server.protocol,
                address: _addressController.text,
                port: int.parse(_portController.text),
                remark: _remarkController.text,
                password: _passwordController.text,
                serverName: _sniController.text.trim().isNotEmpty
                    ? _sniController.text
                    : null,
                fingerPrint: _fingerPrint != 'none' ? _fingerPrint : null,
                allowInsecure: _allowInsecure == 'true',
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
    _sniController.text = server.serverName ?? '';
    _fingerPrint = server.fingerPrint ?? 'chrome';
    _allowInsecure = server.allowInsecure.toString();
    _routingProvider = server.routingProvider;
    _protocolProvider = server.protocolProvider;
  }

  void _disposeControllers() {
    _remarkController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _passwordController.dispose();
    _sniController.dispose();
  }
}
