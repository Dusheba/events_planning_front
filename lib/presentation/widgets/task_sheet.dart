import 'package:events_planning/data/client.dart';
import 'package:events_planning/data/entities.dart';
import 'package:events_planning/data/entities.dart';
import 'package:events_planning/presentation/utils/utils.dart';
import 'package:events_planning/presentation/widgets/custom_date/filter_wrapper.dart';
import 'package:events_planning/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'buttons.dart';
import 'state_widgets.dart';

class TaskSheet extends StatefulWidget {
  final int? categoryId;
  final bool isUpdate;
  final Event? event;

  const TaskSheet({Key? key, this.event, this.categoryId, this.isUpdate = false})
      : super(key: key);

  @override
  _TaskSheetState createState() => _TaskSheetState();
}

class _TaskSheetState extends State<TaskSheet> {
  Event? event;
  EventCategory? category;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late int? selectedCategory = widget.categoryId ?? null;
  DateTime? datePicked;
  TimeOfDay? timePicked;
  List<EventCategory>? cats = [];
  Client? owner;

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 3),
        () => 'Data Loaded',
  );

  getData() async {
    cats = await EventCategory.fetchData();
    if(widget.categoryId!=null){
      category = await EventCategory.fetchCatById(widget.categoryId!);
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
      owner = await Client.fetchClient(preferences.getInt('currentId')!);
  }

  @override
  void initState() {
    getData();
    if (widget.isUpdate) {
      event = widget.event!;
      // categoryItem = widget.task!.taskCategoryItemEntity;
      titleController = TextEditingController(text: event!.title);
      descriptionController = TextEditingController(text: event!.description);
      addressController = TextEditingController(text: event!.address);
      selectedCategory = category!.id;
      datePicked = event!.startTime;
      timePicked = event?.startTime != null
          ? TimeOfDay.fromDateTime(event!.startTime!)
          : null;
    } else {
      titleController = TextEditingController();
      descriptionController = TextEditingController();
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // _deleteTask() {
  //   showDialog<bool>(
  //     context: context,
  //     builder: (context) => FilterWrapper(
  //       blurAmount: 5,
  //       child: AlertDialog(
  //         title: Text("Delete the task?", style: AppTheme.eventPanelHeadline),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             GarbageWidget(),
  //             SizedBox(height: 20),
  //             Text(
  //               'Are you sure want to delete the task?',
  //               style: AppTheme.eventPanelHeadline,
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //               onPressed: () => Navigator.pop(context, false),
  //               child: Text(
  //                 'Cancel',
  //                 style: AppTheme.eventPanelHeadline,
  //               )),
  //           TextButton(
  //             onPressed: () {
  //               context.read<TaskBloc>().add(DeleteTask(id: taskItem.id!));
  //               Helper.showCustomSnackBar(
  //                 context,
  //                 content: 'Success Delete Task',
  //                 bgColor: AppTheme.redPastel.lighter(30),
  //               );
  //               Navigator.pop(context, true);
  //             },
  //             child: Text(
  //               'Delete',
  //               style: AppTheme.text1.withPurple,
  //             ),
  //           ),
  //         ],
  //         insetPadding:
  //         const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         clipBehavior: Clip.antiAlias,
  //       ),
  //     ),
  //   ).then((isDelete) {
  //     if(isDelete != null && isDelete){
  //       Navigator.pop(context);
  //     }
  //   });
  // }

  // _markAsDone() {
  //   isCompleted = true;
  //   _updateTask();
  // }

  _updateTask() {
    if (_formKey.currentState!.validate()) {
      Event eventItemEntity = Event(
        id: event!.id,
        title: titleController.text,
        description: descriptionController.text,
        category: cats![selectedCategory!-1],
        address: event!.address,
        budget: event!.budget,
        owner: owner!
      );
      if (datePicked != null) {
        final DateTime savedDeadline = DateTime(
          datePicked!.year,
          datePicked!.month,
          datePicked!.day,
          timePicked != null ? timePicked!.hour : DateTime.now().hour,
          timePicked != null ? timePicked!.minute : DateTime.now().minute,
        );
        eventItemEntity = Event(
          id: event!.id,
          title: titleController.text,
          description: descriptionController.text,
          category: cats![selectedCategory!-1],
          address: titleController.text,
          startTime: savedDeadline.toLocal(),
          owner: owner!
        );
      }
      // context.read<TaskBloc>().add(UpdateTask(taskItemEntity: taskItemEntity));
      Event.addEvent(eventItemEntity);
      Helper.showCustomSnackBar(
        context,
        content: 'Success Update Task',
        bgColor: AppTheme.purpleDark,
      );
      Navigator.pop(context);
    }
  }

  _saveTask() {
    if (_formKey.currentState!.validate()) {
      Event eventItemEntity = Event(
          // id: event!.id ?? 0,
          title: titleController.text,
          description: descriptionController.text,
          category: cats![selectedCategory!-1],
          address: addressController.text,
          budget: 1000,
          owner: owner!
      );
      if (datePicked != null) {
        final DateTime savedDeadline = DateTime(
          datePicked!.year,
          datePicked!.month,
          datePicked!.day,
          timePicked != null ? timePicked!.hour : DateTime.now().hour,
          timePicked != null ? timePicked!.minute : DateTime.now().minute,
        );
        eventItemEntity = Event(
            // id:  event!.id ?? 0,
            title: titleController.text,
            description: descriptionController.text,
            category: cats![selectedCategory!-1],
            address: addressController.text,
            startTime: savedDeadline,
            owner: owner!
        );
      }
      Event.addEvent(eventItemEntity).then((value) => print(value.statusCode));
      Helper.showCustomSnackBar(
        context,
        content: 'Событие добавлено',
        bgColor: AppTheme.purplePink.lighter(30),
      );
      setState(() {
      });
      Navigator.pop(context);
    }
  }

  _getDate() async {
    Helper.unfocus();
    final picked = await Helper.showDeadlineDatePicker(
      context,
      datePicked ?? DateTime.now(),
    );
    if (picked != null && picked != datePicked) {
      setState(() {
        datePicked = picked;
      });
    }
  }

  _getTime() {
    Helper.unfocus();
    Helper.showDeadlineTimePicker(
      context,
      timePicked ?? TimeOfDay.now(),
      onTimeChanged: (TimeOfDay timeOfDay) {
        if (timeOfDay != timePicked) {
          setState(() {
            timePicked = timeOfDay;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _calculation,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (snapshot.hasData) {
        return Material(
          child: SafeArea(
            top: false,
            child: Padding(
              padding: MediaQuery
                  .of(context)
                  .viewInsets,
              child: Container(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        widget.isUpdate
                            ? Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: SvgPicture.asset(
                                Resources.trash,
                                height: 20,
                                width: 20,
                              ),
                              onTap: ()=>{}
                              // _deleteTask,
                            ),
                            Text('Update Task',
                                style: AppTheme.mainPageHeadline),
                            GestureDetector(
                              child: SvgPicture.asset(
                                Resources.complete,
                                height: 20,
                                width: 20,
                              ),
                              onTap: _updateTask,
                            ),
                          ],
                        )
                            : Center(
                          child: Text('Add Task',
                              style: AppTheme.mainPageHeadline),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: AppTheme.eventPanelHeadline.withBlack,
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: 'Название',
                            hintStyle: AppTheme.hintsText,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(
                                color: AppTheme.borderPurple
                              )
                            )
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your title task';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: AppTheme.eventPanelHeadline.withBlack,
                          controller: addressController,
                          decoration: InputDecoration(
                            hintText: 'Адрес',
                            hintStyle: AppTheme.hintsText,
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: AppTheme.borderPurple
                            )
                        )
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address task';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: AppTheme.eventPanelHeadline.withBlack,
                          controller: descriptionController,
                          decoration: InputDecoration(
                            hintText: 'Описание',
                            hintStyle: AppTheme.hintsText,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: BorderSide(
                                      color: AppTheme.borderPurple
                                  )
                              )
                          ),
                          maxLines: 5,
                          scrollPhysics: BouncingScrollPhysics(),
                        ),
                        SizedBox(height: 20),
                        Row(children: [
                          Expanded(
                            child: RippleButton(
                              onTap: _getDate,
                              text: datePicked != null
                                  ? datePicked!
                                  .format(FormatDate.monthDayYear)
                                  : 'Дата',
                              prefixWidget: SvgPicture.asset(
                                  Resources.date,
                                  color: Colors.white,
                                  width: 16),
                              suffixWidget: datePicked != null
                                  ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    datePicked = null;
                                  });
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                                  : null,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: RippleButton(
                              onTap: _getTime,
                              text: timePicked != null
                                  ? timePicked!.format(context)
                                  : 'Время',
                              prefixWidget: SvgPicture.asset(
                                  Resources.clock,
                                  color: Colors.white,
                                  width: 16),
                              suffixWidget: timePicked != null
                                  ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    timePicked = null;
                                  });
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                                  : null,
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
                        cats!=null
                            ? DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            hintText: 'Выберите категорию',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: BorderSide(
                                      color: AppTheme.borderPurple
                                  )
                              )
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Please fill in category';
                            }
                            return null;
                          },
                          onTap: () => Helper.unfocus(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                          items: cats!
                              .map((e) {
                            return DropdownMenuItem(
                              value: e.id,
                              child: Text(e.title),
                            );
                          }).toList(),
                          style: AppTheme.eventPanelHeadline.withBlack,
                          value: selectedCategory,
                        )
                            : Container(),
                        SizedBox(height: 20),
                        PinkButton(
                          text: widget.isUpdate
                              ? 'Mark as Done'
                              : 'Сохранить',
                          onTap:
                          widget.isUpdate ? _saveTask() : _saveTask,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      else {
        return LoadingWidget();
      }
      },
    );
  }
}
