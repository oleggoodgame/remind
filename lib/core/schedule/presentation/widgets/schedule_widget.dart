import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind/common/widgets/text_widget.dart';
import 'package:remind/core/schedule/domain/entity/schedule_entity.dart';
import 'package:remind/core/schedule/presentation/bloc/schedule_bloc.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({
    required this.scheduleEntity,
    this.created = false,
    super.key,
  });
  final bool created;
  final ScheduleEntity scheduleEntity;
  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  late final TextEditingController textEditingController;
  late final FocusNode focusNode;
  late bool isEditing;
  String text = "";

  @override
  void initState() {
    super.initState();
    print("CREATED SCHDULE WIDGET");
    isEditing = widget.created;
    print("IsEditing: $isEditing");
    textEditingController = TextEditingController(
      text: widget.created ? text : widget.scheduleEntity.description,
    );
    focusNode = FocusNode();
    if (widget.created) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 16, horizontal: 20),
      child: Stack(
        children: [
          isEditing
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    focusNode: focusNode,
                    controller: textEditingController,
                    onSubmitted: (value) {
                      setState(() {
                        text = textEditingController.text;
                        isEditing = false;
                      });
                      context.read<ScheduleBloc>().add(
                        AddToSchedule(
                          index: widget.scheduleEntity.index,
                          description: text,
                          day: DateTime.now().toString(),
                          time: '',
                        ),
                      );
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(text: text),
                ),
        ],
      ),
    );
  }
}
