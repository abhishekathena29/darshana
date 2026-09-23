import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/temple_model.dart';
import '../../../core/services/temple_repository.dart';
import '../../../core/session/user_session.dart';

/// Create/edit form for a temple's own profile. Passing [templeId] loads an
/// existing temple to edit; omitting it creates a new one owned by the
/// current (temple-role) account.
class EditTempleScreen extends StatefulWidget {
  final String? templeId;
  const EditTempleScreen({super.key, this.templeId});

  @override
  State<EditTempleScreen> createState() => _EditTempleScreenState();
}

class _EditTempleScreenState extends State<EditTempleScreen> {
  final _repository = TempleRepository();
  final _name = TextEditingController();
  final _deity = TextEditingController();
  final _imageUrl = TextEditingController();
  final _location = TextEditingController();
  final _timings = TextEditingController();
  final _dressCode = TextEditingController();
  final _significance = TextEditingController();
  final _history = TextEditingController();
  final _architecture = TextEditingController();
  final _officialPortal = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.templeId == null) {
      setState(() => _loading = false);
      return;
    }
    final temple = await _repository.watchById(widget.templeId!).first;
    if (temple != null && mounted) {
      _name.text = temple.name;
      _deity.text = temple.deity;
      _imageUrl.text = temple.imageUrl;
      _location.text = temple.location;
      _timings.text = temple.timings;
      _dressCode.text = temple.dressCode;
      _significance.text = temple.significance;
      _history.text = temple.history;
      _architecture.text = temple.architecture;
      _officialPortal.text = temple.officialPortal;
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _deity,
      _imageUrl,
      _location,
      _timings,
      _dressCode,
      _significance,
      _history,
      _architecture,
      _officialPortal,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the temple name.')),
      );
      return;
    }
    setState(() => _saving = true);
    final uid = context.read<UserSession>().uid;
    final data = {
      'ownerId': uid,
      'name': _name.text.trim(),
      'deity': _deity.text.trim(),
      'imageUrl': _imageUrl.text.trim(),
      'location': _location.text.trim(),
      'timings': _timings.text.trim(),
      'dressCode': _dressCode.text.trim(),
      'significance': _significance.text.trim(),
      'history': _history.text.trim(),
      'architecture': _architecture.text.trim(),
      'officialPortal': _officialPortal.text.trim(),
    };
    try {
      if (widget.templeId == null) {
        final temple = TempleModel(
          id: '',
          ownerId: uid ?? '',
          name: _name.text.trim(),
          deity: _deity.text.trim(),
          imageUrl: _imageUrl.text.trim(),
          location: _location.text.trim(),
          timings: _timings.text.trim(),
          dressCode: _dressCode.text.trim(),
          significance: _significance.text.trim(),
          history: _history.text.trim(),
          architecture: _architecture.text.trim(),
          officialPortal: _officialPortal.text.trim(),
        );
        final id = await _repository.create(temple);
        if (!mounted) return;
        Navigator.of(context).pop(id);
      } else {
        await _repository.update(widget.templeId!, data);
        if (!mounted) return;
        Navigator.of(context).pop(widget.templeId);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.templeId == null ? 'Create temple profile' : 'Edit temple profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(_name, 'Temple name'),
              _field(_deity, 'Presiding deity'),
              _field(_imageUrl, 'Hero image URL'),
              _field(_location, 'Location'),
              _field(_timings, 'Timings (e.g. 5:30 AM - 9:00 PM)'),
              _field(_dressCode, 'Dress code'),
              _field(_significance, 'Divine significance', maxLines: 4),
              _field(_history, 'History', maxLines: 3),
              _field(_architecture, 'Architecture', maxLines: 3),
              _field(_officialPortal, 'Official website (optional)'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
