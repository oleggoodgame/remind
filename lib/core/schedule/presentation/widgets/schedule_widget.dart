import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind/common/widgets/text_widget.dart';
import 'package:remind/core/schedule/domain/entity/schedule_entity.dart';
import 'package:remind/core/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:remind/core/schedule/presentation/bloc/week_bloc.dart';

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
  String day = "";

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
    } else {
      text = widget.scheduleEntity.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      buildWhen: (previous, current) {
        if (previous is ScheduleLoaded && current is ScheduleLoaded) {
          final relevant =
              previous.editingIndex == widget.scheduleEntity.index ||
              current.editingIndex == widget.scheduleEntity.index;
          return relevant;
        }
        return false;
      },
      builder: (BuildContext context, state) {
        final externalEditing =
            state is ScheduleLoaded &&
            state.editingIndex == widget.scheduleEntity.index;
        final effectiveIsEditing = isEditing || externalEditing;
        return Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          child: Stack(
            children: [
              effectiveIsEditing
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
                          final weekState = context.read<WeekBloc>().state;
                          final day = weekState is WeekLoaded
                              ? weekState.selectedDay.toString()
                              : DateTime.now().toString();

                          context.read<ScheduleBloc>().add(
                            AddToSchedule(
                              index: widget.scheduleEntity.index,
                              description: text,
                              day: day,
                              time: '',
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),

                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: TextWidget(text: text),
                    ),
            ],
          ),
        );
      },
    );
  }
}
