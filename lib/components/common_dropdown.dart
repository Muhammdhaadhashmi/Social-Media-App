// ignore_for_file: must_be_immutable
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CommonDropdownButton extends StatefulWidget {
  final List items;
  void Function(dynamic) onSaved;
  String? hintText;
  String? value;
  void Function(dynamic) onChange;
  CommonDropdownButton({
    Key? key,
    required this.items,
    required this.onSaved,
    this.hintText,
    this.value,
    required this.onChange,
  }) : super(key: key);

  @override
  State<CommonDropdownButton> createState() => _CommonDropdownButtonState();
}

class _CommonDropdownButtonState extends State<CommonDropdownButton> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return     
       DropdownButtonFormField2(
        dropdownStyleData: const DropdownStyleData(
          decoration: BoxDecoration(
            color:   Color(0xFF1c2a33),
          ),
        ),
        decoration: InputDecoration(
        
          contentPadding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
          fillColor: const Color(0xFF1c2a33),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF495967),
              )),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF495967),
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF495967),
              )),
        ),
        isExpanded: false,
        hint: Text(
          widget.hintText ?? "",
          style: const TextStyle(
            color: Colors.white24,            
            fontWeight: FontWeight.w500,
          ),
        ),
        items: widget.items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.white24,                    
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        value: widget.value,
        onSaved: widget.onSaved,
        onChanged: widget.onChange,
      );
  }
}
