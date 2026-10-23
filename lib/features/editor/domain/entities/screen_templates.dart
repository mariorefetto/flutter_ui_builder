import 'package:flutter_ui_builder/features/editor/domain/entities/new_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';

/// Screens the app can start a new one from.
enum ScreenTemplate { blank, login, settings, profile, inbox, onboarding }

/// The widgets of a new screen made from [template]. Every one is a screen of
/// its own, with a Scaffold, ready to be changed.
WidgetNode screenTemplateRoot(ScreenTemplate template) => switch (template) {
  ScreenTemplate.blank => createEmptyDocument().root,
  ScreenTemplate.login => _login(),
  ScreenTemplate.settings => _settings(),
  ScreenTemplate.profile => _profile(),
  ScreenTemplate.inbox => _inbox(),
  ScreenTemplate.onboarding => _onboarding(),
}.renumbered(0);

const double _page = 24;

// Ids are given once the tree is built, so these only describe it.
WidgetNode _n(
  String type, {
  Map<String, Object?> props = const {},
  List<WidgetNode> children = const [],
}) => WidgetNode(id: '', type: type, props: props, children: children);

WidgetNode _text(String text, {double? size, String? weight, String? align}) =>
    _n(
      'Text',
      props: {
        'text': text,
        'fontSize': ?size,
        'fontWeight': ?weight,
        'textAlign': ?align,
      },
    );

WidgetNode _gap(double height) => _n('SizedBox', props: {'height': height});

WidgetNode _appBar(String title) => _n('AppBar', props: {'title': title});

List<double> _all(double value) => [value, value, value, value];

WidgetNode _login() => _n(
  'Scaffold',
  children: [
    _appBar('Sign in'),
    _n(
      'Padding',
      props: {'padding': _all(_page)},
      children: [
        _n(
          'Column',
          props: const {
            'mainAxisAlignment': 'center',
            'crossAxisAlignment': 'stretch',
          },
          children: [
            _n('Icon', props: const {'icon': 'lock_outline', 'size': 64.0}),
            _gap(16),
            _text('Welcome back', size: 24, weight: 'bold', align: 'center'),
            _gap(24),
            _n('TextField', props: const {'labelText': 'Email'}),
            _gap(12),
            _n(
              'TextField',
              props: const {'labelText': 'Password', 'obscureText': true},
            ),
            _gap(24),
            _n('ElevatedButton', children: [_text('Sign in')]),
            _n('TextButton', children: [_text('Create an account')]),
          ],
        ),
      ],
    ),
  ],
);

WidgetNode _settingsTile(String icon, String title, String subtitle) => _n(
  'ListTile',
  props: {
    'leading': icon,
    'title': title,
    'subtitle': subtitle,
    'trailing': 'chevron_right',
  },
);

WidgetNode _settings() => _n(
  'Scaffold',
  children: [
    _appBar('Settings'),
    _n(
      'ListView',
      children: [
        _settingsTile('person_outline', 'Account', 'Profile and security'),
        _n('Divider'),
        _settingsTile(
          'notifications_none',
          'Notifications',
          'Sounds and alerts',
        ),
        _n('Divider'),
        _settingsTile('language', 'Language', 'English'),
        _n('Divider'),
        _settingsTile('info_outline', 'About', 'Version and licences'),
      ],
    ),
  ],
);

WidgetNode _contact(String icon, String title, String subtitle) => _n(
  'Card',
  children: [
    _n(
      'ListTile',
      props: {'leading': icon, 'title': title, 'subtitle': subtitle},
    ),
  ],
);

WidgetNode _profile() => _n(
  'Scaffold',
  children: [
    _appBar('Profile'),
    _n(
      'Column',
      props: const {'crossAxisAlignment': 'center'},
      children: [
        _gap(_page),
        _n(
          'CircleAvatar',
          props: const {'radius': 48.0},
          children: [
            _n('Icon', props: const {'icon': 'person', 'size': 48.0}),
          ],
        ),
        _gap(16),
        _text('Jane Doe', size: 22, weight: 'bold'),
        _text('Designer'),
        _gap(_page),
        _contact('mail_outline', 'Email', 'jane@example.com'),
        _contact('phone', 'Phone', '+1 555 0100'),
        _gap(_page),
        _n('ElevatedButton', children: [_text('Edit profile')]),
      ],
    ),
  ],
);

WidgetNode _message(String sender, String preview) => _n(
  'ListTile',
  props: {'leading': 'mail_outline', 'title': sender, 'subtitle': preview},
);

WidgetNode _inbox() => _n(
  'Scaffold',
  children: [
    _appBar('Inbox'),
    _n(
      'ListView',
      children: [
        _message('Ada', 'The designs are ready for review'),
        _message('Grace', 'Lunch on Thursday?'),
        _message('Linus', 'Merged your changes'),
        _message('Margaret', 'Notes from the meeting'),
        _message('Alan', 'Welcome aboard'),
      ],
    ),
    _n(
      'FloatingActionButton',
      props: const {'icon': 'edit', 'tooltip': 'Compose'},
    ),
  ],
);

WidgetNode _onboarding() => _n(
  'Scaffold',
  children: [
    _n(
      'Padding',
      props: {'padding': _all(32)},
      children: [
        _n(
          'Column',
          props: const {'crossAxisAlignment': 'stretch'},
          children: [
            _n('Spacer'),
            _n('Icon', props: const {'icon': 'rocket_launch', 'size': 96.0}),
            _gap(24),
            _text(
              'Everything in one place',
              size: 28,
              weight: 'bold',
              align: 'center',
            ),
            _gap(12),
            _text(
              'Build, share and keep track of what matters to you.',
              align: 'center',
            ),
            _n('Spacer'),
            _n('ElevatedButton', children: [_text('Get started')]),
            _n('TextButton', children: [_text('Skip')]),
          ],
        ),
      ],
    ),
  ],
);
