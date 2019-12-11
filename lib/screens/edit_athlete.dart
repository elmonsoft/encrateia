import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:provider/provider.dart';
import 'strava/strava_get_user.dart';

class EditAthleteScreen extends StatelessWidget {
  final Athlete athlete;

  const EditAthleteScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Athlete'),
      ),
      body: ChangeNotifierProvider.value(
        value: athlete,
        child: Consumer<Athlete>(
          builder: (context, athlete, _child) => ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              ListTile(
                leading: Text("First Name"),
                title: Text(athlete.db.firstName ?? ""),
              ),
              ListTile(
                leading: Text("Last Name"),
                title: Text(athlete.db.lastName ?? ""),
              ),
              ListTile(
                leading: Text("Strava ID"),
                title: Text(athlete.db.stravaId.toString() ?? ""),
              ),
              ListTile(
                leading: Text("Strava Username"),
                title: Text(athlete.db.stravaUsername ?? ""),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                initialValue: athlete.email,
                onChanged: (value) => athlete.email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                onChanged: (value) => athlete.password = value,
                initialValue: athlete.password,
                obscureText: true,
              ),

              // Strava Connection Card
              if (athlete.db.stravaId == null)
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.link_off),
                        title: Text('Strava Connection'),
                        subtitle: Text('This athlete is not connected to a '
                            'Strava User yet'),
                      ),
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('CONNECT TO STRAVA'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StravaGetUser(athlete: athlete),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

              // Cancel and Save Card
              Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text('Cancel', textScaleFactor: 1.5),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Container(width: 20.0),
                    RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text('Save', textScaleFactor: 1.5),
                      onPressed: () {
                        athlete.db.save();
                        athlete.store_credentials();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}