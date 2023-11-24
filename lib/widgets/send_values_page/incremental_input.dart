import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IncrementalInput extends StatefulWidget {
  const IncrementalInput({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<IncrementalInput> createState() => _IncrementalInputState();
}

class _IncrementalInputState extends State<IncrementalInput> {

  @override
  void initState() {
    super.initState();

    widget.controller.text = "0";
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.53,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color.fromARGB(255, 0, 92, 167)
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButonRemove(controller: widget.controller),
            IncrementalTextfield(controller: widget.controller),
            IconButtonAdd(controller: widget.controller),
          ],
        ),
      ),
    );
  }
}

// ======================================== WIDGETS ======================================== //


// ==================== ICON BUTTON REMOVE ==================== //
class IconButonRemove extends StatefulWidget {
  const IconButonRemove({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<IconButonRemove> createState() => _IconButonRemoveState();
}

class _IconButonRemoveState extends State<IconButonRemove> {

  Timer? longPressTimer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
      child: CircleAvatar(
        backgroundColor: Colors.lightBlue.shade400,
        child: GestureDetector(
          onLongPressStart: (_) {
            longPressTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
              disminuirPosicion();
            });
          },
          onLongPressEnd: (_) {
            longPressTimer?.cancel();
          },
          child: IconButton(
            onPressed: (){
              disminuirPosicion();
            },
            icon: const Icon(
              Icons.remove,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void disminuirPosicion(){
    int value = int.tryParse(widget.controller.text) ?? 0;
    if (value != 0) { //validacion para q no sea negeativo
      widget.controller.text = (value - 1).toString();
      widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
    }
  }
}
// ==================== FIN-ICON BUTTON REMOVE ==================== //


// ==================== ICON BUTTON ADD ==================== //
class IconButtonAdd extends StatefulWidget {
  const IconButtonAdd({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<IconButtonAdd> createState() => _IconButtonAddState();
}

class _IconButtonAddState extends State<IconButtonAdd> {

  Timer? longPressTimer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      child: CircleAvatar(
        backgroundColor: Colors.lightBlue.shade500,
        child: GestureDetector(
          onLongPressStart: (_) {
            longPressTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
              incrementarPosicion();
            });
          },
          onLongPressEnd: (_) {
            longPressTimer?.cancel();
          },
          child: IconButton(
            onPressed: (){
              incrementarPosicion();
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void incrementarPosicion(){
    int value = int.tryParse(widget.controller.text) ?? 0;
    if (value < 200) { //validacion para que no pase los 4 digitos
      widget.controller.text = (value + 1).toString();
      widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
    }
  }
}
// ==================== FIN-ICON BUTTON ADD ==================== //

// ==================== INCREMENTAL-TEXTFIELD ==================== //
class IncrementalTextfield extends StatefulWidget {
  const IncrementalTextfield({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<IncrementalTextfield> createState() => _IncrementalTextfieldState();
}

class _IncrementalTextfieldState extends State<IncrementalTextfield> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    bool errorHandled = false;

    widget.controller.addListener((){ // LISTENER CONTROLLER
      if (!errorHandled) {
        final text = widget.controller.text;
        try {
          final value = int.parse(text);
          if(value > 200) { //validar que no sobrepase el limite
            widget.controller.text = "200";
          }
          widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
        } on FormatException {
          errorHandled = true;
        }
      }
    });

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: SizedBox(
          height: height * 0.05,
          child: TextField(
            cursorColor: Colors.white,
            controller: widget.controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(3),
              FilteringTextInputFormatter.digitsOnly,
            ],
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              filled: true,
              fillColor: Colors.lightBlue,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Ajusta el valor según sea necesario
                  borderSide: BorderSide.none, // Establece el borde enfocado como nulo
                ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.textScaleFactorOf(context) * 18
            ),
          ),
        ),
      )
    );
  }
}

// ==================== END-INCREMENTAL-TEXTFIELD ==================== //




