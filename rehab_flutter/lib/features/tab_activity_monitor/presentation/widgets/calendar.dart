import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final Map<String, Color?> dateColorsMap;
  final CalendarFormat calendarFormat;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final bool Function(DateTime)? selectedDayPredicate;
  final Function(DateTime, DateTime)? onDaySelected;
  final void Function(DateTime)? onPageChanged;
  final void Function() onToggleFormat;

  const Calendar({
    super.key,
    required this.dateColorsMap,
    required this.calendarFormat,
    required this.focusedDay,
    required this.selectedDay,
    required this.selectedDayPredicate,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onToggleFormat,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      shadowStrength: 2,
      shadowColor: Colors.black,
      blur: 4,
      color: Colors.white.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: focusedDay,
            calendarFormat: calendarFormat,
            selectedDayPredicate: selectedDayPredicate,
            onDaySelected: onDaySelected,
            onPageChanged: onPageChanged,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Sailec Medium',
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
            ),
            calendarStyle: CalendarStyle(
              tablePadding: const EdgeInsets.symmetric(horizontal: 16),
              todayDecoration: const BoxDecoration(
                color: Color(0xFF9FA8DA),
                shape: BoxShape.rectangle,
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xff275492),
                borderRadius: BorderRadius.circular(5),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xff275492),
                borderRadius: BorderRadius.circular(5),
              ),
              weekendTextStyle: const TextStyle(color: Colors.white),
              defaultTextStyle: const TextStyle(color: Colors.white),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  width: 2,
                  color: const Color(0xff01FF99),
                ),
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.white),
            ),
            calendarBuilders: CalendarBuilders(
              // Customize the appearance of individual calendar cells
              markerBuilder: (context, date, events) {
                final dateString = formatDateMMDDYYYY(date);
                final color = dateColorsMap[dateString];
                if (color != null) {
                  return Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
              defaultBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: const Color(0xff275492),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
              selectedBuilder: (context, date, _) {
                //final dateString = "${date.year}${date.month}${date.day}";
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: const Color(0xff275492),
                    border: Border.all(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      width: 2,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
              // Customize the appearance of the focused day
              todayBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: const Color(0xff275492),
                    border: Border.all(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      width: 2,
                      color: const Color(0xff01FF99),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(calendarFormat == CalendarFormat.week ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, color: Colors.white),
                onPressed: () => onToggleFormat(),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'LESS',
                      style: TextStyle(fontFamily: 'Sailec Light', fontSize: 10, color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    _buildLegendItem(heatmap1),
                    // _buildLegendItem(heatmap2),
                    _buildLegendItem(heatmap3),
                    // _buildLegendItem(heatmap4),
                    _buildLegendItem(heatmap5),
                    const SizedBox(width: 4),
                    const Text(
                      'MORE',
                      style: TextStyle(fontFamily: 'Sailec Light', fontSize: 10, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildLegendItem(Color color) {
  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 4),
    ],
  );
}
