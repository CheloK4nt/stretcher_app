import 'package:stretcherapp/providers/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotesCard extends StatefulWidget {
  const NotesCard({super.key, required this.valor, required this.notas});
  final String valor;
  final List notas;

  @override
  State<NotesCard> createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {

  final prefs = UserPrefs();

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double hxw = width * height;

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(hxw * 0.000061),
              topRight: Radius.circular(hxw * 0.000061),
            )
          ),
          color: (prefs.darkMode)
            ?const Color(0xFF474864)
            :const Color(0xFFE0E0E0),
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(hxw * 0.000061),
              topLeft: Radius.circular(hxw * 0.000061),
            ),
            splashColor: const Color(0xFFC8E3FF),
            highlightColor: const Color(0xFFC8E3FF),
            onTap: (){
              if (widget.notas.isEmpty) {
                Fluttertoast.cancel();
                Fluttertoast.showToast(
                  msg: "No hay notas agregadas",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
              } else {
                _showNotes();
              }
            },
            child: SizedBox(
              width: width * 0.39,
              height: height * 0.15,
              child: Column(
                children: [
                  
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      width * 0.01,
                      height * 0.03,
                      width * 0.01,
                      0,
                    ),
                    child: Image.asset(
                      'assets/images/notas.png',
                      height: height * 0.05,
                    ),
                  ),
                  
                  Padding(
                    padding: EdgeInsets.all(hxw * 0.000025),
                    child: Text(widget.valor,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                        fontSize: hxw * 0.000101,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(
          width: width * 0.39,
          height: height * 0.04,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0071E4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(hxw * 0.000061),
                bottomRight: Radius.circular(hxw * 0.000061),
              )
            ),
            child:  Center(
              child: Text(
                "Ver notas",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: hxw * 0.000045,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _showNotes() {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double hxw = width * height;

    Color light = const Color.fromARGB(255, 201, 226, 252);
    Color lshade = const Color.fromARGB(255, 225, 240, 255);
    Color dark = const Color.fromARGB(255, 50, 50, 71);
    Color dshade = const Color.fromARGB(255, 59, 59, 83);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: const EdgeInsets.all(2),
        insetPadding: EdgeInsets.zero,
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(width * 0.03)
          )
        ),
        backgroundColor: (prefs.darkMode)
          ?const Color(0xFF474864)
          :Colors.white,

        /* -------------------- TITLE -------------------- */
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Notas",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: hxw * 0.000065,
                  ),
                ),
                Icon(
                  Icons.note_alt_outlined,
                  color: const Color(0xFF0071E4),
                  size: hxw * 0.0001,
                )
              ],
            ),
            const Divider(
              color: Color(0xFF0071E4),
              thickness: 3,
              height: 10,
            ),
          ],
        ),
        /* -------------------- END TITLE -------------------- */

        /* -------------------- CONTENT -------------------- */
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: Colors.transparent,
            shape: ContinuousRectangleBorder(
              side: BorderSide(
                color: (prefs.darkMode)
                  ?dark
                  :light,
                width: 2,
              )
            ),
            child: SizedBox(
              height: height * 0.5,
              width: width * 0.6,
              child: ListView.builder(
                itemCount: widget.notas.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      backgroundColor: (prefs.darkMode)
                        ?dark
                        :light,
                      collapsedBackgroundColor: (prefs.darkMode)
                        ?dshade
                        :lshade,
                      collapsedShape: ContinuousRectangleBorder(
                        side: BorderSide(
                          color: (prefs.darkMode)
                            ?dark
                            :light,
                          width: 2,
                        )
                      ),
                      iconColor: const Color(0xFF0071E4),
                      textColor: const Color(0xFF0071E4),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Nota ${index + 1}",
                          )
                          ,
                          Text(
                            widget.notas[index].toString().substring(0,5),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300
                            ),
                          )
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.notas[index].toString().substring(5)),
                        )
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
        ),
        /* -------------------- END CONTENT -------------------- */


        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0071E4),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(
                side: BorderSide(color: Colors.transparent)
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('OK')
          ),
        ],
      ),
    ).then((value) => false);
  }
}
