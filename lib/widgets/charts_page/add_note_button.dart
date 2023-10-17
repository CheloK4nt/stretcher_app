import 'package:stretcherapp/providers/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddNoteBTN extends StatefulWidget {
  const AddNoteBTN({super.key, required this.notas, required this.tiempo});
  final List notas;
  final String tiempo;

  @override
  State<AddNoteBTN> createState() => _AddNoteBTNState();
}

class _AddNoteBTNState extends State<AddNoteBTN> {
  
  setTiempo (){
    String tiempoNota = widget.tiempo;
    return tiempoNota;
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
        top: height * 0.015,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00C0FF),
          shape: const StadiumBorder(),
        ),
        onPressed: () => addNoteDialog(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add, color: Colors.white,),
            Text("Agregar Nota", style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
    );
  }

  Future addNoteDialog() {

    TextEditingController noteController = TextEditingController();

    final prefs = UserPrefs();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double hxw = height * width;

    String tiempoNota = setTiempo();
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
        backgroundColor: (prefs.darkMode)
          ?const Color(0xFF474864)
          :Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.note_alt_outlined,
              color: const Color(0xFF0071E4),
              size: hxw * 0.0001,
            ),
            Text(
              "Agregar Nota",
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w300,
                fontSize: hxw * 0.00007
              ),
            ),
            Text(
              tiempoNota,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
        content: TextField(
          cursorColor: const Color(0xFF0071E4),
          controller: noteController,
          expands: false,
          maxLines: 5,
          maxLength: 200,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Escriba su nota...",
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
            onPressed: (){
              widget.notas.add("$tiempoNota${noteController.text}");
              Navigator.of(context).pop(false);
              noteController.text = "";
              Fluttertoast.cancel();
              Fluttertoast.showToast(
                msg: "¡Nota agregada!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
            },
            child: const Text("Ok")
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
            onPressed: (){
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancelar",),
          ),
        ],
      ),
    ).then((value) => false);
  }
}