import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/opening.dart';
import '../models/opening_filter_type.dart';
import '../services/openings_service.dart';
import '../viewModels/opening_list_viewmodel.dart';
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
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  OpeningListViewModel _viewModel;
  AnimationController _fabAnimationController;
  List<SpeedDialFabData> childFabs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel = OpeningListViewModel();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    childFabs = <SpeedDialFabData>[
      SpeedDialFabData(
        iconData: Icons.filter_list,
        action: openFilterMenu,
        tooltipText: "Filter",
      ),
      SpeedDialFabData(
        iconData: Icons.sort,
        action: () => _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Coming Soon"),
            )),
        tooltipText: "Sort",
      ),
      SpeedDialFabData(
        iconData: Icons.search,
        action: () => _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Coming Soon"),
            )),
        tooltipText: "Search",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OpeningListViewModel>(
      model: _viewModel,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: buildContent(),
        ),
        floatingActionButton: SpeedDialFab(
          Icons.menu,
          controller: _fabAnimationController,
          childFabs: childFabs,
        ),
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
    return new ScopedModelDescendant<OpeningListViewModel>(
      builder: (context, child, model) {
        return ListView.builder(
          itemBuilder: (context, index) {
            var openingData = model.openingList[index];
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
                border: Border(
                    bottom: BorderSide(color: Colors.green, width: 0.25)),
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
          itemCount: model.openingList.length,
          shrinkWrap: true,
        );
      },
    );
  }

  Widget buildContent() {
    return Container(
      child: _viewModel.openingListSource == null
          ? FutureBuilder<List<Opening>>(
              future: OpeningsService.getOpeningList(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return buildError(snapshot.error);
                    }
                    _viewModel.openingListSource = snapshot.data;
                    return buildList();
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                }
              },
            )
          : buildList(),
    );
  }

  Widget buildFilterBottomSheet(BuildContext context) {
    var widgets = _viewModel.filterOptions.keys
        .map((x) => buildFilterOptionItem(x))
        .toList();
    var clearButton = buildButton("Clear", clearFilter);
    var saveButton = buildButton("Filter", saveFilter);
    var buttonContainer = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        clearButton,
        saveButton,
      ],
    );
    widgets.add(buttonContainer);
    return ScopedModel<OpeningListViewModel>(
      model: _viewModel,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        ),
      ),
    );
  }

  Widget buildButton(String label, VoidCallback action) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      onPressed: action,
      child: Text(
        label,
        style: Theme.of(context).accentTextTheme.button,
      ),
    );
  }

  Widget buildFilterOptionItem(String label) {
    return ScopedModelDescendant<OpeningListViewModel>(
      builder: (context, child, model) {
        return Material(
          child: InkWell(
            onTap: () => model.toggleFilter(label, !model.filterOptions[label]),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: model.filterOptions[label],
                  onChanged: (value) {
                    model.toggleFilter(label, value);
                  },
                ),
                Text(label),
              ],
            ),
          ),
        );
      },
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

  void openFilterMenu() async {
    var filterVal = await showModalBottomSheet(
      context: context,
      builder: (context) => buildFilterBottomSheet(context),
    );
    if (filterVal == null) {
      _viewModel.resetFilter();
    }
    _viewModel.currentFilter = filterVal;
    _viewModel.filterOpenings();
  }

  void clearFilter() {
    _viewModel.resetFilter();
    Navigator.of(context).pop(OpeningFilterType.None);
  }

  void saveFilter() {
    var filter = _viewModel.filterOptions;
    var result = OpeningFilterType.None;
    if (filter["Opening"] && filter["Ending"]) {
      result = OpeningFilterType.None;
    } else if (filter["Opening"]) {
      result = OpeningFilterType.Opening;
    } else if (filter["Ending"]) {
      result = OpeningFilterType.Ending;
    }
    Navigator.of(context).pop(result);
  }
}
