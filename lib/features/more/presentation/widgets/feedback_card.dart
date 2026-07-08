import 'package:flutter/material.dart';

class FeedbackBentoCard extends StatefulWidget {
  final Function(String, String) onSubmit;
  final bool isSubmitted;

  const FeedbackBentoCard({
    super.key,
    required this.onSubmit,
    required this.isSubmitted,
  });

  @override
  State<FeedbackBentoCard> createState() => _FeedbackBentoCardState();
}

class _FeedbackBentoCardState extends State<FeedbackBentoCard> {
  int _selectedStars = 5;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSubmitted) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9F1FF),
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: const Color(0xFFEDE5F5)),
        ),
        padding: const EdgeInsets.all(24.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF16A34A),
              size: 48.0,
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Thank You!',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1A25),
              ),
            ),
            const SizedBox(height: 4.0),
            const Text(
              'Your feedback helps us improve Mall Companion.',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12.0,
                color: Color(0xFF4A4456),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE8DFEF).withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Share Your Experience',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25),
            ),
          ),
          const SizedBox(height: 4.0),
          const Text(
            'How would you rate your visit today?',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11.0,
              color: Color(0xFF4A4456),
            ),
          ),
          const SizedBox(height: 16.0),
          // Star ratings row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starNum = index + 1;
              final isFilled = starNum <= _selectedStars;
              return IconButton(
                onPressed: () {
                  setState(() => _selectedStars = starNum);
                },
                icon: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isFilled
                      ? const Color(0xFFFFD700)
                      : const Color(0xFF7B7488),
                  size: 32.0,
                ),
              );
            }),
          ),
          const SizedBox(height: 16.0),
          // Text comments field
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add your comments (optional)...',
              hintStyle: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12.0,
                color: Color(0xFF7B7488),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: Color(0xFFEDE5F5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: Color(0xFF6100D6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: Color(0xFFEDE5F5)),
              ),
              filled: true,
              fillColor: const Color(0xFFF9F1FF).withOpacity(0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13.0,
              color: Color(0xFF1D1A25),
            ),
          ),
          const SizedBox(height: 16.0),
          // Submit button
          GestureDetector(
            onTap: () {
              widget.onSubmit('$_selectedStars', _commentController.text);
            },
            child: Container(
              height: 48.0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B2FF7), Color(0xFF2170E4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(100.0),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Submit Feedback',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
