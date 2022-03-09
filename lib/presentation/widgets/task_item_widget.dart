import 'package:events_planning/data/entities.dart';
import 'package:events_planning/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventItemWidget extends StatelessWidget {
  final Event event;
  final EventCategory category;
  final Animation<double> animation;

  const EventItemWidget({
    Key? key,
    required this.event,
    required this.category, required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(event.title, style: AppTheme.eventPanelHeadline),
                SizedBox(height: 16),
                Row(
                  children: [
                    SvgPicture.asset(Resources.clock, width: 20),
                    SizedBox(width: 8),
                    Text(
                        event.startTime != null
                            ? DateTime.parse(event.startTime!).format(FormatDate.deadline)
                            : 'No Date',
                        style: AppTheme.eventPanelHeadline),
                  ],
                ),
                SizedBox(height: 16),
                Wrap(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.purpleDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(category.title, style: AppTheme.eventPanelHeadline),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (DateTime.parse(event.startTime!).millisecondsSinceEpoch > DateTime.now().microsecondsSinceEpoch
                            ? AppTheme.lightOrange
                            : AppTheme.purpleDark)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                          DateTime.parse(event.startTime!).millisecondsSinceEpoch > DateTime.now().microsecondsSinceEpoch
                              ? 'Прошедшее' : 'Предстоящее',
                          style: AppTheme.eventHeadline),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}