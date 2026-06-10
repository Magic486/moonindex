// Example: Configuration Manager
// Demonstrates IndexMap for ordered configuration

fn main {
  let config = @src.IndexMap::new()
  
  // Load configuration
  config.insert("database.host", "localhost")
  config.insert("database.port", "5432")
  config.insert("database.name", "myapp")
  config.insert("cache.enabled", "true")
  config.insert("cache.ttl", "3600")
  config.insert("logging.level", "info")
  config.insert("logging.file", "/var/log/app.log")
  
  println("Configuration Manager:")
  println("=====================")
  
  println("All settings:")
  for entry in config.iter() {
    let (key, value) = entry
    println("  " + key + " = " + value)
  }
  
  // Get specific values
  println("\nDatabase host: " + config.get_or_default("database.host", "unknown"))
  println("Database port: " + config.get_or_default("database.port", "0"))
  println("Cache enabled: " + config.get_or_default("cache.enabled", "false"))
  
  // Check if key exists
  println("\nHas logging config: " + config.contains("logging.level").to_string())
  println("Has mail config: " + config.contains("mail.host").to_string())
  
  // Update value
  config.update("cache.ttl", fn(v) { (v.to_int() * 2).to_string() })
  println("\nUpdated cache TTL: " + config.get("cache.ttl").unwrap_or("0"))
  
  // Remove setting
  let _ = config.remove("logging.file")
  println("\nAfter removing logging.file:")
  println("Has logging.file: " + config.contains("logging.file").to_string())
  
  println("\nTotal settings: " + config.length().to_string())
}
