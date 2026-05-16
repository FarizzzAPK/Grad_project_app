import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/medication/data/medication_controller.dart';
import 'package:clincal/features/medication/data/medication_model.dart';
import 'package:clincal/features/medication/widgets/medication_card.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class MedicationView extends StatefulWidget {
  const MedicationView({super.key});

  @override
  State<MedicationView> createState() => _MedicationViewState();
}

class _MedicationViewState extends State<MedicationView> {
  final AppColors appColors = AppColors();
  final MedicationController _controller = MedicationController();
  final ScrollController _scrollController = ScrollController();

  /// Keys for each medication card, keyed by medication id
  final Map<int, GlobalKey> _cardKeys = {};

  /// Temporarily scroll-highlighted medication id (extra glow on tap)
  int? _scrollHighlightedMedId;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerUpdate);
    _controller.fetchMedications();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Get the nearest medication ID
  int? get _nearestMedId {
    final nearest = _findNearestMedication();
    return nearest?['medId'] as int?;
  }

  /// Scroll to a medication card and apply temporary extra highlight
  void _scrollToMedication(int medId) {
    setState(() => _scrollHighlightedMedId = medId);

    // Try to scroll immediately if the card is already built
    if (_tryScrollToCard(medId)) {
      _startHighlightTimer();
      return;
    }

    // Card not yet built (SliverList lazy rendering) — estimate its position
    // and scroll there first, then use post-frame callback to fine-tune
    final index = _controller.medications.indexWhere((m) => m.id == medId);
    if (index == -1) return;

    // Estimate: each card ~180px + 16px margin, plus ~350px for the top section
    final estimatedOffset = 350.0 + (index * 196.0);
    final maxScroll = _scrollController.position.maxScrollExtent;
    final targetOffset = estimatedOffset.clamp(0.0, maxScroll);

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ).then((_) {
      // After rough scroll, wait for the frame to build the card
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tryScrollToCard(medId);
        _startHighlightTimer();
      });
    });
  }

  /// Attempt to scroll precisely to the card. Returns true if successful.
  bool _tryScrollToCard(int medId) {
    final key = _cardKeys[medId];
    if (key == null || key.currentContext == null) return false;

    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      alignment: 0.3,
    );
    return true;
  }

  /// Start the 2-second highlight fade timer
  void _startHighlightTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _scrollHighlightedMedId = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const CustomText(
          text: 'Medication',
          color: Colors.white,
          size: 24,
          weight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.blueAccent),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }

    if (_controller.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              CustomText(
                text: _controller.errorMessage!,
                color: Colors.white70,
                size: 16,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _controller.fetchMedications(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_controller.medications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medication_outlined, color: Colors.white30, size: 64),
            SizedBox(height: 16),
            CustomText(
              text: 'No medications found',
              color: Colors.white54,
              size: 18,
              weight: FontWeight.w500,
            ),
          ],
        ),
      );
    }

    // Ensure all medications have a GlobalKey
    for (final med in _controller.medications) {
      _cardKeys.putIfAbsent(med.id, () => GlobalKey());
    }

    final nearestId = _nearestMedId;

    return RefreshIndicator(
      onRefresh: () => _controller.fetchMedications(),
      color: Colors.blueAccent,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: _buildTopTimerSection(),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: CustomText(
                text: 'Your Schedule',
                color: Colors.white70,
                size: 18,
                weight: FontWeight.w600,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final med = _controller.medications[index];
                  final isNearest = med.id == nearestId;
                  final isScrollHighlighted = _scrollHighlightedMedId == med.id;
                  return MedicationCard(
                    key: _cardKeys[med.id],
                    medication: med,
                    isHighlighted: isNearest || isScrollHighlighted,
                  );
                },
                childCount: _controller.medications.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  Widget _buildTopTimerSection() {
    // Find the nearest upcoming medication based on reminder times
    final nearest = _findNearestMedication();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A47),
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A4B8C), Color(0xFF162544)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.timer_outlined, color: Colors.white70, size: 32),
          const SizedBox(height: 12),
          const CustomText(
            text: 'Next Dose In',
            color: Colors.white70,
            size: 16,
            weight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CustomText(
                text: nearest != null
                    ? nearest['hours'].toString().padLeft(2, '0')
                    : '--',
                color: Colors.white,
                size: 48,
                weight: FontWeight.bold,
              ),
              const CustomText(
                text: 'H',
                color: Colors.white70,
                size: 20,
                weight: FontWeight.w500,
              ),
              const SizedBox(width: 12),
              CustomText(
                text: nearest != null
                    ? nearest['minutes'].toString().padLeft(2, '0')
                    : '--',
                color: Colors.white,
                size: 48,
                weight: FontWeight.bold,
              ),
              const CustomText(
                text: 'M',
                color: Colors.white70,
                size: 20,
                weight: FontWeight.w500,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Tappable medication name pill
          GestureDetector(
            onTap: nearest != null
                ? () => _scrollToMedication(nearest['medId'] as int)
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.5),
                          blurRadius: 6,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomText(
                    text: nearest != null
                        ? '${nearest['name']} ${nearest['dosage']}'
                        : 'No upcoming dose',
                    color: Colors.white,
                    size: 15,
                    weight: FontWeight.w600,
                  ),
                  if (nearest != null) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white54,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Find the nearest upcoming medication dose
  Map<String, dynamic>? _findNearestMedication() {
    if (_controller.medications.isEmpty) return null;

    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    int? bestDiff;
    MedicationModel? bestMed;

    for (final med in _controller.medications) {
      for (final time in med.formattedReminderTimes) {
        final parts = time.split(':');
        if (parts.length >= 2) {
          final hour = int.tryParse(parts[0]) ?? 0;
          final minute = int.tryParse(parts[1]) ?? 0;
          final timeMinutes = hour * 60 + minute;
          int diff = timeMinutes - nowMinutes;
          if (diff < 0) diff += 24 * 60; // wrap to next day

          if (bestDiff == null || diff < bestDiff) {
            bestDiff = diff;
            bestMed = med;
          }
        }
      }
    }

    if (bestMed != null && bestDiff != null) {
      return {
        'medId': bestMed.id,
        'name': bestMed.name,
        'dosage': bestMed.dosage,
        'hours': bestDiff ~/ 60,
        'minutes': bestDiff % 60,
      };
    }
    return null;
  }
}
