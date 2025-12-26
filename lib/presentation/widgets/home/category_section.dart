import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/category.dart';
import '../common/section_header.dart';

/// Category section for home page
class CategorySection extends StatelessWidget {
  final List<Category> categories;
  final ValueChanged<Category>? onCategoryTap;

  const CategorySection({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Shop by Category',
          subtitle: 'Find exactly what you need',
        ),
        AppSpacing.verticalGapLg,
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.paddingHorizontalLg,
            itemCount: categories.length,
            separatorBuilder: (_, __) => AppSpacing.horizontalGapMd,
            itemBuilder: (context, index) {
              return _CategoryCard(
                category: categories[index],
                onTap: () => onCategoryTap?.call(categories[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final Category category;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.category,
    this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 100,
          padding: AppSpacing.paddingMd,
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.primaryContainer : AppColors.surface,
            borderRadius: AppSpacing.borderRadiusMd,
            border: Border.all(
              color: _isHovered ? AppColors.primary : AppColors.border,
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: _isHovered 
                      ? AppColors.primary 
                      : AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.category.icon,
                  color: _isHovered ? Colors.white : AppColors.primary,
                  size: 24,
                ),
              ),
              AppSpacing.verticalGapSm,
              Text(
                widget.category.name,
                style: AppTypography.labelSmall.copyWith(
                  color: _isHovered ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Category chips for filter bar
class CategoryChips extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?>? onSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.paddingHorizontalLg,
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => AppSpacing.horizontalGapSm,
        itemBuilder: (context, index) {
          if (index == 0) {
            return FilterChip(
              label: const Text('All'),
              selected: selectedCategoryId == null,
              onSelected: (_) => onSelected?.call(null),
            );
          }
          final category = categories[index - 1];
          return FilterChip(
            label: Text(category.name),
            selected: selectedCategoryId == category.id,
            onSelected: (_) => onSelected?.call(category.id),
          );
        },
      ),
    );
  }
}
