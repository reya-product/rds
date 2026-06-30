import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// Care Plan Page — PDF document prototype
// ---------------------------------------------------------------------------

class CarePlanPage extends StatelessWidget {
  const CarePlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD0D0D0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.14),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const _Document(),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Document shell
// ---------------------------------------------------------------------------

class _Document extends StatelessWidget {
  const _Document();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        _PageHeader(),
        _PatientInfoBlock(),
        _Section(
          title: 'Chief Complaint/HPI',
          child: _BodyText(
            'Headache for last 3 days, followed by diarrhea in the last 2 days',
          ),
        ),
        _Section(
          title: 'Vitals',
          child: _BulletList(items: [
            'Weight: 120 pounds, 125 pounds, 121 pounds',
            'Blood Pressure: 120/80 mmHg, 125/81 mmHg',
            'Heart Rate: 167 bpm, 166 bpm',
            'Respiratory Rate: 14 bpm',
            'Body Temperature: 98 oC',
            "Height: 5'9''",
            'SpO2: 98 %',
          ]),
        ),
        _Section(
          title: 'Current Supplements',
          child: _SupplementList(items: [
            _SupplementItem(
                dose: 'Take 1 capsule every day',
                name: 'Nature Made, Vitamin D 500 IU'),
            _SupplementItem(
                dose: 'Take 1 tablet every day', name: 'Folic Acid 5 MG'),
          ]),
        ),
        SizedBox(height: 48),
        _PageFooter(),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Page header
// ---------------------------------------------------------------------------

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(56, 44, 56, 0),
      child: Column(
        children: [
          Text(
            'Love.Life',
            style: GoogleFonts.playfairDisplay(
              fontSize: 52,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A3D28),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '740 S Pacific Cost Highway\nEl Segundo CA 90245\n310-563-7366 | www.love.life',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF444444),
              height: 1.65,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Care Plan',
            style: GoogleFonts.playfairDisplay(
              fontSize: 34,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 22),
          const Divider(color: Color(0xFFCCCCCC), thickness: 1),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Patient info block
// ---------------------------------------------------------------------------

class _PatientInfoBlock extends StatelessWidget {
  const _PatientInfoBlock();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _PatientInfoLine('Name: Juliana Crian'),
          _PatientInfoLine('ID: 1234567890'),
          _PatientInfoLine('DOB: 25 Sep 1984'),
          _PatientInfoLine('Encounter Date & Time: 23 Jun 2023, 11: 30 AM'),
        ],
      ),
    );
  }
}

class _PatientInfoLine extends StatelessWidget {
  final String text;
  const _PatientInfoLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13.5,
          color: Color(0xFF1A1A1A),
          height: 1.5,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section
// ---------------------------------------------------------------------------

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(56, 28, 56, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D6A4A),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content widgets
// ---------------------------------------------------------------------------

class _BodyText extends StatelessWidget {
  final String text;
  const _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF1A1A1A),
        height: 1.5,
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  const _BulletList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '•  ',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF1A1A1A),
                      height: 1.5,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF1A1A1A),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SupplementItem {
  final String dose;
  final String name;
  const _SupplementItem({required this.dose, required this.name});
}

class _SupplementList extends StatelessWidget {
  final List<_SupplementItem> items;
  const _SupplementList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => _SupplementRow(item: item)).toList(),
    );
  }
}

class _SupplementRow extends StatelessWidget {
  final _SupplementItem item;
  const _SupplementRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•  ',
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF1A1A1A),
              height: 1.5,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.dose,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF1A1A1A),
                    height: 1.5,
                  ),
                ),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    height: 1.5,
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

// ---------------------------------------------------------------------------
// Page footer
// ---------------------------------------------------------------------------

class _PageFooter extends StatelessWidget {
  const _PageFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFDDDDDD))),
      ),
      padding: const EdgeInsets.fromLTRB(40, 14, 40, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left — logo
          Expanded(
            child: Text(
              'Love.Life',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A3D28),
              ),
            ),
          ),
          // Center — page number
          Column(
            children: const [
              Text(
                '1',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                'CONFIDENTIAL',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.8,
                  color: Color(0xFF444444),
                ),
              ),
            ],
          ),
          // Right — patient details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'Juliana Crain',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  'LL XXXXXX, 25 NOV 1985',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF444444),
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
