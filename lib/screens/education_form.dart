import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  static const String _defaultDegree = 'S1';
  static const List<String> _degrees = [
    'SMA/SMK',
    'D3',
    'S1',
    'S2',
    'S3',
    'Lainnya',
  ];
  static const List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final _formKey = GlobalKey<FormState>();
  final _endDateFieldKey = GlobalKey<FormFieldState<String>>();

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  String _institution = '';
  String _degree = _defaultDegree;
  String _fieldOfStudy = '';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isStudying = false;
  String _description = '';

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(
    String label, {
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  String? _validateInstitution(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Nama institusi tidak boleh kosong!';
    }
    if (text.length < 3) {
      return 'Nama institusi minimal 3 karakter!';
    }
    if (text.length > 100) {
      return 'Nama institusi maksimal 100 karakter!';
    }
    return null;
  }

  String? _validateFieldOfStudy(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Bidang studi tidak boleh kosong!';
    }
    if (text.length < 3) {
      return 'Bidang studi minimal 3 karakter!';
    }
    if (text.length > 100) {
      return 'Bidang studi maksimal 100 karakter!';
    }
    return null;
  }

  String? _validateStartDate(String? value) {
    if (_startDate == null) {
      return 'Tanggal mulai wajib dipilih!';
    }
    return null;
  }

  String? _validateEndDate(String? value) {
    if (_isStudying) {
      return null;
    }
    final end = _endDate;
    if (end == null) {
      return 'Pilih tanggal selesai atau aktifkan "Masih menempuh pendidikan"!';
    }
    final start = _startDate;
    if (start != null && end.isBefore(start)) {
      return 'Tanggal selesai tidak boleh sebelum tanggal mulai!';
    }
    return null;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final DateTime firstDate;
    final DateTime lastDate;
    DateTime initialDate;

    if (isStart) {
      firstDate = DateTime(1970);
      lastDate = now;
      initialDate = _startDate ?? now;
    } else {
      firstDate = _startDate ?? DateTime(1970);
      lastDate = DateTime(now.year + 10, now.month, now.day);
      initialDate = _endDate ?? now;
    }

    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }
    if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: isStart ? 'Pilih tanggal mulai' : 'Pilih tanggal selesai',
    );

    if (!mounted || picked == null) {
      return;
    }
    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = _formatDate(picked);
      } else {
        _endDate = picked;
        _endDateController.text = _formatDate(picked);
      }
    });
  }

  void _toggleStudying(bool value) {
    setState(() {
      _isStudying = value;
      if (value) {
        _endDate = null;
        _endDateController.clear();
      }
    });
    if (value) {
      _endDateFieldKey.currentState?.reset();
    }
  }

  void _submit() {
    final formState = _formKey.currentState!;
    if (!formState.validate()) {
      return;
    }
    formState.save();
    _showSummaryDialog();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _startDateController.clear();
    _endDateController.clear();
    setState(() {
      _startDate = null;
      _endDate = null;
      _isStudying = false;
      _degree = _defaultDegree;
    });
  }

  void _showSummaryDialog() {
    final endDateText = _isStudying
        ? 'Sekarang (masih menempuh pendidikan)'
        : _formatDate(_endDate!);
    final descriptionText = _description.isEmpty ? '-' : _description;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Data pendidikan berhasil disimpan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Institusi: $_institution'),
                Text('Jenjang: $_degree'),
                Text('Bidang Studi: $_fieldOfStudy'),
                Text('Tanggal Mulai: ${_formatDate(_startDate!)}'),
                Text('Tanggal Selesai: $endDateText'),
                Text('Deskripsi: $descriptionText'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.pop(dialogContext);
                _resetForm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Education Form'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),

      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: _decoration(
                      'Nama Institusi',
                      hint: 'Contoh: Universitas Indonesia',
                    ),
                    validator: _validateInstitution,
                    onSaved: (String? value) {
                      _institution = value?.trim() ?? '';
                    },
                  ),
                  const SizedBox(height: 16.0),

                  DropdownButtonFormField<String>(
                    decoration: _decoration('Jenjang Pendidikan'),
                    initialValue: _defaultDegree,
                    items: _degrees
                        .map(
                          (degree) => DropdownMenuItem(
                            value: degree,
                            child: Text(degree),
                          ),
                        )
                        .toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _degree = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),

                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: _decoration(
                      'Bidang Studi / Jurusan',
                      hint: 'Contoh: Sistem Informasi',
                    ),
                    validator: _validateFieldOfStudy,
                    onSaved: (String? value) {
                      _fieldOfStudy = value?.trim() ?? '';
                    },
                  ),
                  const SizedBox(height: 16.0),

                  TextFormField(
                    controller: _startDateController,
                    readOnly: true,
                    decoration: _decoration(
                      'Tanggal Mulai',
                      hint: 'Pilih tanggal',
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    onTap: () => _pickDate(isStart: true),
                    validator: _validateStartDate,
                  ),
                  const SizedBox(height: 8.0),

                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Masih menempuh pendidikan'),
                    value: _isStudying,
                    onChanged: _toggleStudying,
                  ),
                  const SizedBox(height: 8.0),

                  TextFormField(
                    key: _endDateFieldKey,
                    controller: _endDateController,
                    readOnly: true,
                    enabled: !_isStudying,
                    decoration: _decoration(
                      'Tanggal Selesai',
                      hint: _isStudying ? 'Tidak diperlukan' : 'Pilih tanggal',
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    onTap: () => _pickDate(isStart: false),
                    validator: _validateEndDate,
                  ),
                  const SizedBox(height: 16.0),

                  TextFormField(
                    maxLines: 4,
                    maxLength: 200,
                    decoration: _decoration(
                      'Deskripsi (opsional)',
                      hint: 'Prestasi, organisasi, atau catatan lain',
                    ),
                    onSaved: (String? value) {
                      _description = value?.trim() ?? '';
                    },
                  ),
                  const SizedBox(height: 8.0),

                  SizedBox(
                    height: 48.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _submit,
                      child: const Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
