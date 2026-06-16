// Example: Task Scheduler
// Demonstrates IndexMap for ordered task scheduling

///|
fn task_scheduler_example() -> Unit {
  let tasks = @src.IndexMap::new()

  // Add tasks in order
  tasks.insert("task1", "Email team")
  tasks.insert("task2", "Review code")
  tasks.insert("task3", "Write tests")
  tasks.insert("task4", "Deploy to production")

  println("Task queue:")
  for i = 0; i < tasks.length(); i = i + 1 {
    match tasks.get_at(i) {
      Some((id, desc)) => println(i.to_string() + ". " + id + ": " + desc)
      None => ()
    }
  }

  // Complete first task
  println("\nCompleting first task...")
  let completed = tasks.pop_first()
  match completed {
    Some((id, desc)) => println("Completed: " + id + " - " + desc)
    None => ()
  }

  println("\nRemaining tasks:")
  for entry in tasks.iter() {
    let (id, desc) = entry
    println(id + ": " + desc)
  }

  println("\nTotal remaining: " + tasks.length().to_string())
}
