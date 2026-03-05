// =============================================================
// VIEW: Displays UI and captures user input
//
// RULES:
// 1. View is StatelessWidget (state is in ViewModel)
// 2. View NEVER contains logic - only calls ViewModel methods
// 3. View reads data via getters, never modifies directly
// 4. Use watch() for data that needs to rebuild
// 5. Use read() for actions (button presses)
// 6. Use Consumer for specific parts that need rebuilding
// =============================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/student_viewmodel.dart';

class StudentView extends StatelessWidget {
  const StudentView({super.key});
  @override
  Widget build(BuildContext context) {
    // METHOD 1: watch() - "I need this data and want to rebuild when it changes"
    // Use watch() when this widget DISPLAYS data that can change
    final viewModel = context.watch<StudentViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Student Card - MVVM"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Student Info Card
            _buildInfoCard(viewModel),
            const SizedBox(height: 30),
            // METHOD 2: Consumer - rebuilds ONLY this specific part
            _buildSubjectIndicator(),
            const SizedBox(height: 20),
            // METHOD 3: read() - for button actions
            _buildChangeButton(context),
            const SizedBox(height: 20),
            // Subject list using Consumer
            _buildSubjectList(),

            //Grade section
            const SizedBox(height: 20),
            // --- NEW GRADE SECTION ---
            _buildGradeSection(context, viewModel),
          ],
        ),
      ),
    );
  }

  // Helper method to keep build() clean
  Widget _buildInfoCard(StudentViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        children: [
          Text(
            "Student Name: ${viewModel.studentName}",
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(
            "Favorite Subject: ${viewModel.currentSubject}",
            style: const TextStyle(fontSize: 20, color: Colors.green),
          ),
        ],
      ),
    );
  }

  // Consumer example - only this part rebuilds
  Widget _buildSubjectIndicator() {
    return Consumer<StudentViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Subject ${viewModel.currentIndex + 1} of ${viewModel.subjects.length}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  // Button using read() - doesn't rebuild itself
  Widget _buildChangeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // read() gets ViewModel without rebuilding this button
          context.read<StudentViewModel>().changeSubject();
        },
        child: const Text("Change Subject"),
      ),
    );
  }

  // Subject list using Consumer
  Widget _buildSubjectList() {
    return Consumer<StudentViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            const Text(
              "Available Subjects:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  viewModel.subjects.map((subject) {
                    final isCurrent = subject == viewModel.currentSubject;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent ? Colors.green : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        subject,
                        style: TextStyle(
                          color: isCurrent ? Colors.white : Colors.black,
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        );
      },
    );
  }

  // New Grade UI Section
  Widget _buildGradeSection(BuildContext context, StudentViewModel viewModel) {
    return Column(
      children: [
        Text(
          "Current Grade: ${viewModel.grade.toStringAsFixed(0)}%",
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  () => _showAmountDialog(
                    context,
                    viewModel,
                    isIncreasing: false,
                  ),
              child: const Text("- Decrease"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed:
                  () =>
                      _showAmountDialog(context, viewModel, isIncreasing: true),
              child: const Text("+ Increase"),
            ),
          ],
        ),
      ],
    );
  }

  // THE "ASK" LOGIC: Shows a dialog to get the number from the user
  // Change the signature to accept the ViewModel
  void _showAmountDialog(
    BuildContext context,
    StudentViewModel viewModel, {
    required bool isIncreasing,
  }) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      // We wrap the dialog in a Provider.value to "bridge" the existing ViewModel into the dialog
      builder:
          (dialogContext) => ChangeNotifierProvider.value(
            value: viewModel, // Pass the existing instance
            child: AlertDialog(
              title: Text(isIncreasing ? "Increase Grade" : "Decrease Grade"),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Enter amount"),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    double amount = double.tryParse(controller.text) ?? 0;
                    if (amount == 0) return; // Don't show snackbar for 0 change
                    double finalAmount = isIncreasing ? amount : -amount;

                    // Use the viewModel we passed in directly!
                    viewModel.adjustGrade(finalAmount);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Grade ${isIncreasing ? 'increased' : 'decreased'} by $amount!",
                        ),
                        backgroundColor:
                            isIncreasing ? Colors.green : Colors.redAccent,
                        duration: const Duration(seconds: 2),
                        behavior:
                            SnackBarBehavior.floating, // Makes it look modern
                      ),
                    );
                  },
                  child: const Text("Apply"),
                ),
              ],
            ),
          ),
    );
  }
}
