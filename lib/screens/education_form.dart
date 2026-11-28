import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/utils/date_formatter.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  static const String _defaultLevel = 's1';
  static const Map<String, String> _levels = {
    'sd': 'SD',
    'smp': 'SMP',
    'sma': 'SMA/SMK',
    's1': 'S1',
    's2': 'S2',
    's3': 'S3',
  };

  final _formKey = GlobalKey<FormState>();
  final _endDateFieldKey = GlobalKey<FormFieldState<String>>();

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  String _institution = '';
  String _level = _defaultLevel;
  String _fieldOfStudy = '';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isStudying = false;
  String _description = '';
  bool _isSubmitting = false;

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
        _startDateController.text = formatDate(picked);
      } else {
        _endDate = picked;
        _endDateController.text = formatDate(picked);
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _startDateController.clear();
    _endDateController.clear();
    setState(() {
      _startDate = null;
      _endDate = null;
      _isStudying = false;
      _level = _defaultLevel;
    });
  }

  DateTime _toUtcDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  Future<void> _submit() async {
    final formState = _formKey.currentState!;
    if (!formState.validate()) {
      return;
    }
    formState.save();

    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null) return;

    final apiClient = context.read<ApiClient>();
    final endDate = _endDate;
    final newEducation = Education(
      institution: _institution,
      program: _fieldOfStudy,
      level: _level,
      description: _description,
      startedAt: _toUtcDate(_startDate!),
      endedAt: _isStudying || endDate == null ? null : _toUtcDate(endDate),
    );

    setState(() {
      _isSubmitting = true;
    });

    final Education created;
    try {
      created = await apiClient.createEducation(newEducation, token: token);
    } on ApiException catch (e) {
      if (!mounted) return;
      _stopSubmitting();
      await _handleApiError(e);
      return;
    } on Exception {
      if (!mounted) return;
      _stopSubmitting();
      _showSnackBar('Tidak dapat terhubung ke server. Coba lagi nanti.');
      return;
    }

    if (!mounted) return;
    _stopSubmitting();
    await _showSummaryDialog(created);
  }

  void _stopSubmitting() {
    setState(() {
      _isSubmitting = false;
    });
  }

  Future<void> _handleApiError(ApiException e) async {
    if (e.statusCode == 401) {
      await context.read<AuthState>().logout();
      if (!mounted) return;
      _showSnackBar('Sesi login berakhir. Silakan login ulang.');
      await ensureLoggedIn(context);
    } else if (e.statusCode == 403) {
      _showSnackBar(
        'Kamu tidak memiliki izin menambah Education. '
        'Hanya pemilik portofolio yang dapat menambah data.',
      );
    } else if (e.statusCode == 400) {
      _showSnackBar('Data tidak valid. Periksa kembali isian kamu.');
    } else {
      _showSnackBar('Gagal menyimpan data pendidikan (${e.statusCode}).');
    }
  }

  Future<void> _showSummaryDialog(Education created) async {
    final endedAt = created.endedAt;
    final endDateText = endedAt == null
        ? 'Sekarang (masih menempuh pendidikan)'
        : formatDate(endedAt.toUtc());
    final descriptionText = created.description.isEmpty
        ? '-'
        : created.description;

    final openList = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Data pendidikan berhasil disimpan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Institusi: ${created.institution}'),
                Text('Jenjang: ${created.levelDisplay}'),
                Text('Bidang Studi: ${created.program}'),
                Text('Tanggal Mulai: ${formatDate(created.startedAt.toUtc())}'),
                Text('Tanggal Selesai: $endDateText'),
                Text('Deskripsi: $descriptionText'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Tutup'),
              onPressed: () => Navigator.pop(dialogContext, false),
            ),
            TextButton(
              child: const Text('Lihat Daftar'),
              onPressed: () => Navigator.pop(dialogContext, true),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (openList ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EducationListScreen()),
      );
    } else {
      _resetForm();
    }
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
                    initialValue: _defaultLevel,
                    items: _levels.entries
                        .map(
                          (level) => DropdownMenuItem(
                            value: level.key,
                            child: Text(level.value),
                          ),
                        )
                        .toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _level = newValue;
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
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Simpan'),
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
