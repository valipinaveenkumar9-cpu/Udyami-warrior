import 'package:flutter/material.dart';
import '../../theme/circlepac_colors.dart';

/// Section Header with numbered badge and description
class CirclepacSectionHeader extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String subtitle;

  const CirclepacSectionHeader({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CirclepacColors.activeGreenBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CirclepacColors.activeGreenBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: CirclepacColors.primaryGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              stepNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CirclepacColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: CirclepacColors.textBody,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Standard form text input with CloudPatra styling
class CirclepacTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool isRequired;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final IconData? prefixIcon;
  final int maxLines;

  const CirclepacTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.errorText,
    this.prefixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CirclepacColors.primaryDark,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: CirclepacColors.errorRed, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: onChanged,
            style: const TextStyle(fontSize: 14, color: CirclepacColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: CirclepacColors.textLight, fontSize: 13.5),
              errorText: errorText,
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: CirclepacColors.primaryGreen, size: 20)
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: CirclepacColors.borderCol),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: CirclepacColors.borderCol),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: CirclepacColors.primaryGreen, width: 1.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Radio Cards Option Selector with CloudPatra active green highlight
class CirclepacRadioCards<T> extends StatelessWidget {
  final String label;
  final bool isRequired;
  final List<T> options;
  final T? selectedValue;
  final String Function(T) optionLabel;
  final ValueChanged<T> onSelected;

  const CirclepacRadioCards({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.options,
    required this.selectedValue,
    required this.optionLabel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CirclepacColors.primaryDark,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: CirclepacColors.errorRed, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((opt) {
              final isSelected = opt == selectedValue;
              return InkWell(
                onTap: () => onSelected(opt),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? CirclepacColors.activeGreenBg : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? CirclepacColors.primaryGreen : CirclepacColors.borderCol,
                      width: isSelected ? 1.6 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? CirclepacColors.primaryGreen : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? CirclepacColors.primaryGreen : CirclepacColors.borderCol,
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        optionLabel(opt),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? CirclepacColors.primaryGreen : CirclepacColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Dropdown field with CloudPatra styled input container
class CirclepacDropdownField<T> extends StatelessWidget {
  final String label;
  final bool isRequired;
  final List<T> items;
  final T? value;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final String? hint;

  const CirclepacDropdownField({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.items,
    required this.value,
    required this.itemLabel,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final validItems = List<T>.from(items);
    if (value != null && !validItems.contains(value)) {
      validItems.add(value as T);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CirclepacColors.primaryDark,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: CirclepacColors.errorRed, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<T>(
            initialValue: value,
            items: validItems.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemLabel(item),
                  style: const TextStyle(fontSize: 13.5, color: CirclepacColors.textPrimary),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint ?? 'Select an option',
              hintStyle: const TextStyle(color: CirclepacColors.textLight, fontSize: 13.5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: CirclepacColors.borderCol),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: CirclepacColors.borderCol),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: CirclepacColors.primaryGreen, width: 1.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Yes/No Switch Tile Card styled with CloudPatra emerald active state
class CirclepacSwitchField extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CirclepacSwitchField({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: value ? CirclepacColors.activeGreenBg : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value ? CirclepacColors.activeGreenBorder : CirclepacColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: value ? CirclepacColors.primaryGreen : CirclepacColors.primaryDark,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(fontSize: 11.5, color: CirclepacColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: CirclepacColors.primaryGreen,
            activeTrackColor: CirclepacColors.activeGreenBorder,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Multi-select chips widget
class CirclepacMultiSelectChips extends StatelessWidget {
  final String label;
  final bool isRequired;
  final List<String> allOptions;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onChanged;

  const CirclepacMultiSelectChips({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.allOptions,
    required this.selectedOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CirclepacColors.primaryDark,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: CirclepacColors.errorRed, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allOptions.map((opt) {
              final isSelected = selectedOptions.contains(opt);
              return FilterChip(
                label: Text(opt),
                selected: isSelected,
                selectedColor: CirclepacColors.activeGreenBg,
                checkmarkColor: CirclepacColors.primaryGreen,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? CirclepacColors.primaryGreen : CirclepacColors.primaryDark,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected ? CirclepacColors.primaryGreen : CirclepacColors.borderCol,
                  ),
                ),
                onSelected: (selected) {
                  final updated = List<String>.from(selectedOptions);
                  if (selected) {
                    updated.add(opt);
                  } else {
                    updated.remove(opt);
                  }
                  onChanged(updated);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
