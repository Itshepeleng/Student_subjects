// =============================================================
// VIEWMODEL: Contains state and logic
//
// RULES:
// 1. ViewModel extends ChangeNotifier (from Flutter)
// 2. ViewModel holds ONE instance of Model (private)
// 3. ViewModel exposes data via getters (READ only)
// 4. ViewModel contains methods that CHANGE data
// 5. Always call notifyListeners() after changing data
// =============================================================
import 'package:flutter/foundation.dart'; // For ChangeNotifier
import '../models/student_model.dart';

class StudentViewModel extends ChangeNotifier {
  // PRIVATE Model instance - the SINGLE SOURCE OF e underscore (_) means: "This is private - don't touch from outside"
  StudentModel _student = StudentModel(
    name: "Mpho",
    currentSubject: "TPG316C",
    subjects: ["TPG316C", "SOD316C", "CMN316C", "ITS316C"],
    currentIndex: 0,
    grade: 0.0,
  );

  // PUBLIC GETTERS - controlled access to data
  // The View can READ but not directly WRITE
  String get studentName => _student.name;
  String get currentSubject => _student.currentSubject;
  List<String> get subjects => _student.subjects;
  int get currentIndex => _student.currentIndex;
  double get grade => _student.grade;

  double get currentGrade => _student.grade;

  // LOGIC METHOD - contains the business logic
  // This is the SAME logic from Unit 1, but now in the right place
  void changeSubject() {
    // 1. Calculate new values (same as Unit 1)
    int newIndex = (_student.currentIndex + 1) % _student.subjects.length;
    String newSubject = _student.subjects[newIndex];
    // 2. Create NEW StudentModel with updated values
    _student = _student.copyWith(
      currentIndex: newIndex,
      currentSubject: newSubject,
    );
    notifyListeners();
  }

// These now just become "shortcuts" to the master method
  void increaseGrade(double amount) => adjustGrade(amount);
  void decreaseGrade(double amount) => adjustGrade(-amount);

  void adjustGrade(double amount) {
    double newGrade = (_student.grade + amount).clamp(0, 100);
    _student = _student.copyWith(grade: newGrade);
    notifyListeners(); // Tells the UI the grade changed
  }
}
