import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/view/dialog/xray.dart';
import 'package:sphia/view/widget/widget.dart';

const hysteriaProtocol = ['udp', 'wechat-video', 'faketcp'];
const authType = ['none', 'base64', 'str'];
const disableMtuDiscovery = ['false', 'true'];

class HysteriaServerDialog extends StatefulWidget {
  final String title;
  final HysteriaServer server;

  const HysteriaServerDialog({
    super.key,
    required this.title,
    required this.server,
  });

  @override
  State<StatefulWidget> createState() => _HysteriaServerDialogState();
}

class _HysteriaServerDialogState extends State<HysteriaServerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _remarkController = TextEditingController();
  final _addressController = TextEditingController();
  final _portController = TextEditingController();
  late String _hysteriaProtocol;
  final _obfsController = TextEditingController();
  final _alpnController = TextEditingController();
  late String _authType;
  final _authPayloadController = TextEditingController();
  final _sniController = TextEditingController();
  late String _insecure;
  final _upMbpsController = TextEditingController();
  final _downMbpsController = TextEditingController();
  final _recvWindowConnController = TextEditingController();
  final _recvWindowController = TextEditingController();
  late String _disableMtuDiscovery;
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
      SphiaWidget.dropdownButton(
        _hysteriaProtocol,
        S.of(context).hysteriaProtocol,
        hysteriaProtocol,
        (value) {
          if (value != null) {
            setState(() {
              _hysteriaProtocol = value;
            });
          }
        },
      ),
      SphiaWidget.textInput(_obfsController, S.of(context).obfs, null),
      SphiaWidget.textInput(_alpnController, S.of(context).alpn, null),
      SphiaWidget.dropdownButton(
        _authType,
        S.of(context).authType,
        authType,
        (value) {
          if (value != null) {
            setState(() {
              _authType = value;
            });
          }
        },
      ),
      SphiaWidget.passwordTextInput(
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
      SphiaWidget.textInput(_sniController, S.of(context).sni, null),
      SphiaWidget.dropdownButton(
        _insecure,
        S.of(context).allowInsecure,
        allowInsecure,
        (value) {
          if (value != null) {
            setState(() {
              _insecure = value;
            });
          }
        },
      ),
      SphiaWidget.textInput(
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
      SphiaWidget.textInput(
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
      SphiaWidget.textInput(
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
      SphiaWidget.textInput(
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
      SphiaWidget.dropdownButton(
        _disableMtuDiscovery,
        S.of(context).disableMtuDiscovery,
        disableMtuDiscovery,
        (value) {
          if (value != null) {
            setState(() {
              _disableMtuDiscovery = value;
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
      SphiaWidget.hysteriaDropdownButton(
        _protocolProvider,
        S.of(context).hysteriaProvider,
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
              final server = HysteriaServer(
                protocol: widget.server.protocol,
                address: _addressController.text,
                port: int.parse(_portController.text),
                remark: _remarkController.text,
                hysteriaProtocol: _hysteriaProtocol,
                obfs: _obfsController.text.trim().isNotEmpty
                    ? _obfsController.text
                    : null,
                alpn: _alpnController.text.trim().isNotEmpty
                    ? _alpnController.text
                    : null,
                authType: _authType,
                authPayload: _authPayloadController.text.trim().isNotEmpty
                    ? _authPayloadController.text
                    : null,
                serverName: _sniController.text.trim().isNotEmpty
                    ? _sniController.text
                    : null,
                insecure: _insecure == 'true',
                upMbps: int.parse(_upMbpsController.text),
                downMbps: int.parse(_downMbpsController.text),
                recvWindowConn: _recvWindowConnController.text.trim().isNotEmpty
                    ? int.parse(_recvWindowConnController.text)
                    : null,
                recvWindow: _recvWindowController.text.trim().isNotEmpty
                    ? int.parse(_recvWindowController.text)
                    : null,
                disableMtuDiscovery: _disableMtuDiscovery == 'true',
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
    _hysteriaProtocol = server.hysteriaProtocol;
    _obfsController.text = server.obfs ?? '';
    _alpnController.text = server.alpn ?? '';
    _authType = server.authType;
    _authPayloadController.text = server.authPayload ?? '';
    _sniController.text = server.serverName ?? '';
    _insecure = server.insecure.toString();
    _upMbpsController.text = server.upMbps.toString();
    _downMbpsController.text = server.downMbps.toString();
    _recvWindowConnController.text =
        server.recvWindowConn != null ? server.recvWindowConn.toString() : '';
    _recvWindowController.text =
        server.recvWindow != null ? server.recvWindow.toString() : '';
    _disableMtuDiscovery = server.disableMtuDiscovery.toString();
    _routingProvider = server.routingProvider;
    _protocolProvider = server.protocolProvider;
  }

  void _disposeControllers() {
    _remarkController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _obfsController.dispose();
    _alpnController.dispose();
    _authPayloadController.dispose();
    _sniController.dispose();
    _upMbpsController.dispose();
    _downMbpsController.dispose();
    _recvWindowConnController.dispose();
    _recvWindowController.dispose();
  }
}
