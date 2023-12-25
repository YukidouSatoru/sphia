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
  late String _fingerPrint;
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
        _uuidController,
        S.of(context).uuid,
        (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).uuidEnterMsg;
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
      if (_protocol == 'vmess') ...[
        SphiaWidget.textInput(
          _alterIdController,
          S.of(context).alterId,
          (value) {
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
        _encryption,
        S.of(context).encryption,
        _protocol == 'vmess' ? vmessEncryption : vlessEncryption,
        (value) {
          if (value != null) {
            setState(() {
              _encryption = value;
            });
          }
        },
      ),
      if (_protocol == 'vless') ...[
        SphiaWidget.dropdownButton(
          _flow,
          S.of(context).flow,
          vlessFlow,
          (value) {
            if (value != null) {
              setState(() {
                _flow = value;
              });
            }
          },
        ),
      ],
      SphiaWidget.dropdownButton(
        _transport,
        S.of(context).transport,
        vProtocolTransport,
        (value) {
          if (value != null) {
            setState(() {
              _transport = value;
            });
          }
        },
      ),
      if (_transport == 'grpc') ...[
        SphiaWidget.dropdownButton(
          _grpcMode,
          S.of(context).grpcMode,
          grpcMode,
          (value) {
            if (value != null) {
              setState(() {
                _grpcMode = value;
              });
            }
          },
        ),
        SphiaWidget.textInput(
          _serviceNameController,
          S.of(context).grpcServiceName,
          null,
        ),
      ],
      if (_transport == 'ws' || _transport == 'httpupgrade') ...[
        SphiaWidget.textInput(
          _hostController,
          S.of(context).host,
          null,
        ),
        SphiaWidget.textInput(
          _pathController,
          S.of(context).path,
          null,
        ),
      ],
      SphiaWidget.dropdownButton(
        _tls,
        S.of(context).tls,
        tls,
        (value) {
          if (value != null) {
            setState(() {
              _tls = value;
            });
          }
        },
      ),
      if (_tls == 'tls') ...[
        SphiaWidget.textInput(
          _sniController,
          S.of(context).sni,
          null,
        ),
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
      ],
      if (_tls == 'reality') ...[
        SphiaWidget.textInput(
          _sniController,
          S.of(context).sni,
          null,
        ),
        SphiaWidget.dropdownButton(
          _fingerPrint,
          S.of(context).fingerPrint,
          realityFingerPrint,
          (value) {
            if (value != null) {
              setState(() {
                _fingerPrint = value;
              });
            }
          },
        ),
        SphiaWidget.textInput(
          _publicKeyController,
          S.of(context).publicKey,
          (value) {
            if (value == null || value.trim().isEmpty) {
              return S.of(context).publicKeyEnterMsg;
            }
            return null;
          },
        ),
        SphiaWidget.textInput(
          _shortIdController,
          S.of(context).shortId,
          null,
        ),
        SphiaWidget.textInput(
          _spiderXController,
          S.of(context).spiderX,
          null,
        ),
      ],
      SphiaWidget.routingDropdownButton(
        _routingProvider,
        S.of(context).routingProvider,
        (value) {
          setState(() {
            _routingProvider = value;
          });
        },
      ),
      if (_protocol == 'vmess') ...[
        SphiaWidget.vmessDropdownButton(
          _protocolProvider,
          S.of(context).vmessProvider,
          (value) {
            setState(() {
              _protocolProvider = value;
            });
          },
        ),
      ],
      if (_protocol == 'vless') ...[
        SphiaWidget.vlessDropdownButton(
          _protocolProvider,
          S.of(context).vlessProvider,
          (value) {
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
                protocol: _protocol,
                address: _addressController.text,
                port: int.parse(_portController.text),
                remark: _remarkController.text,
                uuid: _uuidController.text,
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
                host: _transport == 'ws'
                    ? (_hostController.text.trim().isNotEmpty
                        ? _hostController.text
                        : null)
                    : null,
                path: _transport == 'ws'
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
                fingerPrint: _tls == 'tls' || _tls == 'reality'
                    ? _fingerPrint != 'none'
                        ? _fingerPrint
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
    _uuidController.text = server.uuid;
    _alterIdController.text =
        server.alterId == null ? '0' : server.alterId.toString();
    _encryption = _protocol == 'vmess' ? server.encryption : 'none';
    _flow = server.flow ?? 'none';
    _transport = server.transport;
    _hostController.text = server.host ?? '';
    _pathController.text = server.path ?? '';
    _grpcMode = server.grpcMode ?? 'gun';
    _serviceNameController.text = server.serviceName ?? '';
    _tls = server.tls;
    _sniController.text = server.serverName ?? '';
    _fingerPrint = server.fingerPrint ?? 'chrome';
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
