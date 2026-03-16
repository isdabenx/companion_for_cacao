import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class DetailedPreparationWidget extends StatelessWidget {
  const DetailedPreparationWidget({required this.preparation, super.key});

  final List<PreparationEntity> preparation;

  @override
  Widget build(BuildContext context) {
    return ContainerFullStyleWidget(
      child: Column(
        children: [
          const HeaderWidget(text: 'Preparation'),
          Expanded(
            child: ListView.builder(
              itemCount: preparation.length,
              itemBuilder: (context, index) {
                return PreparationCard(
                  key: ValueKey(index),
                  preparation: preparation[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PreparationCard extends StatefulWidget {
  const PreparationCard({required this.preparation, super.key});

  final PreparationEntity preparation;

  @override
  State<PreparationCard> createState() => _PreparationCardState();
}

class _PreparationCardState extends State<PreparationCard> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.preparation.isCompleted;
  }

  @override
  void didUpdateWidget(covariant PreparationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.preparation.isCompleted != widget.preparation.isCompleted) {
      _isCompleted = widget.preparation.isCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _isCompleted ? AppColors.greenNormal : AppColors.greenDark,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(
            widget.preparation.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              decoration: _isCompleted ? TextDecoration.lineThrough : null,
              color: (widget.preparation.color != null && !_isCompleted)
                  ? AppColors.findColorByName(widget.preparation.color!)
                  : AppColors.brown,
            ),
          ),
          leading: widget.preparation.imagePath != null
              ? Image.asset(widget.preparation.imagePath!)
              : null,
          onTap: () {
            setState(() {
              _isCompleted = !_isCompleted;
            });
          },
        ),
      ),
    );
  }
}
