import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/base_widgets/base_widget.dart';
import '../../core/costants/string_constants.dart';
import '../../core/enums/form_field_custom_type_enum.dart';
import '../../core/ui/theme/app_colors.dart';
import '../../core/ui/widgets/custom_button/custom_button.dart';
import '../../core/ui/widgets/text_form_custom/screen/text_form_custom_screen.dart';
import '../../core/utils/handle_dismiss_keyboard.dart';
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
  bool isEndDateButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return HandleDismissKeyboard(child: _buildAddEvent(context));
  }

  Widget _buildAddEvent(BuildContext context) {
    return BlocProvider(
      create: (_) => AddEventCubit(),
      child: BlocListener<AddEventCubit, AddEventState>(
        listener: (context, state) {
          if (state is AddEventUnlockAdd) {
            isAddButtonEnabled = true;
          } else if (state is AddEventLockAdd) {
            isAddButtonEnabled = false;
          }
          if (state is EndDateUnlock) {
            isEndDateButtonEnabled = true;
          } else if (state is EndDateLock) {
            isEndDateButtonEnabled = false;
          } else if (state is AddEventSuccess) {
            context.read<AddEventCubit>().showSuccessDialog(context, state.message);
          } else if (state is AddEventError) {
            context.read<AddEventCubit>().showErrorDialog(context, state.message);
          } else if (state is InvalidEndDate) {
            context.read<AddEventCubit>().showErrorDialog(context, state.message);
          }
        },
        child: BlocBuilder<AddEventCubit, AddEventState>(
          builder: (context, state) {
            return BaseWidget(
              navBarTitle: StringConstants.addEvent,
              withOutNavigationBar: false,
              isBackGestureEnabled: true,
              body: Scaffold(body: _buildAddEventWidget(context)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddEventWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormFieldCustom(
                    onChanged: (_) => checkAddEventButton(context),
                    labelText: StringConstants.eventTitle,
                    textEditingController: titleController,
                    hintText: StringConstants.addEventTitleHintText,
                    formFieldType: FormFieldCustomTypeEnum.text,
                  ),
                  SizedBox(height: 16),
                  TextFormFieldCustom(
                    onChanged: (_) => checkAddEventButton(context),
                    labelText: StringConstants.eventDescription,
                    textEditingController: descriptionController,
                    hintText: StringConstants.addEventDescriptionHintText,
                    formFieldType: FormFieldCustomTypeEnum.text,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
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
                              checkAddEventButton(context);
                              checkEndDateButton(context);
                            }
                          }
                        },
                      ),
                      if (startDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(startDate!),
                            style: TextStyle(
                                fontSize: 14, color: AppColors.blackText),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      CustomButton(
                        text: StringConstants.addEventEndDate,
                        filled: isEndDateButtonEnabled,
                        onPressed: isEndDateButtonEnabled
                            ? () async {
                                final pickedDate = await _selectDate(context);
                                if (pickedDate != null) {
                                  final pickedTime = await _selectTime(context,
                                      pickedDate: pickedDate, isEndDate: true);
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
                                    checkAddEventButton(context);
                                  }
                                }
                              }
                            : null,
                      ),
                      if (endDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(endDate!),
                            style: TextStyle(
                                fontSize: 14, color: AppColors.blackText),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            CustomButton(
              text: StringConstants.addEvent,
              filled: isAddButtonEnabled,
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
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
  }

  Future<TimeOfDay?> _selectTime(BuildContext context,
      {DateTime? pickedDate = null, bool isEndDate = false}) async {
    final initialTime = TimeOfDay.now();
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime == null) return null;

    if (isEndDate && startDate != null && pickedDate != null) {
      final selectedDateTime = DateTime(
        pickedDate!.year,
        pickedDate!.month,
        pickedDate!.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      if (startDate!.isAfter(selectedDateTime)) {
        context
            .read<AddEventCubit>()
            .showErrorDialog(context, StringConstants.invalidEndTime);

        return null;
      }
    }

    return selectedTime;
  }

  void checkAddEventButton(BuildContext context) {
    final isFormValid = titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        startDate != null &&
        endDate != null;

    if (isFormValid) {
      context.read<AddEventCubit>().unlockAdd();
    } else {
      context.read<AddEventCubit>().lockAdd();
    }
  }

  void checkEndDateButton(BuildContext context) {
    if (startDate != null) {
      context.read<AddEventCubit>().unlockEndDate();
    } else {
      context.read<AddEventCubit>().lockEndDate();
    }
  }
}
