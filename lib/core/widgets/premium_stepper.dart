import 'package:flutter/material.dart';
import 'package:tailorx/core/constants/app_colors.dart';

class PremiumStepper extends StatelessWidget {
  final int currentStep;
  final String title;
  final String subtitle;

  const PremiumStepper({
    super.key,
    required this.currentStep,
    required this.title,
    required this.subtitle,
  }) : assert(currentStep >= 1 && currentStep <= 3);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(17, 16, 17, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.23),
            blurRadius: 24,
            offset: const Offset(0, 11),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            top: -28,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white.withValues(alpha: 0.11),
              size: 112,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 58),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP $currentStep OF 3',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _StepNode(
                      number: 1,
                      currentStep: currentStep,
                    ),
                    _StepLine(
                      isComplete: currentStep > 1,
                    ),
                    _StepNode(
                      number: 2,
                      currentStep: currentStep,
                    ),
                    _StepLine(
                      isComplete: currentStep > 2,
                    ),
                    _StepNode(
                      number: 3,
                      currentStep: currentStep,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepNode extends StatelessWidget {
  final int number;
  final int currentStep;

  const _StepNode({
    required this.number,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final bool isComplete = number < currentStep;
    final bool isActive = number == currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        color: isActive || isComplete
            ? Colors.white
            : Colors.white.withValues(alpha: 0.16),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.30),
        ),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: isComplete
              ? const Icon(
            Icons.check_rounded,
            key: ValueKey<String>('check'),
            color: AppColors.primaryDark,
            size: 16,
          )
              : Text(
            '$number',
            key: ValueKey<int>(number),
            style: TextStyle(
              color: isActive
                  ? AppColors.primaryDark
                  : Colors.white70,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isComplete;

  const _StepLine({
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isComplete
              ? Colors.white
              : Colors.white.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
