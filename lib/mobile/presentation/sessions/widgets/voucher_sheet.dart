import 'package:flutter/material.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

import '../../../../shared/data/models/store/purchases.dart';

class VoucherSheet extends StatefulWidget {
  final List<Purchases> vouchers;
  final Purchases? selected;

  const VoucherSheet({
    super.key,
    required this.vouchers,
    this.selected,
  });

  @override
  State<VoucherSheet> createState() => _VoucherSheetState();
}

class _VoucherSheetState extends State<VoucherSheet> {
  Purchases? selectedVoucher;

  @override
  void initState() {
    super.initState();
    selectedVoucher = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Choose Voucher",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppPalette.primary)),
          const SizedBox(height: 12),
          ...widget.vouchers.map((voucher) {
            final isSelected = selectedVoucher == voucher;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedVoucher = voucher;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                  //isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppPalette.primary
                        : Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedScale(
                      scale: isSelected ? 1.1 : 1,
                      duration: Duration(milliseconds: 300),
                      child: AnimatedScale(
                        scale: isSelected ? 1.05 : 1,
                        duration: Duration(milliseconds: 300),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            voucher.itemId?.img?.secureUrl ?? "",
                            height: 50,
                            width: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 80,
                              color: Colors.grey.shade300,
                              child: Icon(Icons.local_offer),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        voucher.itemId?.value ?? "",
                        style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white : AppPalette.primary),
                      ),
                    ),
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: AppPalette.primary,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selectedVoucher);
                },
                child: Text(
                  "Apply",
                  style: TextStyle(
                    color: AppPalette.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: Text(
                  "Remove",
                  style: TextStyle(
                    color: AppPalette.primary,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
