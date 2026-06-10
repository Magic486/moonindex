// Example: Graph Adjacency List
// Demonstrates MultiMap for graph representation

fn main {
  let graph = @src.MultiMap::new()
  
  // Build a simple graph
  graph.insert("A", "B")
  graph.insert("A", "C")
  graph.insert("B", "C")
  graph.insert("B", "D")
  graph.insert("C", "D")
  graph.insert("D", "A")
  
  println("Graph Adjacency List:")
  println("====================")
  
  for entry in graph.iter() {
    let (node, neighbors) = entry
    println(node + " -> " + neighbors.to_string())
  }
  
  println("\nGraph Statistics:")
  println("Nodes: " + graph.key_count().to_string())
  println("Edges: " + graph.total_count().to_string())
  
  // Check if node exists
  println("\nNode A exists: " + graph.contains("A").to_string())
  println("Node E exists: " + graph.contains("E").to_string())
  
  // Check edge
  println("Edge A->B exists: " + graph.contains_pair("A", "B").to_string())
  println("Edge A->D exists: " + graph.contains_pair("A", "D").to_string())
  
  // Get neighbors
  println("\nNeighbors of B:")
  match graph.get("B") {
    Some(neighbors) => {
      for neighbor in neighbors.iter() {
        println("  " + neighbor)
      }
    }
    None => ()
  }
  
  // Degree of each node
  println("\nNode degrees:")
  for key in graph.keys().iter() {
    let degree = graph.get_count(key)
    println(key + ": " + degree.to_string())
  }
}
