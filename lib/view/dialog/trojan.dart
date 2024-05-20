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
  late String _fingerprint;
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
      SphiaWidget.textInput(
        controller: _sniController,
        labelText: S.of(context).sni,
      ),
      SphiaWidget.dropdownButton(
        value: _fingerprint,
        labelText: S.of(context).fingerPrint,
        items: fingerPrint,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _fingerprint = value;
            });
          }
        },
      ),
      SphiaWidget.dropdownButton(
        value: _allowInsecure,
        labelText: S.of(context).allowInsecure,
        items: allowInsecure,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _allowInsecure = value;
            });
          }
        },
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
      SphiaWidget.trojanDropdownButton(
        value: _protocolProvider,
        labelText: S.of(context).trojanProvider,
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
              final server = TrojanServer(
                id: widget.server.id,
                groupId: widget.server.groupId,
                protocol: widget.server.protocol,
                address: _addressController.text,
                port: int.parse(_portController.text),
                uplink: widget.server.uplink,
                downlink: widget.server.downlink,
                remark: _remarkController.text,
                authPayload: _passwordController.text,
                serverName: _sniController.text.trim().isNotEmpty
                    ? _sniController.text
                    : null,
                fingerprint: _fingerprint != 'none' ? _fingerprint : null,
                allowInsecure: _allowInsecure == 'true',
                routingProvider: _routingProvider,
                protocolProvider: _protocolProvider,
                tls: 'tls',
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
    _sniController.text = server.serverName ?? '';
    _fingerprint = server.fingerprint ?? 'none';
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
