import 'package:flutter/material.dart';
import 'package:frontend/core/utils/app_colors.dart';

class SwipeButton extends StatefulWidget {
  final VoidCallback onSwipe;
  final String text;
  final bool isLoading;

  const SwipeButton({
    super.key,
    required this.onSwipe,
    required this.text,
    this.isLoading = false,
  });

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton> {
  double _position = 0;
  final double _height = 64;
  final double _thumbSize = 56;
  bool _isFinished = false;

  @override
  void didUpdateWidget(covariant SwipeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isLoading && oldWidget.isLoading) {
      // Finished loading, reset position
      setState(() {
        _position = 0;
        _isFinished = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxDrag = constraints.maxWidth - _thumbSize - 8;

        return Container(
          width: double.infinity,
          height: _height,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(_height / 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                widget.isLoading ? 'Processing...' : widget.text,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!widget.isLoading)
                Positioned(
                  left: 4 + _position,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (_isFinished) return;
                      setState(() {
                        _position += details.delta.dx;
                        if (_position < 0) _position = 0;
                        if (_position > maxDrag) _position = maxDrag;
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      if (_isFinished) return;
                      if (_position > maxDrag * 0.8) {
                        setState(() {
                          _position = maxDrag;
                          _isFinished = true;
                        });
                        widget.onSwipe();
                      } else {
                        setState(() {
                          _position = 0;
                        });
                      }
                    },
                    child: Container(
                      width: _thumbSize,
                      height: _thumbSize,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
