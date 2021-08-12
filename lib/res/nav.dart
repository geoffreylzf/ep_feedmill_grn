import 'package:ep_grn/animation/route_slide_right.dart';
import 'package:ep_grn/notifiers/user_repository_notifier.dart';
import 'package:ep_grn/pages/doc_grn/index.dart';
import 'package:ep_grn/pages/setting.dart';
import 'package:ep_grn/pages/update_app_ver.dart';
import 'package:ep_grn/widgets/simple_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawerStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserRepositoryNotifier>(context).userProfile;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Icon(Icons.account_circle, color: Colors.white),
                          ),
                          Text(userProfile.fullName, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.history),
            title: Text('Good Receive Note'),
            onTap: () async {
              Navigator.push(
                context,
                SlideRightRoute(widget: DocGrnIndexPage()),
              );
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.settings),
            title: Text('Setting'),
            onTap: () async {
              Navigator.push(
                context,
                SlideRightRoute(widget: SettingsPage()),
              );
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.update),
            title: Text('Update App Version'),
            onTap: () async {
              Navigator.push(
                context,
                SlideRightRoute(widget: UpdateAppVerPage()),
              );
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign out'),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return SimpleConfirmDialog(
                    title: "Sign out?",
                    message: "Confirm?",
                    btnPositiveText: 'Sign out',
                    vcb: () async {
                      Provider.of<UserRepositoryNotifier>(context, listen: false).signOut();
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
