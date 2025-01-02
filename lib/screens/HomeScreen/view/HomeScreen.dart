import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:metersystem/utlis/Colors.dart';
import 'package:metersystem/utlis/gap_extension.dart';
import 'package:riverpod/riverpod.dart';
import '../../../utlis/app_router.dart';
import '../../../utlis/widgets/IconButton.dart';
import '../controller/home_provider.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Wrap(

          children: [
            CustomIconButton(
            onTap: () => context.push(RoutesStr.meterList),
              icon: Icons.electric_meter,
              label: "Meter List",
            ), CustomIconButton(
            onTap: () => context.push(RoutesStr.backup),
              icon: Icons.backup,
              label: "Backup Screen",
            ),

          ],
        ),
      ),
    );
  }
}
