import 'package:flutter/material.dart';
import 'package:statsense/UI/teamdetails.dart';
import 'package:statsense/utils/styles.dart';
import '../managers/function_manager.dart';
import '../model/team.dart';

class StreamerScore extends StatefulWidget {
  const StreamerScore({Key? key}) : super(key: key);

  @override
  _StreamerScoreState createState() => _StreamerScoreState();
}

class _StreamerScoreState extends State<StreamerScore> {
  final FunctionManager appFunction = FunctionManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streamer Scores',
        style: AppBarStyle.appBarText,
        ),
        titleSpacing: 20,
        backgroundColor: AppBarStyle.appBarBackground,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10.0),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.0),
          ),
        ),
      ),
      body: FutureBuilder(
        future: appFunction.readDataFromFile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error: Could not fetch streamer score data...'),
            );
          } else {
            return buildStreamerScores(appFunction.teamMap);
          }
        },
      ),
    );
  }

  Widget buildStreamerScores(Map<String, Team> teamMap) {
    final teamsByScore = teamMap.values.toList()
      ..sort((a, b) => b.streamerScore.compareTo(a.streamerScore));

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
      itemCount: teamsByScore.length,
      itemBuilder: (context, index) {
        final Team team = teamsByScore[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeamDetails(team: team)
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 2,
              margin: EdgeInsets.all(4.0),
              color: Colors.transparent,
              child: Container(
                decoration: CardStyle.cardBackground,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Image.asset(
                              team.getLogoURL(),
                              height: 40,
                              width: 40,
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${team.teamName}',
                                style: BodyTextStyle.bodyTextStyleBold,
                              ),
                              Text(
                                '${team.streamerScore.toStringAsFixed(2)}%',
                                style: BodyTextStyle.bodyTextStyleReg,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Total Games: ${team.totalGames}',
                        style: BodyTextStyle.bodyTextStyleReg,
                      ),
                      Text(
                        'Off Day Games: ${team.offDays}',
                        style: BodyTextStyle.bodyTextStyleReg,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}