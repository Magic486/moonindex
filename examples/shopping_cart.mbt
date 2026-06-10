// Example: Shopping Cart
// Demonstrates IndexMap for ordered shopping cart

fn main {
  let cart = @src.IndexMap::new()
  
  // Add items to cart
  cart.insert("apple", (2, 1.50))
  cart.insert("banana", (3, 0.75))
  cart.insert("cherry", (1, 3.00))
  cart.insert("date", (2, 2.50))
  
  println("Shopping Cart:")
  println("==============")
  
  let mut total = 0.0
  for entry in cart.iter() {
    let (item, (qty, price)) = entry
    let item_total = qty.to_double() * price
    total = total + item_total
    println(item + ": " + qty.to_string() + " x $" + price.to_string() + " = $" + item_total.to_string())
  }
  
  println("\nTotal: $" + total.to_string())
  println("Items in cart: " + cart.length().to_string())
  
  // Remove an item
  println("\nRemoving cherry...")
  let _ = cart.remove("cherry")
  
  println("Updated cart:")
  for entry in cart.iter() {
    let (item, (qty, price)) = entry
    println(item + ": " + qty.to_string() + " x $" + price.to_string())
  }
}
