import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firestore/logs/logs_bloc.dart';
import 'package:rehab_flutter/core/bloc/firestore/logs/logs_event.dart';
import 'package:rehab_flutter/core/bloc/firestore/logs/logs_state.dart';

import 'package:rehab_flutter/injection_container.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use GetIt to fetch an instance of LogsBloc
    final logsBloc = sl<LogsBloc>()..add(FetchLogs());

    return BlocProvider<LogsBloc>(
      create: (context) => logsBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Logs'),
        ),
        body: BlocBuilder<LogsBloc, LogsState>(
          builder: (context, state) {
            if (state is LogsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LogsLoaded) {
              final logs = state.logs;
              return ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index].data();
                  final timestamp = (log['timestamp'] as Timestamp).toDate();
                  return ListTile(
                    title: Text(log['email'] ?? 'Unknown User'),
                    subtitle: Text(
                        'Attempted on $timestamp'), // Consider formatting this date
                  );
                },
              );
            } else if (state is LogsError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No logs found'));
          },
        ),
      ),
    );
  }
}
