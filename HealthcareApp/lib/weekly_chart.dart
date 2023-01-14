import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:healthcareapp/stat_controller.dart';
import 'package:healthcareapp/data/daily_stat_ui_model.dart';

class WeeklyChart extends StatelessWidget {
  var statController = Get.put(StatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // title: const Text(
        //   'Your Monthly Progress',
        //   style: TextStyle(color: Colors.black),
        // ),
        leadingWidth: 100,
        backgroundColor: Color(0xFFE8E8E8),
        automaticallyImplyLeading: false,
        leading: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          label: const Text("Back", style: TextStyle(color: Color(0xFFE8E8E8)),),
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: _buildGraphStat(),
          ),
          _pageIndicatorText(),
          _previousWeekButton(),
          _nextWeekButton(),
        ],
      ),
    );
  }

  Widget _buildGraphStat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Week 1',
          'Steps',
        ),
        Obx(
              () => _buildWeekIndicators(statController.dailyStatList1.call(), 1),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Divider(),
        ),
        _buildSectionTitle(
          'Week 2',
          'unit',
        ),
        Obx(
              () => _buildWeekIndicators(statController.dailyStatList2.call(), 2),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Divider(),
        ),
        _buildSectionTitle(
          'Week 3',
          'unit',
        ),
        Obx(
              () => _buildWeekIndicators(statController.dailyStatList3.call(), 3),
        ),
        SizedBox(
          height: 64.0,
        )
      ],
    );
  }

  Widget _pageIndicatorText() {
    return Obx(() => Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Theme.of(Get.context!).primaryColor,
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(
                statController.currentWeek.value,
                style: Theme.of(Get.context!).textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                  fontSize: 17.0,
                ),
              ),
            ),
          ),
        )));
  }

  Widget _previousWeekButton() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: RawMaterialButton(
          onPressed: () {
            statController.onPreviousWeek();
          },
          elevation: 2.0,
          fillColor: Theme.of(Get.context!).primaryColor,
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(8.0),
          shape: CircleBorder(),
        ),
      ),
    );
  }

  Widget _nextWeekButton() {
    return Obx(
          () => Visibility(
        visible: statController.displayNextWeekBtn.value,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: RawMaterialButton(
              onPressed: () {
                statController.onNextWeek();
              },
              elevation: 2.0,
              fillColor: Theme.of(Get.context!).primaryColor,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(8.0),
              shape: CircleBorder(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subTitle) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(Get.context!).textTheme.headline3,
            ),
          ),
          Text(
            subTitle,
            style: Theme.of(Get.context!).textTheme.bodyText1,
          )
        ],
      ),
    );
  }

  Widget _buildWeekIndicators(List<DailyStatUiModel> models, int type) {
    if (models.length == 7) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SizedBox(
          height: 152,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildDayIndicator(models[0], type),
              _buildDayIndicator(models[1], type),
              _buildDayIndicator(models[2], type),
              _buildDayIndicator(models[3], type),
              _buildDayIndicator(models[4], type),
              _buildDayIndicator(models[5], type),
              _buildDayIndicator(models[6], type),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildDayIndicator(DailyStatUiModel model, int type) {
    final width = 14.0;
    return InkWell(
      onTap: () =>
          statController.setSelectedDayPosition(model.dayPosition, type),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48.0,
            height: 24.0,
            child: Visibility(
              visible: model.isSelected,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Theme.of(Get.context!).accentColor,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(
                      '${model.stat} unit',
                      textAlign: TextAlign.center,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 12.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Expanded(
            child: NeumorphicIndicator(
              width: width,
              percent: statController.getStatPercentage(model.stat, type),
            ),
          ),
          SizedBox(height: 8.0),
          DecoratedBox(
            decoration: _getDayDecoratedBox(model.isToday),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                model.day,
                style: Theme.of(Get.context!).textTheme.bodyText1!.copyWith(
                  fontSize: 13,
                  color: model.isToday
                      ? Theme.of(Get.context!).splashColor
                      : Theme.of(Get.context!).primaryColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _getDayDecoratedBox(bool isToday) {
    if (isToday) {
      return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        color: Theme.of(Get.context!).primaryColor,
      );
    } else {
      return BoxDecoration();
    }
  }
}