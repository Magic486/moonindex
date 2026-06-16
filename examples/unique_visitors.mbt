// Example: Unique Visitor Tracker
// Demonstrates IndexSet for tracking unique visitors

///|
fn unique_visitors_example() -> Unit {
  let visitors = @src.IndexSet::new()

  // Simulate visitor log
  let _ = visitors.insert("192.168.1.1")
  let _ = visitors.insert("192.168.1.2")
  let _ = visitors.insert("192.168.1.1") // Duplicate
  let _ = visitors.insert("192.168.1.3")
  let _ = visitors.insert("192.168.1.2") // Duplicate
  let _ = visitors.insert("192.168.1.4")

  println("Unique Visitor Tracker:")
  println("=======================")

  println("Unique visitors:")
  for ip in visitors.iter() {
    println("  " + ip)
  }

  println("\nTotal unique visitors: " + visitors.length().to_string())

  // Check if visitor exists
  println(
    "\n192.168.1.1 visited: " + visitors.contains("192.168.1.1").to_string(),
  )
  println(
    "192.168.1.5 visited: " + visitors.contains("192.168.1.5").to_string(),
  )

  // First and last visitor
  match visitors.first() {
    Some(ip) => println("\nFirst visitor: " + ip)
    None => ()
  }

  match visitors.last() {
    Some(ip) => println("Last visitor: " + ip)
    None => ()
  }

  // Visitor at position
  match visitors.get_at(2) {
    Some(ip) => println("Visitor at position 2: " + ip)
    None => ()
  }
}
