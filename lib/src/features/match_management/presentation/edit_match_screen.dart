import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/src/features/match_management/application/match_service.dart';

class EditMatchScreen extends StatefulWidget {
  final Match match;

  const EditMatchScreen({super.key, required this.match});

  @override
  EditMatchScreenState createState() => EditMatchScreenState();
}

class EditMatchScreenState extends State<EditMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _equipe1;
  late String _equipe2;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _equipe1 = widget.match.equipe1;
    _equipe2 = widget.match.equipe2;
    _date = widget.match.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier la rencontre')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _equipe1,
                decoration: const InputDecoration(labelText: 'Équipe 1'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'équipe 1';
                  }
                  return null;
                },
                onSaved: (value) {
                  _equipe1 = value!;
                },
              ),
              TextFormField(
                initialValue: _equipe2,
                decoration: const InputDecoration(labelText: 'Équipe 2'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'équipe 2';
                  }
                  return null;
                },
                onSaved: (value) {
                  _equipe2 = value!;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Date: ${_date.day}/${_date.month}/${_date.year}'),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _date) {
                        setState(() {
                          _date = pickedDate;
                        });
                      }
                    },
                    child: const Text('Choisir une date'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final updatedMatch = Match(
                      id: widget.match.id,
                      equipe1: _equipe1,
                      equipe2: _equipe2,
                      date: _date,
                      parties: widget.match.parties,
                    );
                    Provider.of<MatchService>(context, listen: false)
                        .updateMatch(updatedMatch);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
