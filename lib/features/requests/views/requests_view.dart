import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/home/widget/custom_request_card.dart';
import 'package:clincal/features/requests/controllers/requests_controller.dart';
import 'package:clincal/features/requests/models/patient_request_model.dart';
import 'package:clincal/features/requests/widgets/custom_tab.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:clincal/shared/no_requests.dart';
import 'package:flutter/material.dart';

class RequestsView extends StatelessWidget {
  RequestsView({super.key});
  final AppColors appColors = AppColors();
  final RequestsController _controller = RequestsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Medical Requests",
                    color: Color(0xffDAE2FD),
                    size: 22,
                    weight: FontWeight.w600,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E293B),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.tune_rounded,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const CustomText(
                text: "Manage your\nclinical priorities",
                color: Colors.white,
                size: 32,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              const CustomTab(),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<PatientRequest>>(
                  future: _controller.fetchPatientRequests(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: CustomText(
                          text: "Failed to load requests",
                          color: Color(0xffC5C6CD),
                          weight: FontWeight.w500,
                        ),
                      );
                    }

                    final requests = snapshot.data ?? [];

                    if (requests.isEmpty) {
                      return const NoRequests();
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: requests.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return CustomRequestCard(request: requests[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
