import 'package:flutter/material.dart';

import '../models/opening.dart';
import '../services/openings_service.dart';
import '../widgets/speed_dial_fab.dart';
import '../widgets/text_hero.dart';
import 'opening_detail_page.dart';

class OpeningListPage extends StatefulWidget {
  OpeningListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OpeningListPageState createState() => _OpeningListPageState();
}

class _OpeningListPageState extends State<OpeningListPage>
    with SingleTickerProviderStateMixin {
  List<Opening> _openingList;
  AnimationController _fabAnimationController;
  List<SpeedDialFabData> childFabs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    childFabs = <SpeedDialFabData>[
      SpeedDialFabData(
        iconData: Icons.filter_list,
        action: openSortMenu,
        tooltipText: "Filter",
      ),
      SpeedDialFabData(
        iconData: Icons.sort,
        action: openSortMenu,
        tooltipText: "Sort",
      ),
      SpeedDialFabData(
        iconData: Icons.search,
        action: openSortMenu,
        tooltipText: "Search",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: buildContent(),
        ),
      ),
      floatingActionButton: new SpeedDialFab(
        Icons.menu,
        childFabs,
        _fabAnimationController,
      ),
    );
  }

  Widget buildError(Object error) {
    var ex = error as Exception;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Error: " + ex.toString(),
          textAlign: TextAlign.center,
        ),
        RaisedButton(
          onPressed: () {
            setState(() {});
          },
          child: Text(
            "Retry",
          ),
        ),
      ],
    );
  }

  Widget buildList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        var openingData = _openingList[index];
        var title = openingData.source + " - " + openingData.title;
        var song = openingData.song;
        var subtitle = song != null
            ? Text(
                song.title,
                style: TextStyle(
                  fontSize: 12.0,
                ),
              )
            : null;

        return Container(
          decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.green, width: 0.25)),
          ),
          child: ListTile(
            title: TextHero(
              title,
              style: TextStyle(
                fontFamily: "Roboto",
                decoration: TextDecoration.none,
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            subtitle: subtitle,
            onTap: () => openDetail(title, openingData),
          ),
        );
      },
      itemCount: _openingList.length,
      shrinkWrap: true,
    );
  }

  Widget buildContent() {
    if (_openingList == null) {
      return FutureBuilder<List<Opening>>(
        future: OpeningsService.getOpeningList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return buildError(snapshot.error);
              }
              _openingList = snapshot.data;
              return buildList();
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
          }
        },
      );
    } else {
      return buildList();
    }
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: new Material(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop("A");
            },
            child: Text("A"),
          ),
        ),
      ),
    );
  }

  void openDetail(String title, Opening openingData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return OpeningDetailPage(
            title: title,
            openingData: openingData,
          );
        },
      ),
    );
  }

  void openSortMenu() async {
    var sortVal = await showModalBottomSheet(
      context: context,
      builder: (context) => buildBottomSheet(context),
    );
    print(sortVal);
  }
}
