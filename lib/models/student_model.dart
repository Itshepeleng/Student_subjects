// =============================================================
// MODEL: Defines WHAT our data looks like
//
// RULES:
// 1. Models contain ONLY properties and constructors
// 2. NO logic, NO UI, NO Flutter widgets
// 3. All properties are final (cannot change)
// 4. Provide copyWith() method for updates
// =============================================================
class StudentModel {
  // These are the pieces of data we track
  final String name; // Student's name
  final String currentSubject; // Currently selected subject
  final List<String> subjects; // All available subjects
  final int currentIndex; // Which subject is selected
  final double grade;
  // Constructor - how we CREATE a StudentModel
  StudentModel({
    required this.name,
    required this.currentSubject,
    required this.subjects,
    required this.currentIndex,
    required this.grade,
  });
  // copyWith - how we "UPDATE" data (creates a new copy with changes)
  StudentModel copyWith({
    String? name,
    String? currentSubject,
    List<String>? subjects,
    int? currentIndex,
    double? grade,
  }) {
    return StudentModel(
      name: name ?? this.name,
      currentSubject: currentSubject ?? this.currentSubject,
      subjects: subjects ?? this.subjects,
      currentIndex: currentIndex ?? this.currentIndex,
      grade:grade?? this.grade,
    );
  }
}
