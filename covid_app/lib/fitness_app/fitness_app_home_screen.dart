import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/fitness_app/models/tabIcon_data.dart';
import 'package:covid_app/fitness_app/profile/profile_screen.dart';
import 'package:covid_app/fitness_app/traning/training_screen.dart';
import 'package:covid_app/model/HealthCard.dart';
import 'package:covid_app/services/getUserId.dart';
import 'package:covid_app/services/push_notification_service.dart';
import 'package:flutter/material.dart';
import '../get_covid_details.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'fintness_app_theme.dart';
import 'my_diary/my_diary_screen.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  const FitnessAppHomeScreen({Key key}) : super(key: key);

  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );

  @override
  void initState() {
    // PushNotificationsManager();
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    tabBody = MyDiaryScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            final _formKey = GlobalKey<FormState>();
            String bp;
            double oxygen;
            double pulse;
            double temp;
            DateTime date;
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter state) {
                  return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            width: double.infinity,
                            child: TextFormField(
                              // autofocus: true,
                              keyboardType: TextInputType.number,
                              maxLength: 20,
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: 'Blood Pressure',
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                              ),
                              key: ValueKey('Blood Pressure'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  // print("empty");
                                  return 'This field should not be empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                state(() {
                                  // print(value);
                                  bp = value;
                                });
                              },
                            ),
                          ),

                          Container(
                            // margin: EdgeInsets.symmetric(horizontal: 5),
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 15,
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: 'Oxygen',
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                              ),
                              key: ValueKey('Oxygen'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field should not be empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                state(() {
                                  oxygen = double.parse(value);
                                });
                              },
                            ),
                          ),
                          Container(
                            // margin: EdgeInsets.symmetric(horizontal: 5),
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 30,
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: 'Pulse',
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                              ),
                              key: ValueKey('Pulse'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                state(() {
                                  pulse = double.parse(value);
                                });
                              },
                            ),
                          ),
                          Container(
                            // margin: EdgeInsets.symmetric(horizontal: 5),
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: 'Temperature',
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                              ),
                              key: ValueKey('Temperature'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field should not be empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                state(() {
                                  temp = double.parse(value);
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            onPressed: () async {
                              final isValid = _formKey.currentState.validate();
                              if (isValid) {
                                _formKey.currentState.save();

                                await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(getUserId())
                                    .collection('HealthCard')
                                    .add(HealthCard(bp: bp,oxygen: oxygen,pulse: pulse,temp: temp, date: DateTime.now()).toMap());

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Added Details Successfully"),
                                  backgroundColor: Colors.green,
                                ));

                                Navigator.of(context).pop();
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  'Submit',
                                  textAlign: TextAlign.center,
                                )),
                          )
                        ]),
                      ),
                    ),
                  );
                });
              },
            );
          },
          changeIndex: (int index) {
            if (index == 0 || index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MyDiaryScreen(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MapScreen();
                });
              });
            } else if (index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = UpdateProfileScreen(
                      animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
