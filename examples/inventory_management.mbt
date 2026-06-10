// Example: Inventory Management
// Demonstrates DefaultMap for inventory tracking

fn main {
  let inventory = @src.DefaultMap::with_value(0)
  
  // Initial stock
  inventory.insert("apple", 100)
  inventory.insert("banana", 150)
  inventory.insert("cherry", 75)
  
  println("Inventory Management:")
  println("====================")
  
  println("Initial stock:")
  for entry in inventory.iter() {
    let (item, count) = entry
    println("  " + item + ": " + count.to_string())
  }
  
  // Simulate sales
  println("\nProcessing sales...")
  inventory.subtract("apple", 20)
  inventory.subtract("banana", 30)
  inventory.subtract("cherry", 10)
  
  println("After sales:")
  for entry in inventory.iter() {
    let (item, count) = entry
    println("  " + item + ": " + count.to_string())
  }
  
  // Restock
  println("\nRestocking...")
  inventory.add("apple", 50)
  inventory.add("banana", 25)
  
  println("After restock:")
  for entry in inventory.iter() {
    let (item, count) = entry
    println("  " + item + ": " + count.to_string())
  }
  
  // Check low stock
  let low_stock = inventory.filter(fn(item, count) { count < 100 })
  println("\nLow stock items (<100):")
  for entry in low_stock.iter() {
    let (item, count) = entry
    println("  " + item + ": " + count.to_string())
  }
  
  println("\nTotal items: " + inventory.length().to_string())
  println("Total stock: " + inventory.sum().to_string())
}
