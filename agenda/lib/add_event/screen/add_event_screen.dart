import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/costants/string_constants.dart';
import '../../core/ui/widgets/custom_button/custom_button.dart';
import '../state/add_event_cubit.dart';
import '../state/add_event_state.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  bool isAddButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddEventCubit(),
      child: BlocListener<AddEventCubit, AddEventState>(
        listener: (context, state) {
          if (state is AddEventUnlockAdd) {
            setState(() => isAddButtonEnabled = true);
          } else if (state is AddEventLockAdd) {
            setState(() => isAddButtonEnabled = false);
          } else if (state is AddEventSuccess) {
            context.read<AddEventCubit>().showSuccessDialog(state.message);
          } else if (state is AddEventError) {
            context.read<AddEventCubit>().showErrorDialog(state.message);
          }
        },
        child: BlocBuilder<AddEventCubit, AddEventState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(title: Text(StringConstants.addEvent)),
              body: _buildEventForm(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(labelText: StringConstants.addEventTitle),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: StringConstants.addEventDescription),
            onChanged: (value) => checkForm(context),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              // Start Date and Time Button
              Expanded(
                child: Column(
                  children: [
                    CustomButton(
                      text: StringConstants.addEventStartDate,
                      onPressed: () async {
                        final pickedDate = await _selectDate(context);
                        if (pickedDate != null) {
                          final pickedTime = await _selectTime(context);
                          if (pickedTime != null) {
                            setState(() {
                              startDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                            checkForm(context);
                          }
                        }
                      },
                    ),
                    if (startDate != null)
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(startDate!),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              // End Date and Time Button
              Expanded(
                child: Column(
                  children: [
                    CustomButton(
                      text: StringConstants.addEventEndDate,
                      onPressed: () async {
                        final pickedDate = await _selectDate(context);
                        if (pickedDate != null) {
                          final pickedTime = await _selectTime(context);
                          if (pickedTime != null) {
                            setState(() {
                              endDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                            checkForm(context);
                          }
                        }
                      },
                    ),
                    if (endDate != null)
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(endDate!),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
              text: StringConstants.addEventSave,
              onPressed: isAddButtonEnabled
                  ? () {
                context.read<AddEventCubit>().addEvent(
                  title: titleController.text,
                  description: descriptionController.text,
                  startDate: startDate!,
                  endDate: endDate!,
                );
              }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Blocco date precedenti!!
      lastDate: DateTime(2100),
    );
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  void checkForm(BuildContext context) {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        startDate != null &&
        endDate != null) {
      context.read<AddEventCubit>().setButtonState(true);
    } else {
      context.read<AddEventCubit>().lockAdd();
    }
  }
}