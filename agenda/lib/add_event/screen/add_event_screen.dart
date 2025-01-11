import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/add_event_cubit.dart';
import '../state/add_event_state.dart';

class AddEventScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController creatorNameController = TextEditingController();
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
            isAddButtonEnabled = true;
          } else if (state is AddEventLockAdd) {
            isAddButtonEnabled = false;
          } else if (state is AddEventSuccess) {
            context.read<AddEventCubit>().showSuccessDialog(state.message);
          } else if (state is AddEventError) {
            context.read<AddEventCubit>().showErrorDialog(state.message);
          }
        },
        child: BlocBuilder<AddEventCubit, AddEventState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(title: Text("Add Event")),
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
            decoration: InputDecoration(labelText: "Title"),
            onChanged: (value) => checkForm(context),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: "Description"),
            onChanged: (value) => checkForm(context),
          ),
          TextFormField(
            controller: creatorNameController,
            decoration: InputDecoration(labelText: "Creator Name"),
            onChanged: (value) => checkForm(context),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    startDate = picked;
                    checkForm(context);
                  }
                },
                child: Text("Select Start Date"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    endDate = picked;
                    checkForm(context);
                  }
                },
                child: Text("Select End Date"),
              ),
            ],
          ),
          Spacer(),
          ElevatedButton(
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
            child: Text("Add Event"),
          ),
        ],
      ),
    );
  }

  void checkForm(BuildContext context) {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        creatorNameController.text.isNotEmpty &&
        startDate != null &&
        endDate != null) {
      context.read<AddEventCubit>().setButtonState(true);
    } else {
      context.read<AddEventCubit>().lockAdd();
    }
  }
}