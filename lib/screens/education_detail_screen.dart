import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/utils/date_formatter.dart';
import 'package:myportofolio_mobile/widgets/detail_section.dart';

class EducationDetailScreen extends StatelessWidget {
  const EducationDetailScreen({required this.education, super.key});

  final Education education;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final thumbnail = education.thumbnail;
    final endedAt = education.endedAt;

    return Scaffold(
      appBar: AppBar(
        title: Text(education.institution),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Only rendered when the API returned a non-empty thumbnail URL.
            if (thumbnail != null && thumbnail.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  thumbnail,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              education.institution,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DetailSection(label: 'Program', value: _orDash(education.program)),
            DetailSection(label: 'Level', value: education.levelDisplay),
            DetailSection(label: 'Period', value: education.period),
            DetailSection(
              label: 'Started At',
              value: formatDate(education.startedAt.toUtc()),
            ),
            DetailSection(
              label: 'Ended At',
              value: endedAt == null ? 'Sekarang' : formatDate(endedAt.toUtc()),
            ),
            DetailSection(
              label: 'Status',
              value: education.isOngoing ? 'Ongoing' : 'Completed',
            ),
            DetailSection(
              label: 'Description',
              value: _orDash(education.description),
            ),
            DetailSection(label: 'Stars', value: '${education.starCount}'),
            DetailSection(
              label: 'Starred By',
              value: _orDash(education.starredByNames),
            ),
            DetailSection(
              label: 'Starred By Me',
              value: education.isStarred ? 'Yes' : 'No',
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows `-` for empty optional fields.
String _orDash(String value) => value.isEmpty ? '-' : value;
