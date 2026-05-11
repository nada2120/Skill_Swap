import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';

class SortButton extends StatefulWidget {
  const SortButton({super.key});

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  String? selected;

  final items = [
    'Price: high to low',
    'Price: low to high',
    'Name: A to Z',
    'Name: Z to A',
    'Rate: high to low'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: width * 0.12, // بدل رقم ثابت
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.only(right: width * 0.03),
          ),
          value: selected,
          hint: Text(
            'sort'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
          style: Theme.of(context).textTheme.bodyMedium,
          isExpanded: true,
          items: items
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(
                      option,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          dropdownStyleData: DropdownStyleData(
            offset: const Offset(0, -5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            maxHeight: width * 0.7,
          ),
          iconStyleData: IconStyleData(
            icon: selected == null
                ? const Icon(Icons.keyboard_arrow_down_outlined)
                : const SizedBox(),
          ),
          onChanged: (value) {
            if (value == null) return;

            setState(() => selected = value);

            final bloc = context.read<UserFilterBloc>();

            switch (value) {
              case 'Price: high to low':
                bloc.add(SortUserEvent(SortType.priceLowToHigh));
                break;
              case 'Price: low to high':
                bloc.add(SortUserEvent(SortType.priceLowToHigh));
                break;
              case 'Name: A to Z':
                bloc.add(SortUserEvent(SortType.nameAZ));
                break;
              case 'Name: Z to A':
                bloc.add(SortUserEvent(SortType.nameZA));
                break;
              case 'Rate: high to low':
                bloc.add(SortUserEvent(SortType.rateHigh));
                break;
            }
          },
        ),
      ),
    );
  }
}
