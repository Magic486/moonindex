// Example: Student Grades
// Demonstrates IndexMap for ordered grade book

///|
fn student_grades_example() -> Unit {
  let grades = @src.IndexMap::new()

  // Add students in order
  grades.insert("Alice", 95)
  grades.insert("Bob", 87)
  grades.insert("Charlie", 92)
  grades.insert("Diana", 88)
  grades.insert("Eve", 91)

  println("Grade Book:")
  println("===========")

  for entry in grades.iter() {
    let (name, score) = entry
    let grade = if score >= 90 { "A" } else if score >= 80 { "B" } else { "C" }
    println(name + ": " + score.to_string() + " (" + grade + ")")
  }

  println("\nStatistics:")
  println("Total students: " + grades.length().to_string())

  let sum = grades.fold(0, fn(acc, _, score) { acc + score })
  let avg = sum / grades.length()
  println("Average score: " + avg.to_string())

  // Find highest score
  let highest = grades.fold(0, fn(acc, _, score) { acc.max(score) })
  println("Highest score: " + highest.to_string())

  // Find students with A grade
  let a_students = grades.filter(fn(_, score) { score >= 90 })
  println("\nStudents with A grade:")
  for entry in a_students.iter() {
    let (name, score) = entry
    println(name + ": " + score.to_string())
  }
}
