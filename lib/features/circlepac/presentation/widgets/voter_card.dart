import 'package:flutter/material.dart';
import '../../models/circlepac_survey_models.dart';
import '../../theme/circlepac_colors.dart';

class VoterCard extends StatelessWidget {
  final VoterRecord voter;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VoterCard({
    super.key,
    required this.voter,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cat = voter.category;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CirclepacColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Name + Category Pill + Menu
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: CirclepacColors.activeGreenBg,
                    child: Text(
                      voter.name.isNotEmpty ? voter.name[0].toUpperCase() : 'V',
                      style: const TextStyle(
                        color: CirclepacColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voter.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: CirclepacColors.primaryDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${voter.age} yrs • ${voter.gender} • ${voter.ward}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: CirclepacColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Category Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cat.bgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cat.borderColor),
                    ),
                    child: Text(
                      cat.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: cat.color,
                      ),
                    ),
                  ),
                  // Popup Actions
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20, color: CirclepacColors.textMuted),
                    padding: EdgeInsets.zero,
                    onSelected: (val) {
                      if (val == 'edit' && onEdit != null) onEdit!();
                      if (val == 'delete' && onDelete != null) onDelete!();
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18, color: CirclepacColors.primaryGreen),
                            SizedBox(width: 8),
                            Text('Edit Survey', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 18, color: CirclepacColors.errorRed),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(fontSize: 13, color: CirclepacColors.errorRed)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 18, color: CirclepacColors.borderLight),
              // Bottom Row: Voter ID, Mobile, Data Quality flags
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.badge_outlined, size: 14, color: CirclepacColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        voter.voterId,
                        style: const TextStyle(fontSize: 12, color: CirclepacColors.textBody),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 14,
                        color: voter.hasMissingPhone ? CirclepacColors.errorRed : CirclepacColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        voter.hasMissingPhone ? 'Missing Phone' : voter.mobile,
                        style: TextStyle(
                          fontSize: 12,
                          color: voter.hasMissingPhone ? CirclepacColors.errorRed : CirclepacColors.textBody,
                          fontWeight: voter.hasMissingPhone ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  // Survey Completion Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: CirclepacColors.activeGreenBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${(voter.completionPercentage * 100).toInt()}% Done',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: CirclepacColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
