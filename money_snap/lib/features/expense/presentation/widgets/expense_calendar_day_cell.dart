import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/money_utils.dart';
import '../../domain/entities/expense.dart';

class ExpenseCalendarDayCell extends StatelessWidget {
  const ExpenseCalendarDayCell({
    super.key,
    required this.day,
    required this.expenses,
    required this.isToday,
    required this.onTap,
  });

  final int day;
  final List<Expense> expenses;
  final bool isToday;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 1. Ô trống (không phải ngày trong tháng hiện tại)
    if (day == 0) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    final total = expenses.fold<int>(
      0,
      (s, e) => s + (e.amount > 0 ? e.amount : MoneyUtils.parseAmount(e.description)),
    );
    final hasExpenses = expenses.isNotEmpty;
    
    // Lấy ảnh đầu tiên nếu có
    final firstImage = hasExpenses && expenses.first.imagePath.isNotEmpty
        ? expenses.first.imagePath
        : null;
    final fileExists = firstImage != null && File(firstImage).existsSync();

    // 2. Ngày không có chi tiêu: Hiển thị đơn giản
    if (!hasExpenses) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isToday ? AppColors.todayHighlight : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: isToday ? Border.all(color: AppColors.primary, width: 1.5) : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.overlayLight,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isToday ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      );
    }

    // 3. Ngày CÓ chi tiêu: Ảnh full nền -> Ngày -> Badge -> Tiền
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // Nếu là hôm nay thì thêm viền màu primary để làm nổi bật
            border: isToday ? Border.all(color: AppColors.primary, width: 2) : null,
            boxShadow: [
              BoxShadow(
                color: AppColors.overlayLight,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
            color: AppColors.surface, // Màu nền dự phòng nếu không có ảnh
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6), // Bo góc ảnh (-2px so với container border)
            child: Stack(
              fit: StackFit.expand, // Quan trọng: Để ảnh chiếm full không gian
              children: [
                // --- LAYER 1: HÌNH ẢNH NỀN ---
                if (fileExists)
                  Image.file(
                    File(firstImage),
                    fit: BoxFit.cover,
                  )
                else
                  // Nếu không có file ảnh thực tế, hiện icon mờ
                  Container(
                    color: AppColors.surface,
                    child: Center(
                      child: Icon(
                        Icons.receipt_long,
                        size: 24,
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                    ),
                  ),

                // Một lớp overlay đen mờ nhẹ ở dưới đáy để làm nổi bật số tiền (tùy chọn)
                if (fileExists)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                // --- LAYER 2: SỐ NGÀY (Góc trên trái) ---
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.85), // Nền trắng mờ để dễ đọc
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$day',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),

                // --- LAYER 3: BADGE SỐ LƯỢNG (Góc trên phải - Nếu > 1) ---
                if (expenses.length > 1)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '+${expenses.length - 1}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),

                // --- LAYER 4: TỔNG TIỀN (Góc dưới hoặc Canh giữa dưới) ---
                if (total > 0)
                  Positioned(
                    bottom: 4,
                    left: 4,
                    right: 4,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.expense, // Màu đỏ
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            )
                          ],
                        ),
                        child: Text(
                          MoneyUtils.formatExpenseCompact(total),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}