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
      SphiaWidget.dropdownButton(
        value: _hysteriaProtocol,
        labelText: S.of(context).hysteriaProtocol,
        items: hysteriaProtocol,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _hysteriaProtocol = value;
            });
          }
        },
      ),
      SphiaWidget.textInput(
        controller: _obfsController,
        labelText: S.of(context).obfs,
      ),
      SphiaWidget.textInput(
        controller: _alpnController,
        labelText: S.of(context).alpn,
      ),
      SphiaWidget.dropdownButton(
        value: _authType,
        labelText: S.of(context).authType,
        items: authType,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _authType = value;
            });
          }
        },
      ),
      SphiaWidget.passwordTextInput(
        controller: _authPayloadController,
        labelText: S.of(context).authPayload,
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
        value: _insecure,
        labelText: S.of(context).allowInsecure,
        items: allowInsecure,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _insecure = value;
            });
          }
        },
      ),
      SphiaWidget.textInput(
        controller: _upMbpsController,
        labelText: S.of(context).upMbps,
        validator: (value) {
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
        controller: _downMbpsController,
        labelText: S.of(context).downMbps,
        validator: (value) {
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
        controller: _recvWindowConnController,
        labelText: S.of(context).recvWindowConn,
        validator: (value) {
          if (value != null && value.trim().isNotEmpty) {
            if (int.tryParse(value) == null) {
              return S.of(context).recvWindowConnInvalidMsg;
            }
          }
          return null;
        },
      ),
      SphiaWidget.textInput(
        controller: _recvWindowController,
        labelText: S.of(context).recvWindow,
        validator: (value) {
          if (value != null && value.trim().isNotEmpty) {
            if (int.tryParse(value) == null) {
              return S.of(context).recvWindowInvalidMsg;
            }
          }
          return null;
        },
      ),
      SphiaWidget.dropdownButton(
        value: _disableMtuDiscovery,
        labelText: S.of(context).disableMtuDiscovery,
        items: disableMtuDiscovery,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _disableMtuDiscovery = value;
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
      SphiaWidget.hysteriaDropdownButton(
        value: _protocolProvider,
        labelText: S.of(context).hysteriaProvider,
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
              final server = HysteriaServer(
                id: widget.server.id,
                groupId: widget.server.groupId,
                protocol: widget.server.protocol,
                address: _addressController.text,
                port: int.parse(_portController.text),
                uplink: widget.server.uplink,
                downlink: widget.server.downlink,
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
                    : '',
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
    _authPayloadController.text = server.authPayload;
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
