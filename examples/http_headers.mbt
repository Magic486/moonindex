// Example: HTTP Headers Parser
// Demonstrates MultiMap for handling multiple values per header

///|
fn http_headers_example() -> Unit {
  let headers = @src.MultiMap::new()

  // Simulate HTTP headers
  headers.insert("Accept", "text/html")
  headers.insert("Accept", "application/json")
  headers.insert("Accept", "application/xml")
  headers.insert("Content-Type", "application/json")
  headers.insert("Authorization", "Bearer token123")
  headers.insert("X-Custom-Header", "value1")
  headers.insert("X-Custom-Header", "value2")

  println("All headers:")
  for entry in headers.iter() {
    let (key, values) = entry
    println(key + ": " + values.to_string())
  }

  println(
    "\nAccept header values: " + headers.get("Accept").unwrap_or([]).to_string(),
  )
  println("Number of unique headers: " + headers.key_count().to_string())
  println("Total header values: " + headers.total_count().to_string())
}
