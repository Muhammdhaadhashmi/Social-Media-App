import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  double _brightness = 0.5;
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blue, // Change the app bar color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Account Settings'),
            _buildNotificationSetting(),
            _buildPrivacySetting(),
            _buildSectionHeader('Display Settings'),
            _buildBrightnessSetting(),
            _buildFontSizeSetting(),
            // Add more settings widgets here
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.blue, // Change the section header color
        ),
      ),
    );
  }

  Widget _buildNotificationSetting() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.notifications),
        title: Text(
          'Enable Notifications',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        trailing: Switch(
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPrivacySetting() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.privacy_tip),
        title: Text(
          'Privacy Settings',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        onTap: () {
          // Add privacy settings logic here
        },
      ),
    );
  }

  Widget _buildBrightnessSetting() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.brightness_medium),
            title: Text(
              'Brightness',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Slider(
            value: _brightness,
            onChanged: (value) {
              setState(() {
                _brightness = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeSetting() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text(
              'Font Size',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Slider(
            value: _fontSize,
            min: 12.0,
            max: 24.0,
            onChanged: (value) {
              setState(() {
                _fontSize = value;
              });
            },
          ),
        ],
      ),
    );
  }
}





// import 'package:flutter/material.dart';
//
// class SettingsScreen extends StatefulWidget {
//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   bool _notificationsEnabled = true;
//   double _brightness = 0.5;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionHeader('Account Settings'),
//             _buildNotificationSetting(),
//             _buildPrivacySetting(),
//             _buildSectionHeader('Display Settings'),
//             _buildBrightnessSetting(),
//             _buildFontSizeSetting(),
//             // Add more settings widgets here
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 18.0,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNotificationSetting() {
//     return Card(
//       child: ListTile(
//         leading: Icon(Icons.notifications),
//         title: Text('Enable Notifications'),
//         trailing: Switch(
//           value: _notificationsEnabled,
//           onChanged: (value) {
//             setState(() {
//               _notificationsEnabled = value;
//             });
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPrivacySetting() {
//     return Card(
//       child: ListTile(
//         leading: Icon(Icons.privacy_tip),
//         title: Text('Privacy Settings'),
//         onTap: () {
//           // Add privacy settings logic here
//         },
//       ),
//     );
//   }
//
//   Widget _buildBrightnessSetting() {
//     return Card(
//       child: Column(
//         children: [
//           ListTile(
//             leading: Icon(Icons.brightness_medium),
//             title: Text('Brightness'),
//           ),
//           Slider(
//             value: _brightness,
//             onChanged: (value) {
//               setState(() {
//                 _brightness = value;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFontSizeSetting() {
//     return Card(
//       child: Column(
//         children: [
//           ListTile(
//             leading: Icon(Icons.text_fields),
//             title: Text('Font Size'),
//           ),
//           Slider(
//             value: _brightness,
//             onChanged: (value) {
//               setState(() {
//                 _brightness = value;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
