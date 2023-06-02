import 'package:exhalapp/pages/homepage/homepage.dart';
import 'package:exhalapp/providers/shared_pref.dart';
import 'package:exhalapp/utils/storage_helper.dart';
import 'package:exhalapp/widgets/export_page/cut_method_card.dart';
import 'package:exhalapp/widgets/export_page/data_card.dart';
import 'package:exhalapp/widgets/export_page/frec_resp.dart';
import 'package:exhalapp/widgets/export_page/max_card.dart';
import 'package:exhalapp/widgets/export_page/notes_card.dart';
import 'package:exhalapp/widgets/export_page/time_card.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({
    super.key,
    required this.fullDataList,
    required this.fullDataString,
    required this.corte,
    required this.tiempo,
    required this.totales,
    required this.maximo,
    required this.notas,
  });
  final List fullDataList;
  final String fullDataString;
  final String corte;
  final String tiempo;
  final String totales;
  final String maximo;
  final List notas;

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {

  bool creatingFile = false;
  String stringNotas = "";
  bool enableExport = true;
  // ignore: non_constant_identifier_names
  DateTime pre_backpress = DateTime.now().subtract(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double hxw = width * height;

    return WillPopScope(
      onWillPop: () async{
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= const Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if(cantExit){
          //show snackbar
          const snack = SnackBar(content: Center(child: Text('Presiona "atrás" otra vez para salir.')),duration: Duration(seconds: 2),);
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Resumen exámen",
                style: TextStyle(
                  fontSize: hxw * 0.00009,
                  fontWeight: FontWeight.w200
                ),
              ),
              Icon(
                Icons.article,
                color: const Color(0xFF00C0FF),
                size: hxw * 0.0001,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.03,
                          left: width * 0.01,
                          right: width * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DataCard(valor: widget.totales),
                            const FrecRespCard(valor: "99999"),
                          ],
                        ),
                      ),
              
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.01,
                          right: width * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TimeCard(valor: widget.tiempo),
                            CutMethodCard(valor: widget.corte),
                          ],
                        ),
                      ),
              
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.01,
                          right: width * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaxCard(valor: widget.maximo),
                            NotesCard(valor: widget.notas.length.toString(), notas: widget.notas,),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
              
                      (creatingFile == false)
                        ?ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular((height * width) * 0.00006),
                            ),
                            backgroundColor: const Color(0xFFBDEFFF),
                            foregroundColor: const Color(0xFF009ACC),
                            side: const BorderSide(
                              color: Color(0xFF00C0FF),
                            ),
                          ),
                          onPressed: (enableExport == true)? () async {
                            if (await Permission.manageExternalStorage.isGranted) {
                              setState(() {
                                creatingFile = true;
                              });
                              /* se exportan los datos */
                              StorageHelper.writeTextToFile(widget.fullDataString.toString()).then((value){
                                for (var note in widget.notas) {
                                  stringNotas = "$stringNotas${note.toString().substring(0,5)}";
                                  stringNotas = "$stringNotas,";
                                  stringNotas = "$stringNotas${note.toString().substring(5, note.toString().length)};\n";
                                }
                                StorageHelper.writeNotesToFile(stringNotas);

                                setState(() {
                                  creatingFile = false;
                                  enableExport = false;
                                });
                                const snack = SnackBar(
                                  content:  Center(child: Text('Datos exportados satisfactoriamente.')),duration: Duration(seconds: 2),);
                                return ScaffoldMessenger.of(context).showSnackBar(snack);
                              });
                            } else {
                              storagePermissionDialog();
                            }
                          }:null,
                          child: const Text("Exportar datos")
                        )
                        :const CircularProgressIndicator(),

                      Padding(
                        padding: EdgeInsets.all(hxw * 0.00005),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C0FF),
                            shape: const CircleBorder()
                          ),
                          onPressed: (){
                            if (enableExport == true) {
                              _backWithoutExportDialog();
                            } else {
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomePage()), (Route route) => false);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(hxw * 0.00005),
                            child: Image.asset(
                              'assets/icons/HOME.png',
                              height: height * 0.045,
                            ),
                          )
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/* ======================================== STORAGE-PERMISSION-DIALOG ======================================== */
  Future<bool> storagePermissionDialog() {

    double width = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        icon: const Icon(Icons.folder_outlined),
        title: const Text('Almacenamiento'),
        content: const Text(
          'Debe conceder permiso en su dispositivo para almacenar archivos.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xFFBDEFFF)),
              overlayColor: MaterialStateProperty.all(const Color.fromARGB(255, 113, 170, 187)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFF0071E4))
                ),
              ),
            ),
            onPressed: (){
              Permission.manageExternalStorage.request();
              Navigator.of(context).pop(false);
            },
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
              child: const Text(
                "Ir a ajustes",
                style: TextStyle(
                  color: Color(0xFF2F2F2F)
                ),
              ),
            ),
          ),
        ],
      ),
    ).then((value) => false);
  }
/* ======================================== END STORAGE-PERMISSION-DIALOG ======================================== */

/* ======================================== BACK-WITOUTH-EXPORT-DIALOG ======================================== */
  Future<bool> _backWithoutExportDialog() {

    final prefs = UserPrefs();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular((height * width) * 0.0001),
          side: BorderSide(
            color: (prefs.darkMode)
              ?const Color(0xFF0071E4)
              :const Color(0xFFD3D3D3)
          )
        ),
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: (prefs.darkMode)
          ?const Color(0xFF474864)
          :Colors.white,
        title: Text(
          '¿Estás seguro?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '¿Desea volver al inicio sin exportar los datos del exámen?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w300,
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xFF0071E4)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular((height*width) * 0.00007)
                )
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No')
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 75, 62)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular((height*width) * 0.00007)
                )
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomePage()), (Route route) => false);
            },
            child: const Text('Si')
          ),
        ],
      ),
    ).then((value) => false);
  }
/* ======================================== END BACK-WITOUTH-EXPORT-DIALOG ======================================== */
}