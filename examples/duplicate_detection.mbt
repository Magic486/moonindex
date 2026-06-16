// Example: Duplicate file detection
// Demonstrates OrderedMultiSet for tracking duplicate file hashes

///|
fn duplicate_detection_example() -> Unit {
  let file_hashes = @moonindex.OrderedMultiSet::new()

  // Simulate scanning files and computing their hashes
  file_hashes.insert("abc123") |> ignore
  file_hashes.insert("def456") |> ignore
  file_hashes.insert("abc123") |> ignore // Duplicate!
  file_hashes.insert("ghi789") |> ignore
  file_hashes.insert("def456") |> ignore // Another duplicate!
  file_hashes.insert("jkl012") |> ignore

  // Check for duplicates
  let duplicates = file_hashes.duplicates()
  println("Duplicate hashes found: \{duplicates}")

  // Get unique file hashes
  let uniques = file_hashes.uniques()
  println("Unique hashes: \{uniques}")

  // Count occurrences
  let abc_count = file_hashes.count("abc123")
  let def_count = file_hashes.count("def456")
  let ghi_count = file_hashes.count("ghi789")
  println("abc123 appears \{abc_count} times")
  println("def456 appears \{def_count} times")
  println("ghi789 appears \{ghi_count} times")

  // Get most and least common
  let most_common = file_hashes.most_common()
  let least_common = file_hashes.least_common()
  println("Most common hash: \{most_common}")
  println("Least common hash: \{least_common}")

  // Total statistics
  println("Unique files: \{file_hashes.unique_length()}")
  println("Total files scanned: \{file_hashes.total_length()}")
  println("Duplicate count: \{file_hashes.total_duplicates()}")
}
