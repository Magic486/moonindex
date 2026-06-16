// Example: Character encoding bidirectional lookup
// Demonstrates BiMap for bidirectional character mappings

///|
fn morse_code_example() -> Unit {
  let encoding = @moonindex.BiMap::new()

  // Map ASCII characters to their Morse code equivalents
  encoding.insert("A", ".-") |> ignore
  encoding.insert("B", "-...") |> ignore
  encoding.insert("C", "-.") |> ignore
  encoding.insert("D", "-..") |> ignore
  encoding.insert("E", ".") |> ignore
  encoding.insert("F", "..-.") |> ignore
  encoding.insert("G", "--.") |> ignore
  encoding.insert("H", "....") |> ignore

  // Forward lookup: character to Morse code
  let morse_a = encoding.get("A")
  println("A -> \{to_repr(morse_a)}")

  // Reverse lookup: Morse code to character
  let char_dot = encoding.get_key(".")
  println(". -> \{to_repr(char_dot)}")

  // Check if a pair exists
  let has_ae = encoding.contains_pair("A", ".-")
  println("A maps to .-: \{has_ae}")

  // Invert the mapping
  let inverted = encoding.inverse()
  let char_from_morse = inverted.get("-..")
  println("-.. -> \{to_repr(char_from_morse)}")

  // Count total mappings
  println("Total mappings: \{encoding.length()}")

  // Get all keys and values
  let chars = encoding.keys()
  let codes = encoding.values()
  println("Characters: \{to_repr(chars)}")
  println("Morse codes: \{to_repr(codes)}")
}
