import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sphia/app/database/dao/rule.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/core/rule/rule_model.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/server/server_model_lite.dart';
import 'package:sphia/view/widget/widget.dart';

const network = [
  '',
  'tcp',
  'udp',
];
const protocol = [
  '',
  'http',
  'tls',
];

class RuleDialog extends StatefulWidget {
  final String title;
  final RuleModel rule;

  const RuleDialog({
    super.key,
    required this.title,
    required this.rule,
  });

  @override
  State<StatefulWidget> createState() => _RuleDialogState();
}

class _RuleDialogState extends State<RuleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _outboundTag = outboundProxyId;
  final _domainController = TextEditingController();
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  final _sourceController = TextEditingController();
  final _sourcePortController = TextEditingController();
  String _network = '';
  final _protocolController = TextEditingController();
  final _processNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initControllers();
    _outboundTag = widget.rule.outboundTag;
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
        controller: _nameController,
        labelText: S.of(context).name,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return S.of(context).nameEnterMsg;
          }
          return null;
        },
      ),
      FutureBuilder(
        future: OutboundTagHelper.determineOutboundTagDisplay(_outboundTag),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final outboundTagDisplay = snapshot.data as String;
            final darkMode = Theme.of(context).brightness == Brightness.dark;
            return _buildDropdownSearch(
              context: context,
              outboundTagDisplay: outboundTagDisplay,
              darkMode: darkMode,
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      SphiaWidget.textInput(
        controller: _domainController,
        labelText: 'Domain',
      ),
      SphiaWidget.textInput(
        controller: _ipController,
        labelText: 'IP',
      ),
      SphiaWidget.textInput(
        controller: _portController,
        labelText: 'Port',
      ),
      SphiaWidget.textInput(
        controller: _sourceController,
        labelText: 'Source',
      ),
      SphiaWidget.textInput(
        controller: _sourcePortController,
        labelText: 'Source Port',
      ),
      SphiaWidget.dropdownButton(
        value: _network,
        labelText: 'Network',
        items: network,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _network = value;
            });
          }
        },
      ),
      SphiaWidget.textInput(
        controller: _protocolController,
        labelText: 'Protocol',
      ),
      SphiaWidget.textInput(
        controller: _processNameController,
        labelText: 'Process Name',
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
              final rule = RuleModel(
                id: widget.rule.id,
                groupId: widget.rule.groupId,
                enabled: widget.rule.enabled,
                name: _nameController.text,
                outboundTag: _outboundTag,
                domain: _domainController.text.isEmpty
                    ? null
                    : _domainController.text,
                ip: _ipController.text.isEmpty ? null : _ipController.text,
                port:
                    _portController.text.isEmpty ? null : _portController.text,
                source: _sourceController.text.isEmpty
                    ? null
                    : _sourceController.text,
                sourcePort: _sourcePortController.text.isEmpty
                    ? null
                    : _sourcePortController.text,
                network: _network.isEmpty ? null : _network,
                protocol: _protocolController.text.isEmpty
                    ? null
                    : _protocolController.text,
                processName: _processNameController.text.isEmpty
                    ? null
                    : _processNameController.text,
              );
              Navigator.pop(context, rule);
            }
          },
          child: Text(S.of(context).save),
        ),
      ],
    );
  }

  void _initControllers() {
    _nameController.text = widget.rule.name;
    _domainController.text = widget.rule.domain ?? '';
    _ipController.text = widget.rule.ip ?? '';
    _portController.text = widget.rule.port ?? '';
    _sourceController.text = widget.rule.source ?? '';
    _sourcePortController.text = widget.rule.sourcePort ?? '';
    _network = widget.rule.network ?? '';
    _protocolController.text = widget.rule.protocol ?? '';
    _processNameController.text = widget.rule.processName ?? '';
  }

  void _disposeControllers() {
    _nameController.dispose();
    _domainController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _sourceController.dispose();
    _sourcePortController.dispose();
    _protocolController.dispose();
    _processNameController.dispose();
  }

  Widget _buildDropdownSearch({
    required BuildContext context,
    required String outboundTagDisplay,
    required bool darkMode,
  }) {
    return DropdownSearch<ServerModelLite>(
      popupProps: PopupProps.menu(
          scrollbarProps: const ScrollbarProps(
            thickness: 0,
          ),
          showSearchBox: true,
          constraints: BoxConstraints.tightFor(
            height: MediaQuery.of(context).size.height * 1 / 3,
          ),
          containerBuilder: (context, child) {
            final color = darkMode
                ? Color.lerp(Colors.black, Colors.grey[700], 0.6)
                : Color.lerp(Colors.white, Colors.grey[300], 0.6);
            return Ink(
              color: color,
              child: child,
            );
          }),
      asyncItems: (query) async {
        List<ServerModelLite> items = [
          ServerModelLite(
            id: outboundProxyId,
            remark: 'proxy',
          ),
          ServerModelLite(
            id: outboundDirectId,
            remark: 'direct',
          ),
          ServerModelLite(
            id: outboundBlockId,
            remark: 'block',
          ),
        ];
        final servers = await serverDao.getServers();
        for (var i = 0; i < servers.length; i++) {
          items.add(
              ServerModelLite(id: servers[i].id, remark: servers[i].remark));
        }
        return items;
      },
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: 'Outbound Tag',
        ),
      ),
      onChanged: (value) {
        if (value != null) {
          _outboundTag = value.id;
        }
      },
      selectedItem: ServerModelLite(
        id: _outboundTag,
        remark: outboundTagDisplay,
      ),
    );
  }
}

class OutboundTagHelper {
  static String determineOutboundTag(int outboundTag) {
    if (outboundTag == outboundProxyId) {
      return 'proxy';
    } else if (outboundTag == outboundDirectId) {
      return 'direct';
    } else if (outboundTag == outboundBlockId) {
      return 'block';
    } else {
      return 'proxy-$outboundTag';
    }
  }

  static Future<String> determineOutboundTagDisplay(int outboundTag) async {
    if (outboundTag == outboundProxyId) {
      return 'proxy';
    } else if (outboundTag == outboundDirectId) {
      return 'direct';
    } else if (outboundTag == outboundBlockId) {
      return 'block';
    } else {
      final serverRemark = await serverDao.getServerRemarkById(outboundTag);
      return serverRemark;
    }
  }
}
