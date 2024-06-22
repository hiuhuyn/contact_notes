import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

Future<bool> colorPickerDialog({
  required void Function(Color) onColorChanged,
  required Color initColor,
  required BuildContext context,
  required BoxConstraints constraints,
}) async {
  return ColorPicker(
    color: initColor,
    onColorChanged: onColorChanged,
    pickersEnabled: const <ColorPickerType, bool>{
      ColorPickerType.both: true,
      ColorPickerType.primary: false,
      ColorPickerType.accent: false,
      ColorPickerType.bw: false,
      ColorPickerType.custom: false,
      ColorPickerType.wheel: true,
    },
    enableShadesSelection: true,
    includeIndex850: false,
    enableTonalPalette: false,
    enableOpacity: true,
    actionButtons: const ColorPickerActionButtons(
      dialogCancelButtonLabel: 'Cancel',
      dialogCancelButtonType: ColorPickerActionButtonType.outlined,
      dialogOkButtonLabel: 'OK',
      dialogOkButtonType: ColorPickerActionButtonType.elevated,
    ),
    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
      longPressMenu: true,
      copyIcon: Icons.check,
    ),
    selectedColorIcon: Icons.check,
    elevation: 4,
    hasBorder: false,
    borderRadius: null,
    borderColor: null,
    wheelHasBorder: true,
    title: null,
    heading: const Text('Select color'),
    subheading: const Text('Select color shade'),
    tonalSubheading: null,
    wheelSubheading: null,
    opacitySubheading: const Text('Opacity'),
    showMaterialName: true,
    showColorName: false,
    showColorCode: true,
    colorCodeHasColor: true,
    colorCodeReadOnly: false,
    pickerTypeLabels: const <ColorPickerType, String>{
      ColorPickerType.both: 'Both',
      ColorPickerType.wheel: 'Wheel',
    },
    customColorSwatchesAndNames: <ColorSwatch<Object>, String>{
      ColorTools.createPrimarySwatch(const Color(0xFF6200EE)): 'Guide Purple',
      ColorTools.createPrimarySwatch(const Color(0xFF3700B3)):
          'Guide Purple Variant',
      ColorTools.createAccentSwatch(const Color(0xFF03DAC6)): 'Guide Teal',
      ColorTools.createAccentSwatch(const Color(0xFF018786)):
          'Guide Teal Variant',
      ColorTools.createPrimarySwatch(const Color(0xFFB00020)): 'Guide Error',
      ColorTools.createPrimarySwatch(const Color(0xFFCF6679)):
          'Guide Error Dark',
      ColorTools.createPrimarySwatch(const Color(0xFF174378)): 'Blue blues',
    },
  ).showPickerDialog(
    context,
    constraints: constraints,
  );
}
