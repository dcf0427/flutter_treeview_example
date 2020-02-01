import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TreeView Example',
      home: MyHomePage(title: 'TreeView Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedNode;
  List<Node> _nodes;
  TreeViewController _treeViewController;
  bool docsOpen = true;
  final Map<ExpanderPosition, Widget> expansionPositionOptions = const {
    ExpanderPosition.start: Text('Start'),
    ExpanderPosition.end: Text('End'),
  };
  final Map<ExpanderType, Widget> expansionTypeOptions = const {
    ExpanderType.caret: Icon(
      Icons.arrow_drop_down,
      size: 28,
    ),
    ExpanderType.arrow: Icon(Icons.arrow_downward),
    ExpanderType.chevron: Icon(Icons.expand_more),
    ExpanderType.plusMinus: Icon(Icons.add),
  };
  final Map<ExpanderModifier, Widget> expansionModifierOptions = const {
    ExpanderModifier.none: ModContainer(ExpanderModifier.none),
    ExpanderModifier.circleFilled: ModContainer(ExpanderModifier.circleFilled),
    ExpanderModifier.circleOutlined:
        ModContainer(ExpanderModifier.circleOutlined),
    ExpanderModifier.squareFilled: ModContainer(ExpanderModifier.squareFilled),
    ExpanderModifier.squareOutlined:
        ModContainer(ExpanderModifier.squareOutlined),
  };
  ExpanderPosition _expanderPosition = ExpanderPosition.start;
  ExpanderType _expanderType = ExpanderType.caret;
  ExpanderModifier _expanderModifier = ExpanderModifier.none;
  bool _allowParentSelect = false;
  bool _supportParentDoubleTap = false;

  @override
  void initState() {
    _nodes = [
      Node(
        label: 'documents',
        key: 'docs',
        expanded: docsOpen,
        icon: NodeIcon(
          codePoint:
              docsOpen ? Icons.folder_open.codePoint : Icons.folder.codePoint,
          color: "blue",
        ),
        children: [
          Node(
              label: 'personal',
              key: 'd3',
              icon: NodeIcon.fromIconData(Icons.input),
              children: [
                Node(
                    label: 'Resume.docx',
                    key: 'pd1',
                    icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
                Node(
                    label: 'Cover Letter.docx',
                    key: 'pd2',
                    icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
              ]),
          Node(
            label: 'Inspection.docx',
            key: 'd1',
//          icon: NodeIcon.fromIconData(Icons.insert_drive_file),
          ),
          Node(
              label: 'Invoice.docx',
              key: 'd2',
              icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
        ],
      ),
      Node(
          label: 'MeetingReport.xls',
          key: 'mrxls',
          icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
      Node(
          label: 'MeetingReport.pdf',
          key: 'mrpdf',
          icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
      Node(
          label: 'Demo.zip',
          key: 'demo',
          icon: NodeIcon.fromIconData(Icons.archive)),
    ];
    _treeViewController = TreeViewController(
      children: _nodes,
      selectedKey: _selectedNode,
    );
    super.initState();
  }

  ListTile _makeExpanderPosition() {
    return ListTile(
      title: Text('Expander Position'),
      dense: true,
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionPositionOptions,
        groupValue: _expanderPosition,
        onValueChanged: (ExpanderPosition newValue) {
          setState(() {
            _expanderPosition = newValue;
          });
        },
      ),
    );
  }

  SwitchListTile _makeAllowParentSelect() {
    return SwitchListTile.adaptive(
      title: Text('Allow Parent Select'),
      dense: true,
      value: _allowParentSelect,
      onChanged: (v) {
        setState(() {
          _allowParentSelect = v;
        });
      },
    );
  }

  SwitchListTile _makeSupportParentDoubleTap() {
    return SwitchListTile.adaptive(
      title: Text('Support Parent Double Tap'),
      dense: true,
      value: _supportParentDoubleTap,
      onChanged: (v) {
        setState(() {
          _supportParentDoubleTap = v;
        });
      },
    );
  }

  ListTile _makeExpanderType() {
    return ListTile(
      title: Text('Expander Style'),
      dense: true,
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionTypeOptions,
        groupValue: _expanderType,
        onValueChanged: (ExpanderType newValue) {
          setState(() {
            _expanderType = newValue;
          });
        },
      ),
    );
  }

  ListTile _makeExpanderModifier() {
    return ListTile(
      title: Text('Expander Modifier'),
      dense: true,
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionModifierOptions,
        groupValue: _expanderModifier,
        onValueChanged: (ExpanderModifier newValue) {
          setState(() {
            _expanderModifier = newValue;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey.shade200,
        padding: EdgeInsets.all(20),
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              child: Column(
                children: <Widget>[
                  _makeExpanderPosition(),
                  _makeExpanderType(),
                  _makeExpanderModifier(),
                  _makeAllowParentSelect(),
                  _makeSupportParentDoubleTap(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                child: TreeView(
                  controller: _treeViewController,
                  allowParentSelect: _allowParentSelect,
                  supportParentDoubleTap: _supportParentDoubleTap,
                  onExpansionChanged: (key, expanded) =>
                      _expandNode(key, expanded),
                  onNodeTap: (key) {
                    debugPrint('Selected: $key');
                    setState(() {
                      _selectedNode = key;
                      _treeViewController =
                          _treeViewController.copyWith(selectedKey: key);
                    });
                  },
                  theme: TreeViewTheme(
                    expanderTheme: ExpanderThemeData(
                      type: _expanderType,
                      modifier: _expanderModifier,
                      position: _expanderPosition,
                      color: Colors.grey.shade800,
                      size: 20,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                    iconTheme: IconThemeData(
                      size: 18,
                      color: Colors.grey.shade800,
                    ),
                    colorScheme:
                        Theme.of(context).brightness == Brightness.light
                            ? ColorScheme.light(
                                primary: Colors.blue.shade50,
                                onPrimary: Colors.grey.shade900,
                                background: Colors.transparent,
                                onBackground: Colors.black,
                              )
                            : ColorScheme.dark(
                                primary: Colors.black26,
                                onPrimary: Colors.white,
                                background: Colors.transparent,
                                onBackground: Colors.white70,
                              ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Text(_treeViewController.getNode(_selectedNode) == null
                  ? ''
                  : _treeViewController.getNode(_selectedNode).label),
            )
          ],
        ),
      ),
    );
  }

  _expandNode(String key, bool expanded) {
    String msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    debugPrint(msg);
    Node node = _treeViewController.getNode(key);
    if (node != null) {
      List<Node> updated;
      if (key == 'docs') {
        updated = _treeViewController.updateNode(
          key,
          node.copyWith(
              expanded: expanded,
              icon: NodeIcon(
                codePoint: expanded
                    ? Icons.folder_open.codePoint
                    : Icons.folder.codePoint,
                color: expanded ? "blue600" : "grey700",
              )),
        );
      } else {
        updated = _treeViewController.updateNode(
            key, node.copyWith(expanded: expanded));
      }
      setState(() {
        if (key == 'docs') docsOpen = expanded;
        _treeViewController = _treeViewController.copyWith(children: updated);
      });
    }
  }
}

class ModContainer extends StatelessWidget {
  final ExpanderModifier modifier;

  const ModContainer(this.modifier, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _borderWidth = 0;
    BoxShape _shapeBorder = BoxShape.rectangle;
    Color _backColor = Colors.transparent;
    Color _backAltColor = Colors.grey.shade700;
    switch (modifier) {
      case ExpanderModifier.none:
        break;
      case ExpanderModifier.circleFilled:
        _shapeBorder = BoxShape.circle;
        _backColor = _backAltColor;
        break;
      case ExpanderModifier.circleOutlined:
        _borderWidth = 1;
        _shapeBorder = BoxShape.circle;
        break;
      case ExpanderModifier.squareFilled:
        _backColor = _backAltColor;
        break;
      case ExpanderModifier.squareOutlined:
        _borderWidth = 1;
        break;
    }
    return Container(
      decoration: BoxDecoration(
        shape: _shapeBorder,
        border: _borderWidth == 0
            ? null
            : Border.all(
                width: _borderWidth,
                color: _backAltColor,
              ),
        color: _backColor,
      ),
      width: 15,
      height: 15,
    );
  }
}