import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/view/widget/widget.dart';

class HysteriaServerDialog extends StatefulWidget {
  final String title;
  final HysteriaServer server;

  const HysteriaServerDialog({
    Key? key,
    required this.title,
    required this.server,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HysteriaServerDialogState();
}

class _HysteriaServerDialogState extends State<HysteriaServerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _remarkController = TextEditingController();
  final _addressController = TextEditingController();
  final _portController = TextEditingController();
  final _hysteriaProtocolController = TextEditingController();
  final _obfsController = TextEditingController();
  final _alpnController = TextEditingController();
  final _authTypeController = TextEditingController();
  final _authPayloadController = TextEditingController();
  final _sniController = TextEditingController();
  final _insecureController = TextEditingController();
  final _upMbpsController = TextEditingController();
  final _downMbpsController = TextEditingController();
  final _recvWindowConnController = TextEditingController();
  final _recvWindowController = TextEditingController();
  final _disableMtuDiscoveryController = TextEditingController();
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
      WidgetBuild.buildDropdownButtonFormField(
        _hysteriaProtocolController.text,
        S.of(context).hysteriaProtocol,
        ['udp', 'wechat-video', 'faketcp'],
        (value) {
          if (value != null) {
            setState(() {
              _hysteriaProtocolController.text = value;
            });
          }
        },
      ),
      WidgetBuild.buildTextFormField(_obfsController, S.of(context).obfs, null),
      WidgetBuild.buildTextFormField(_alpnController, S.of(context).alpn, null),
      WidgetBuild.buildDropdownButtonFormField(
        _authTypeController.text,
        S.of(context).authType,
        ['none', 'base64', 'str'],
        (value) {
          if (value != null) {
            setState(() {
              _authTypeController.text = value;
            });
          }
        },
      ),
      WidgetBuild.buildPasswordTextFormField(
        _authPayloadController,
        S.of(context).authPayload,
        null,
        _obscureText,
        (value) {
          setState(() {
            _obscureText = value;
          });
        },
      ),
      WidgetBuild.buildTextFormField(_sniController, S.of(context).sni, null),
      WidgetBuild.buildDropdownButtonFormField(
        _insecureController.text,
        S.of(context).allowInsecure,
        ['false', 'true'],
        (value) {
          if (value != null) {
            setState(() {
              _insecureController.text = value;
            });
          }
        },
      ),
      WidgetBuild.buildTextFormField(
        _upMbpsController,
        S.of(context).upMbps,
        (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).upMbpsEnterMsg;
          }
          if (int.tryParse(value) == null) {
            return S.of(context).upMbpsInvalidMsg;
          }
          return null;
        },
      ),
      WidgetBuild.buildTextFormField(
        _downMbpsController,
        S.of(context).downMbps,
        (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).downMbpsEnterMsg;
          }
          if (int.tryParse(value) == null) {
            return S.of(context).downMbpsInvalidMsg;
          }
          return null;
        },
      ),
      WidgetBuild.buildTextFormField(
        _recvWindowConnController,
        S.of(context).recvWindowConn,
        (value) {
          if (value != null && value.trim().isNotEmpty) {
            if (int.tryParse(value) == null) {
              return S.of(context).recvWindowConnInvalidMsg;
            }
          }
          return null;
        },
      ),
      WidgetBuild.buildTextFormField(
        _recvWindowController,
        S.of(context).recvWindow,
        (value) {
          if (value != null && value.trim().isNotEmpty) {
            if (int.tryParse(value) == null) {
              return S.of(context).recvWindowInvalidMsg;
            }
          }
          return null;
        },
      ),
      WidgetBuild.buildDropdownButtonFormField(
        _disableMtuDiscoveryController.text,
        S.of(context).disableMtuDiscovery,
        ['false', 'true'],
        (value) {
          if (value != null) {
            setState(() {
              _disableMtuDiscoveryController.text = value;
            });
          }
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
              final server = HysteriaServer(
                protocol: widget.server.protocol,
                address: _addressController.text,
                port: int.parse(_portController.text),
                remark: _remarkController.text,
                hysteriaProtocol: _hysteriaProtocolController.text,
                obfs: _obfsController.text.trim().isNotEmpty
                    ? _obfsController.text
                    : null,
                alpn: _alpnController.text.trim().isNotEmpty
                    ? _alpnController.text
                    : null,
                authType: _authTypeController.text,
                authPayload: _authPayloadController.text.trim().isNotEmpty
                    ? _authPayloadController.text
                    : null,
                serverName: _sniController.text.trim().isNotEmpty
                    ? _sniController.text
                    : null,
                insecure: _insecureController.text == 'true',
                upMbps: int.parse(_upMbpsController.text),
                downMbps: int.parse(_downMbpsController.text),
                recvWindowConn: _recvWindowConnController.text.trim().isNotEmpty
                    ? int.parse(_recvWindowConnController.text)
                    : null,
                recvWindow: _recvWindowController.text.trim().isNotEmpty
                    ? int.parse(_recvWindowController.text)
                    : null,
                disableMtuDiscovery:
                    _disableMtuDiscoveryController.text == 'true',
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
    _hysteriaProtocolController.text = server.hysteriaProtocol;
    _obfsController.text = server.obfs ?? '';
    _alpnController.text = server.alpn ?? '';
    _authTypeController.text = server.authType;
    _authPayloadController.text = server.authPayload ?? '';
    _sniController.text = server.serverName ?? '';
    _insecureController.text = server.insecure.toString();
    _upMbpsController.text = server.upMbps.toString();
    _downMbpsController.text = server.downMbps.toString();
    _recvWindowConnController.text =
        server.recvWindowConn != null ? server.recvWindowConn.toString() : '';
    _recvWindowController.text =
        server.recvWindow != null ? server.recvWindow.toString() : '';
    _disableMtuDiscoveryController.text = server.disableMtuDiscovery.toString();
  }

  void _disposeControllers() {
    _remarkController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _hysteriaProtocolController.dispose();
    _obfsController.dispose();
    _alpnController.dispose();
    _authTypeController.dispose();
    _authPayloadController.dispose();
    _sniController.dispose();
    _insecureController.dispose();
    _upMbpsController.dispose();
    _downMbpsController.dispose();
    _recvWindowConnController.dispose();
    _recvWindowController.dispose();
    _disableMtuDiscoveryController.dispose();
  }
}
