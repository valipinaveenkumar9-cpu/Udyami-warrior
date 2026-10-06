import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';

class FormSectionHeader extends StatelessWidget {
  final String title;
  const FormSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 1,
            color: context.colors.orangeDark,
          ),
          const SizedBox(width: 6),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: context.colors.orangeDark,
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class FormTextField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? helperText;

  const FormTextField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.helperText,
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
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: context.colors.primaryDarkBlue,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 13.5),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: context.colors.secondaryText.withValues(alpha: 0.5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.colors.disabledBorder, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.colors.disabledBorder, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.colors.orangeWarning, width: 2),
              ),
            ),
          ),
          if (helperText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                helperText!,
                style: TextStyle(
                  fontSize: 10.8,
                  color: context.colors.secondaryText,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FormToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String falseText;
  final String trueText;

  const FormToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.falseText = 'No',
    this.trueText = 'Yes',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.disabledBorder, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.8, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: context.colors.disabledBorder, width: 1.5),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                _SegmentButton(
                  text: falseText,
                  isSelected: !value,
                  onTap: () => onChanged(false),
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(100)),
                ),
                _SegmentButton(
                  text: trueText,
                  isSelected: value,
                  onTap: () => onChanged(true),
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(100)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  const _SegmentButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.primaryDarkBlue : Colors.white,
          borderRadius: borderRadius,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: isSelected ? context.colors.orangeLight : context.colors.secondaryText,
          ),
        ),
      ),
    );
  }
}

class WarningNote extends StatelessWidget {
  final String text;
  final bool isWarning;

  const WarningNote({super.key, required this.text, this.isWarning = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isWarning ? const Color(0xFFF7E6DE) : context.colors.greenLight,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: isWarning ? context.colors.redWarningDark : context.colors.greenDark,
            width: 3,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.2,
          height: 1.5,
          color: isWarning ? const Color(0xFF6E2E22) : context.colors.secondaryText,
        ),
      ),
    );
  }
}

class FormCheckbox extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const FormCheckbox({super.key, required this.text, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.disabledBorder, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: context.colors.orangeDark,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 12.3, height: 1.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommissionCard extends StatelessWidget {
  final String icon;
  final String title;
  final Widget description;

  const CommissionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.disabledBorder, width: 1.5),
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: context.colors.orangeLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.8,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 3),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 11.6,
                    height: 1.4,
                    color: context.colors.secondaryText,
                  ),
                  child: description,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
