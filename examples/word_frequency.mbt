// Example: Word Frequency Counter
// Demonstrates DefaultMap for counting occurrences

fn main {
  let text = "the quick brown fox jumps over the lazy dog the fox was quick"
  let words = text.split(" ")
  
  let counter = @src.DefaultMap::with_value(0)
  
  for word in words.iter() {
    counter.increment(word)
  }
  
  println("Word frequencies:")
  for word in counter.keys().iter() {
    let count = counter.get(word)
    println(word + ": " + count.to_string())
  }
  
  println("\nTotal unique words: " + counter.length().to_string())
  println("Most common word: " + counter.max().unwrap_or(0).to_string())
}
