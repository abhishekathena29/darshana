import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/event_model.dart';
import '../../../core/services/event_repository.dart';
import '../../../core/session/user_session.dart';

/// Create/edit form for an event owned by the current (temple-role) account.
class AddEventScreen extends StatefulWidget {
  final EventModel? existing;
  const AddEventScreen({super.key, this.existing});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _repository = EventRepository();
  final _title = TextEditingController();
  final _imageUrl = TextEditingController();
  final _venue = TextEditingController();
  final _startTime = TextEditingController();
  final _durationText = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _capacity = TextEditingController();

  DateTime _date = DateTime.now().add(const Duration(days: 1));
  String _category = 'Poojas';
  bool _saving = false;

  static const _categories = ['Poojas', 'Festivals', 'Music', 'Dance', 'Tours'];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _title.text = e.title;
      _imageUrl.text = e.imageUrl;
      _venue.text = e.venue;
      _startTime.text = e.startTime;
      _durationText.text = e.durationText;
      _description.text = e.description;
      _price.text = e.price == 0 ? '' : e.price.toStringAsFixed(0);
      _capacity.text = e.capacity?.toString() ?? '';
      _date = e.date;
      _category = e.category;
    }
  }

  @override
  void dispose() {
    for (final c in [_title, _imageUrl, _venue, _startTime, _durationText, _description, _price, _capacity]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty || _venue.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least a title and venue.')),
      );
      return;
    }
    setState(() => _saving = true);
    final uid = context.read<UserSession>().uid ?? '';
    final dateText = _formatDate(_date);
    try {
      if (widget.existing == null) {
        final event = EventModel(
          id: '',
          ownerId: uid,
          title: _title.text.trim(),
          badge: '',
          category: _category,
          imageUrl: _imageUrl.text.trim(),
          date: _date,
          dateText: dateText,
          startTime: _startTime.text.trim(),
          venue: _venue.text.trim(),
          durationText: _durationText.text.trim(),
          description: _description.text.trim(),
          price: double.tryParse(_price.text.trim()) ?? 0,
          capacity: int.tryParse(_capacity.text.trim()),
        );
        await _repository.create(event);
      } else {
        await _repository.update(widget.existing!.id, {
          'title': _title.text.trim(),
          'category': _category,
          'imageUrl': _imageUrl.text.trim(),
          'date': _date,
          'dateText': dateText,
          'startTime': _startTime.text.trim(),
          'venue': _venue.text.trim(),
          'durationText': _durationText.text.trim(),
          'description': _description.text.trim(),
          'price': double.tryParse(_price.text.trim()) ?? 0,
          'capacity': int.tryParse(_capacity.text.trim()),
        });
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the event. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'Add new event' : 'Edit event')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(_title, 'Event title'),
              _field(_imageUrl, 'Image URL'),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (value) => setState(() => _category = value ?? _category),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
                  child: Text(_formatDate(_date)),
                ),
              ),
              const SizedBox(height: 16),
              _field(_startTime, 'Start time (e.g. 06:00 PM IST)'),
              _field(_venue, 'Venue'),
              _field(_durationText, 'Duration (e.g. 4 Hours Daily)'),
              _field(_price, 'Price (₹, leave empty if free)', keyboardType: TextInputType.number),
              _field(_capacity, 'Capacity (optional)', keyboardType: TextInputType.number),
              _field(_description, 'Description', maxLines: 4),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label, {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
