import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bharat_nova/widgets/app_colors.dart';

import 'features/home/bloc/feed_bloc.dart';
import 'features/home/data/feed_repository.dart';
import 'features/home/presentation/bottom_nav_page.dart';

void main() {
  runApp(const BharatNovaApp());
}

class BharatNovaApp extends StatelessWidget {
  const BharatNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FeedRepository(),
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (_) => FeedBloc(context.read<FeedRepository>()),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'BharatNova',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
                scaffoldBackgroundColor: AppColors.background,
                useMaterial3: true,
              ),
              home: const BottomNavPage(),
            ),
          );
        },
      ),
    );
  }
}
