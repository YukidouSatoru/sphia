import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/custom_config/server.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/view/widget/widget.dart';
import 'package:path/path.dart' as p;

const configFormat = ['json'];

class CustomConfigServerDialog extends ConsumerStatefulWidget {
  final String title;
  final CustomConfigServer server;

  const CustomConfigServerDialog({
    super.key,
    required this.title,
    required this.server,
  });

  @override
  ConsumerState<CustomConfigServerDialog> createState() =>
      _CustomConfigServerDialogState();
}

class _CustomConfigServerDialogState
    extends ConsumerState<CustomConfigServerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _remarkController = TextEditingController();
  final _portController = TextEditingController();
  final _configFilePathController = TextEditingController();
  late String _configFormat;
  late int _coreProvider;
  File? tempConfigFile;

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
        controller: _portController,
        labelText: S.of(context).customLocalHttpPort,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).portEnterMsg;
          }
          final newValue = int.tryParse(value);
          if (newValue == null || newValue < -1 || newValue > 65535) {
            return S.of(context).portInvalidMsg;
          }
          return null;
        },
      ),
      SphiaWidget.pathInput(
        controller: _configFilePathController,
        labelText: S.of(context).configFilePath,
        configFromat: _configFormat,
        validator: (value) {
          if (value != null) {
            if (value.isEmpty) {
              return S.of(context).pathCannotBeEmpty;
            }
            if (!File(value).existsSync()) {
              return S.of(context).fileDoesNotExist;
            }
          }
          return null;
        },
        editorPath: ref.read(sphiaConfigNotifierProvider).editorPath,
      ),
      SphiaWidget.dropdownButton(
        value: _configFormat,
        labelText: S.of(context).configFormat,
        items: configFormat,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _configFormat = value;
            });
          }
        },
      ),
      SphiaWidget.customConfigServerDropdownButton(
        value: _coreProvider,
        labelText: S.of(context).coreProvider,
        onChanged: (value) {
          setState(() {
            _coreProvider = value;
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
              final configFile = File(_configFilePathController.text);
              late final String configString;
              try {
                configString = configFile.readAsStringSync();
              } catch (e) {
                SphiaWidget.showDialogWithMsg(
                  context: context,
                  message: S.of(context).readConfigFileFailed(e.toString()),
                );
                return;
              }
              final server = CustomConfigServer(
                id: widget.server.id,
                groupId: widget.server.groupId,
                protocol: widget.server.protocol,
                address: '',
                port: int.parse(_portController.text),
                uplink: widget.server.uplink,
                downlink: widget.server.downlink,
                remark: _remarkController.text,
                protocolProvider: _coreProvider,
                configString: configString,
                configFormat: _configFormat,
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
    _portController.text = server.port.toString();
    if (server.configString.isEmpty) {
      _configFilePathController.text = '';
    } else {
      tempConfigFile =
          File(p.join(tempPath, 'tempCustom.${server.configFormat}'));
      if (tempConfigFile!.existsSync()) {
        tempConfigFile!.deleteSync();
      }
      tempConfigFile!.writeAsStringSync(server.configString);
      _configFilePathController.text = tempConfigFile!.path;
    }
    _configFormat = server.configFormat;
    _coreProvider = server.protocolProvider ?? 0;
  }

  void _disposeControllers() {
    _remarkController.dispose();
    _portController.dispose();
    _configFilePathController.dispose();
    if (tempConfigFile != null) {
      tempConfigFile!.deleteSync();
    }
  }
}
