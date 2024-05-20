import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/xray/server.dart';
import 'package:sphia/view/widget/widget.dart';

const vmessEncryption = [
  'auto',
  'aes-128-gcm',
  'chacha20-poly1305',
  'none',
  'zero',
];
const vlessEncryption = ['none'];
const vlessFlow = ['none', 'xtls-rprx-vision'];
const vProtocolTransport = ['tcp', 'ws', 'grpc', 'httpupgrade'];
const grpcMode = ['gun', 'multi'];
const tls = ['none', 'tls', 'reality'];
const fingerPrint = [
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
  'qq',
];
const realityFingerPrint = [
  'random',
  "randomized",
  'chrome',
  'firefox',
  'safari',
  'ios',
  'android',
  'edge',
  '360',
  'qq',
];
const allowInsecure = ['false', 'true'];

class XrayServerDialog extends StatefulWidget {
  final String title;
  final XrayServer server;

  const XrayServerDialog({
    super.key,
    required this.title,
    required this.server,
  });

  @override
  State<StatefulWidget> createState() => _XrayServerDialogState();
}

class _XrayServerDialogState extends State<XrayServerDialog> {
  final _formKey = GlobalKey<FormState>();
  late final String _protocol;
  final _remarkController = TextEditingController();
  final _addressController = TextEditingController();
  final _portController = TextEditingController();
  final _uuidController = TextEditingController();
  final _alterIdController = TextEditingController();
  late String _encryption;
  late String _flow;
  late String _transport;
  final _hostController = TextEditingController();
  final _pathController = TextEditingController();
  late String _grpcMode;
  final _serviceNameController = TextEditingController();
  late String _tls;
  final _sniController = TextEditingController();
  late String _fingerprint;
  final _publicKeyController = TextEditingController();
  final _shortIdController = TextEditingController();
  final _spiderXController = TextEditingController();
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
        controller: _uuidController,
        labelText: S.of(context).uuid,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).uuidEnterMsg;
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
      if (_protocol == 'vmess') ...[
        SphiaWidget.textInput(
          controller: _alterIdController,
          labelText: S.of(context).alterId,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return S.of(context).alterIdEnterMsg;
            }
            if (int.tryParse(value) == null) {
              return S.of(context).alterIdInvalidMsg;
            }
            return null;
          },
        ),
      ],
      SphiaWidget.dropdownButton(
        value: _encryption,
        labelText: S.of(context).encryption,
        items: _protocol == 'vmess' ? vmessEncryption : vlessEncryption,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _encryption = value;
            });
          }
        },
      ),
      if (_protocol == 'vless') ...[
        SphiaWidget.dropdownButton(
          value: _flow,
          labelText: S.of(context).flow,
          items: vlessFlow,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _flow = value;
              });
            }
          },
        ),
      ],
      SphiaWidget.dropdownButton(
        value: _transport,
        labelText: S.of(context).transport,
        items: vProtocolTransport,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _transport = value;
            });
          }
        },
      ),
      if (_transport == 'grpc') ...[
        SphiaWidget.dropdownButton(
          value: _grpcMode,
          labelText: S.of(context).grpcMode,
          items: grpcMode,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _grpcMode = value;
              });
            }
          },
        ),
        SphiaWidget.textInput(
          controller: _serviceNameController,
          labelText: S.of(context).grpcServiceName,
        ),
      ],
      if (_transport == 'ws' || _transport == 'httpupgrade') ...[
        SphiaWidget.textInput(
          controller: _hostController,
          labelText: S.of(context).host,
        ),
        SphiaWidget.textInput(
          controller: _pathController,
          labelText: S.of(context).path,
        ),
      ],
      SphiaWidget.dropdownButton(
        value: _tls,
        labelText: S.of(context).tls,
        items: tls,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _tls = value;
            });
          }
        },
      ),
      if (_tls == 'tls') ...[
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
      ],
      if (_tls == 'reality') ...[
        SphiaWidget.textInput(
          controller: _sniController,
          labelText: S.of(context).sni,
        ),
        SphiaWidget.dropdownButton(
          value: _fingerprint,
          labelText: S.of(context).fingerPrint,
          items: realityFingerPrint,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _fingerprint = value;
              });
            }
          },
        ),
        SphiaWidget.textInput(
          controller: _publicKeyController,
          labelText: S.of(context).publicKey,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return S.of(context).publicKeyEnterMsg;
            }
            return null;
          },
        ),
        SphiaWidget.textInput(
          controller: _shortIdController,
          labelText: S.of(context).shortId,
        ),
        SphiaWidget.textInput(
          controller: _spiderXController,
          labelText: S.of(context).spiderX,
        ),
      ],
      SphiaWidget.routingDropdownButton(
        value: _routingProvider,
        labelText: S.of(context).routingProvider,
        onChanged: (value) {
          setState(() {
            _routingProvider = value;
          });
        },
      ),
      if (_protocol == 'vmess') ...[
        SphiaWidget.vmessDropdownButton(
          value: _protocolProvider,
          labelText: S.of(context).vmessProvider,
          onChanged: (value) {
            setState(() {
              _protocolProvider = value;
            });
          },
        ),
      ],
      if (_protocol == 'vless') ...[
        SphiaWidget.vlessDropdownButton(
          value: _protocolProvider,
          labelText: S.of(context).vlessProvider,
          onChanged: (value) {
            setState(() {
              _protocolProvider = value;
            });
          },
        ),
      ],
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
              final server = XrayServer(
                id: widget.server.id,
                groupId: widget.server.groupId,
                protocol: _protocol,
                address: _addressController.text,
                port: int.parse(_portController.text),
                uplink: widget.server.uplink,
                downlink: widget.server.downlink,
                remark: _remarkController.text,
                authPayload: _uuidController.text,
                alterId: _protocol == 'vmess'
                    ? int.parse(_alterIdController.text)
                    : null,
                encryption: _protocol == 'vmess' ? _encryption : 'none',
                flow: _protocol == 'vless'
                    ? _flow != 'none'
                        ? _flow
                        : null
                    : null,
                transport: _transport,
                host: _transport == 'ws' || _transport == 'httpupgrade'
                    ? (_hostController.text.trim().isNotEmpty
                        ? _hostController.text
                        : null)
                    : null,
                path: _transport == 'ws' || _transport == 'httpupgrade'
                    ? (_pathController.text.trim().isNotEmpty
                        ? _pathController.text
                        : null)
                    : null,
                grpcMode: _transport == 'grpc' ? _grpcMode : null,
                serviceName: _transport == 'grpc'
                    ? (_serviceNameController.text.trim().isNotEmpty
                        ? _serviceNameController.text
                        : null)
                    : null,
                tls: _tls,
                serverName: _sniController.text.trim().isNotEmpty
                    ? _sniController.text
                    : null,
                fingerprint: _tls == 'tls' || _tls == 'reality'
                    ? _fingerprint != 'none'
                        ? _fingerprint
                        : null
                    : null,
                publicKey:
                    _tls == 'reality' ? _publicKeyController.text.trim() : null,
                shortId: _tls == 'reality'
                    ? (_shortIdController.text.trim().isNotEmpty
                        ? _shortIdController.text
                        : null)
                    : null,
                spiderX: _tls == 'reality'
                    ? (_spiderXController.text.trim().isNotEmpty
                        ? _spiderXController.text
                        : null)
                    : null,
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
    _protocol = widget.server.protocol;
    _remarkController.text = server.remark;
    _addressController.text = server.address;
    _portController.text = server.port.toString();
    _uuidController.text = server.authPayload;
    _alterIdController.text =
        server.alterId == null ? '0' : server.alterId.toString();
    _encryption = server.encryption;
    _flow = server.flow ?? 'none';
    _transport = server.transport;
    _hostController.text = server.host ?? '';
    _pathController.text = server.path ?? '';
    _grpcMode = server.grpcMode ?? 'gun';
    _serviceNameController.text = server.serviceName ?? '';
    _tls = server.tls;
    _sniController.text = server.serverName ?? '';
    _fingerprint = server.fingerprint ?? 'none';
    _publicKeyController.text = server.publicKey ?? '';
    _shortIdController.text = server.shortId ?? '';
    _spiderXController.text = server.spiderX ?? '';
    _allowInsecure = server.allowInsecure.toString();
    _routingProvider = server.routingProvider;
    _protocolProvider = server.protocolProvider;
  }

  void _disposeControllers() {
    _remarkController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _uuidController.dispose();
    _alterIdController.dispose();
    _hostController.dispose();
    _pathController.dispose();
    _serviceNameController.dispose();
    _sniController.dispose();
    _publicKeyController.dispose();
    _shortIdController.dispose();
    _spiderXController.dispose();
  }
}
