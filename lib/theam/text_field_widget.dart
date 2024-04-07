import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicklai/theam/constant_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController controller;
  final Function() onPress;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enable;
  final int? maxLine;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldWidget(
      {super.key, this.textInputType, this.enable, this.prefix, this.title, required this.hintText, required this.controller, required this.onPress, this.maxLine, this.inputFormatters, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: title != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? '', style:  GoogleFonts.wixMadeforText(fontSize: 14, fontWeight: FontWeight.w500,color: ConstantColors.grey06)),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          TextFormField(
            keyboardType: textInputType ?? TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            textAlign: TextAlign.start,
            maxLines: maxLine ?? 1,
            textInputAction: TextInputAction.done,
            inputFormatters: inputFormatters,
            style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                errorStyle: const TextStyle(color: Colors.red),
                isDense: true,
                filled: true,
                enabled: enable ?? true,
                fillColor: ConstantColors.grey01,
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: prefix != null ? 0 : 10),
                prefixIcon: prefix,
                disabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ConstantColors.grey03, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ConstantColors.grey03, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ConstantColors.grey03, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ConstantColors.grey03, width: 1),
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: ConstantColors.grey03, width: 1),
                ),
                hintText: hintText.tr,
                suffixIcon: suffix,
                hintStyle: GoogleFonts.wixMadeforText(fontSize: 14, color: ConstantColors.grey06, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
