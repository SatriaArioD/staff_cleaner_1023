import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_cleaner/cubit/customer_cubit.dart';
import 'package:staff_cleaner/cubit/schedule_cubit.dart';
import 'package:staff_cleaner/cubit/staff_cubit.dart';
import 'package:staff_cleaner/screens/admin/form/form_customer_screen.dart';
import 'package:staff_cleaner/screens/admin/form/form_schedule_screen.dart';
import 'package:staff_cleaner/values/navigate_utils.dart';

import '../../component/bottom-bar/bottom_bar_admin_component.dart';
import '../../values/color.dart';
import '../models/item_menu.dart';
import 'home/home_admin_screen.dart';
import 'list-user/list_user_staff.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  final _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  int maxCount = 2;

  final List<ItemMenu> item = [
    ItemMenu(
      icon: Icons.home_filled,
    ),
    ItemMenu(
      icon: Icons.people,
    )
  ];

  final List<Widget> bottomBarPages = [
    const HomeAdminScreen(),
    const ListUserStaff(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    initAllCubit();
    super.initState();
  }

  void initAllCubit() {
    context.read<CustomerCubit>().init();
    context.read<ScheduleCubit>().init();
    context.read<StaffCubit>().init();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: bottomBarPages.elementAt(_selectedIndex),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        navigatePush(const FormCustomerScreen());
                      },
                      title: const Text(
                        'Input Customer',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        navigatePush(const FormScheduleScreen());
                      },
                      title: const Text(
                        'Input Jadwal',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBarAdmin(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
