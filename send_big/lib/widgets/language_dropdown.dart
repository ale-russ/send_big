import 'package:flutter/material.dart';
import '../models/languages.dart';
import '../constants/languages.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({
    super.key,
  });

  @override
  LanguageDropdownState createState() => LanguageDropdownState();
}

class LanguageDropdownState extends State<LanguageDropdown> {
  bool isDropdownOpened = false;
  Language? selectedLanguage = languages[0];

  void _onLanguageChanged(Language? newLanguage) {
    setState(() {
      selectedLanguage = newLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: DropdownButtonFormField<Language>(
        elevation: 0,
        icon: const SizedBox.shrink(),
        isDense: false,
        isExpanded: true,
        alignment: AlignmentDirectional.center,
        dropdownColor: Colors.white,
        value: selectedLanguage,
        decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        )),
        onChanged: (Language? newValue) {
          setState(() {
            selectedLanguage = newValue;
          });
          _onLanguageChanged(newValue);
        },
        items: languages.map<DropdownMenuItem<Language>>((Language value) {
          return DropdownMenuItem<Language>(
            value: value,
            child: Text(
              value.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          );
        }).toList(),
        onTap: () {
          setState(() {
            isDropdownOpened = !isDropdownOpened;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              isDropdownOpened = !isDropdownOpened;
            });
          });
        },
        selectedItemBuilder: (context) {
          return languages.map<Widget>((Language value) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.displayCode,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
