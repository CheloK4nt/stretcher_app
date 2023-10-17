import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:stretcherapp/pages/charts_page/hidden_charts_page.dart';
import 'package:stretcherapp/providers/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

class HiddenLineChartExportPage extends StatefulWidget {

  const HiddenLineChartExportPage({
    super.key,
    required this.seriesList,
    required this.segundosTranscurridos,
    required this.minutosTranscurridos,
    required this.dataList,
  });
  final List<Series<MyData, num>> seriesList;
  final int segundosTranscurridos;
  final int minutosTranscurridos;
  final List<MyData> dataList;

  @override
  State<HiddenLineChartExportPage> createState() => _HiddenLineChartExportPageState();
}

class _HiddenLineChartExportPageState extends State<HiddenLineChartExportPage> {
  @override
  Widget build(BuildContext context) {

    final prefs = UserPrefs();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hxw = height * width;

    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(hxw * 0.00003),
        child: charts.LineChart(
          widget.seriesList,
          animate: false,
          defaultRenderer: charts.LineRendererConfig(
            includePoints: false,
            includeArea: true,
            areaOpacity: 0.35
          ),
          primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                color: (prefs.darkMode)
                  ?charts.MaterialPalette.white
                  :charts.MaterialPalette.black,
              )
            ),
            tickProviderSpec: 
              const charts.StaticNumericTickProviderSpec(
              [
                charts.TickSpec(0, label: "0"),
                charts.TickSpec(5, label: "5"),
                charts.TickSpec(10, label: "10"),
                charts.TickSpec(15, label: "15"),
                charts.TickSpec(20, label: "20"),
                charts.TickSpec(25, label: "25"),
                charts.TickSpec(30, label: "30"),
                charts.TickSpec(35, label: "35"),
                charts.TickSpec(40, label: "40"),
                charts.TickSpec(45, label: "45"),
                charts.TickSpec(50, label: "50"),
              ]
            )
          ),
          domainAxis: charts.NumericAxisSpec(
            /* ========== MENOS DE 1 MINUTO ========== */
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                color: (prefs.darkMode)
                  ?charts.MaterialPalette.white
                  :charts.MaterialPalette.black,
              )
            ),
            tickProviderSpec: (widget.minutosTranscurridos < 1)    
            ? charts.StaticNumericTickProviderSpec(
              [
                charts.TickSpec(widget.dataList.last.xValue, label: (widget.segundosTranscurridos < 10)
                  ? "⏱ 00:0${widget.segundosTranscurridos}"
                  : "⏱ 00:${widget.segundosTranscurridos}"
                ),
              ]
            )
            /* ================================================== */
            /* ========== MAS o IGUAL a 1 MINUTO ========== */
            : charts.StaticNumericTickProviderSpec(
              [
                charts.TickSpec(widget.dataList.last.xValue, label: (widget.minutosTranscurridos < 10)
                ?(widget.segundosTranscurridos < 10)
                  ? "⏱ 0${widget.minutosTranscurridos}:0${widget.segundosTranscurridos}"
                  : "⏱ 0${widget.minutosTranscurridos}:${widget.segundosTranscurridos}"
                :(widget.segundosTranscurridos < 10)
                  ? "⏱ ${widget.minutosTranscurridos}:0${widget.segundosTranscurridos}"
                  : "⏱ ${widget.minutosTranscurridos}:${widget.segundosTranscurridos}"
                ),
              ]
            )
            /* ================================================== */
          ),
        ),
      ),
    );
  }
}