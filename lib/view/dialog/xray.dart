import 'package:flutter/material.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/xray/server.dart';
import 'package:sphia/view/widget/widget.dart';

class XrayServerDialog extends StatefulWidget {
  final String title;
  final XrayServer server;

  const XrayServerDialog({
    Key? key,
    required this.title,
    required this.server,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _XrayServerDialogState();
}

class _XrayServerDialogState extends State<XrayServerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _remarkController = TextEditingController();
  final _addressController = TextEditingController();
  final _portController = TextEditingController();
  final _uuidController = TextEditingController();
  final _alterIdController = TextEditingController();
  final _encryptionController = TextEditingController();
  final _flowController = TextEditingController();
  final _transportController = TextEditingController();
  final _hostController = TextEditingController();
  final _pathController = TextEditingController();
  final _grpcModeController = TextEditingController();
  final _serviceNameController = TextEditingController();
  final _tlsController = TextEditingController();
  final _sniController = TextEditingController();
  final _fingerPrintController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _shortIdController = TextEditingController();
  final _spiderXController = TextEditingController();
  final _allowInsecureController = TextEditingController();
  late final String _protocol;
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
      WidgetBuild.buildTextFormField(_addressController, S.of(context).address,
          (value) {
        if (value == null || value.trim().isEmpty) {
          return S.of(context).addressEnterMsg;
        }
        return null;
      }),
      WidgetBuild.buildTextFormField(_portController, S.of(context).port,
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
      }),
      WidgetBuild.buildPasswordTextFormField(
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
      if (_protocol == 'vmess')
        WidgetBuild.buildTextFormField(
            _alterIdController, S.of(context).alterId, (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).alterIdEnterMsg;
          }
          if (int.tryParse(value) == null) {
            return S.of(context).alterIdInvalidMsg;
          }
          return null;
        }),
      WidgetBuild.buildDropdownButtonFormField(
        _encryptionController.text,
        S.of(context).encryption,
        _protocol == 'vmess'
            ? ['auto', 'aes-128-gcm', 'chacha20-poly1305', 'none', 'zero']
            : ['none'],
        (value) {
          if (value != null) {
            setState(() {
              _encryptionController.text = value;
            });
          }
        },
      ),
      if (_protocol == 'vless')
        WidgetBuild.buildDropdownButtonFormField(
          _flowController.text,
          S.of(context).flow,
          ['none', 'xtls-rprx-vision'],
          (value) {
            if (value != null) {
              setState(() {
                _flowController.text = value;
              });
            }
          },
        ),
      WidgetBuild.buildDropdownButtonFormField(
        _transportController.text,
        S.of(context).transport,
        ['tcp', 'ws', 'grpc'],
        (value) {
          if (value != null) {
            setState(() {
              _transportController.text = value;
            });
          }
        },
      ),
      if (_transportController.text == 'grpc') ...[
        WidgetBuild.buildDropdownButtonFormField(
          _grpcModeController.text,
          S.of(context).grpcMode,
          ['gun', 'multi'],
          (value) {
            if (value != null) {
              setState(() {
                _grpcModeController.text = value;
              });
            }
          },
        ),
        WidgetBuild.buildTextFormField(
          _serviceNameController,
          S.of(context).grpcServiceName,
          null,
        ),
      ],
      if (_transportController.text == 'ws') ...[
        WidgetBuild.buildTextFormField(
          _hostController,
          S.of(context).host,
          null,
        ),
        WidgetBuild.buildTextFormField(
          _pathController,
          S.of(context).path,
          null,
        ),
      ],
      WidgetBuild.buildDropdownButtonFormField(
        _tlsController.text,
        S.of(context).tls,
        ['none', 'tls', 'reality'],
        (value) {
          if (value != null) {
            setState(() {
              _tlsController.text = value;
            });
          }
        },
      ),
      if (_tlsController.text == 'tls') ...[
        WidgetBuild.buildTextFormField(
          _sniController,
          S.of(context).sni,
          null,
        ),
        WidgetBuild.buildDropdownButtonFormField(
          _fingerPrintController.text,
          S.of(context).fingerPrint,
          [
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
            'qq'
          ],
          (value) {
            if (value != null) {
              setState(() {
                _fingerPrintController.text = value;
              });
            }
          },
        ),
        WidgetBuild.buildDropdownButtonFormField(
          _allowInsecureController.text,
          S.of(context).allowInsecure,
          ['false', 'true'],
          (value) {
            if (value != null) {
              setState(() {
                _allowInsecureController.text = value;
              });
            }
          },
        ),
      ],
      if (_tlsController.text == 'reality') ...[
        WidgetBuild.buildTextFormField(
          _sniController,
          S.of(context).sni,
          null,
        ),
        WidgetBuild.buildDropdownButtonFormField(
          _fingerPrintController.text,
          S.of(context).fingerPrint,
          [
            'random',
            "randomized",
            'chrome',
            'firefox',
            'safari',
            'ios',
            'android',
            'edge',
            '360',
            'qq'
          ],
          (value) {
            if (value != null) {
              setState(() {
                _fingerPrintController.text = value;
              });
            }
          },
        ),
        WidgetBuild.buildTextFormField(
          _publicKeyController,
          S.of(context).publicKey,
          (value) {
            if (value == null || value.trim().isEmpty) {
              return S.of(context).publicKeyEnterMsg;
            }
            return null;
          },
        ),
        WidgetBuild.buildTextFormField(
          _shortIdController,
          S.of(context).shortId,
          null,
        ),
        WidgetBuild.buildTextFormField(
          _spiderXController,
          S.of(context).spiderX,
          null,
        ),
      ]
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
                encryption:
                    _protocol == 'vmess' ? _encryptionController.text : 'none',
                flow: _protocol == 'vless'
                    ? _flowController.text != 'none'
                        ? _flowController.text
                        : null
                    : null,
                transport: _transportController.text,
                host: _transportController.text == 'ws'
                    ? (_hostController.text.trim().isNotEmpty
                        ? _hostController.text
                        : null)
                    : null,
                path: _transportController.text == 'ws'
                    ? (_pathController.text.trim().isNotEmpty
                        ? _pathController.text
                        : null)
                    : null,
                grpcMode: _transportController.text == 'grpc'
                    ? _grpcModeController.text
                    : null,
                serviceName: _transportController.text == 'grpc'
                    ? (_serviceNameController.text.trim().isNotEmpty
                        ? _serviceNameController.text
                        : null)
                    : null,
                tls: _tlsController.text,
                serverName: _sniController.text.trim().isNotEmpty
                    ? _sniController.text
                    : null,
                fingerPrint: _tlsController.text == 'tls' ||
                        _tlsController.text == 'reality'
                    ? _fingerPrintController.text != 'none'
                        ? _fingerPrintController.text
                        : null
                    : null,
                publicKey: _tlsController.text == 'reality'
                    ? _publicKeyController.text.trim()
                    : null,
                shortId: _tlsController.text == 'reality'
                    ? (_shortIdController.text.trim().isNotEmpty
                        ? _shortIdController.text
                        : null)
                    : null,
                spiderX: _tlsController.text == 'reality'
                    ? (_spiderXController.text.trim().isNotEmpty
                        ? _spiderXController.text
                        : null)
                    : null,
                allowInsecure: _allowInsecureController.text == 'true',
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
    _encryptionController.text =
        _protocol == 'vmess' ? server.encryption : 'none';
    _flowController.text = server.flow ?? 'none';
    _transportController.text = server.transport;
    _hostController.text = server.host ?? '';
    _pathController.text = server.path ?? '';
    _grpcModeController.text = server.grpcMode ?? 'gun';
    _serviceNameController.text = server.serviceName ?? '';
    _tlsController.text = server.tls;
    _sniController.text = server.serverName ?? '';
    _fingerPrintController.text = server.fingerPrint ?? 'chrome';
    _publicKeyController.text = server.publicKey ?? '';
    _shortIdController.text = server.shortId ?? '';
    _spiderXController.text = server.spiderX ?? '';
    _allowInsecureController.text = server.allowInsecure.toString();
  }

  void _disposeControllers() {
    _remarkController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _uuidController.dispose();
    _alterIdController.dispose();
    _encryptionController.dispose();
    _flowController.dispose();
    _transportController.dispose();
    _hostController.dispose();
    _pathController.dispose();
    _grpcModeController.dispose();
    _serviceNameController.dispose();
    _tlsController.dispose();
    _sniController.dispose();
    _fingerPrintController.dispose();
    _publicKeyController.dispose();
    _shortIdController.dispose();
    _spiderXController.dispose();
    _allowInsecureController.dispose();
  }
}
