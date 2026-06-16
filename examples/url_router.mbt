// Example: URL Router
// Demonstrates IndexMap for ordered URL routing

///|
fn url_router_example() -> Unit {
  let routes = @src.IndexMap::new()

  // Define routes
  routes.insert("/", "HomeController")
  routes.insert("/about", "AboutController")
  routes.insert("/users", "UsersController")
  routes.insert("/users/:id", "UserDetailController")
  routes.insert("/posts", "PostsController")
  routes.insert("/posts/:id", "PostDetailController")
  routes.insert("/api/v1/users", "ApiUsersController")
  routes.insert("/api/v1/posts", "ApiPostsController")

  println("URL Router:")
  println("==========")

  println("Registered routes:")
  for entry in routes.iter() {
    let (path, controller) = entry
    println("  " + path + " -> " + controller)
  }

  println("\nTotal routes: " + routes.length().to_string())

  // Find API routes
  let api_routes = routes.filter(fn(path, _) { path.has_prefix("/api") })
  println("\nAPI routes:")
  for entry in api_routes.iter() {
    let (path, controller) = entry
    println("  " + path + " -> " + controller)
  }

  // Find routes with parameters
  let param_routes = routes.filter(fn(path, _) { path.contains(":") })
  println("\nRoutes with parameters:")
  for entry in param_routes.iter() {
    let (path, controller) = entry
    println("  " + path + " -> " + controller)
  }

  // Lookup route
  println("\nRoute lookup:")
  println("  /users -> " + routes.get("/users").unwrap_or("Not Found"))
  println("  /unknown -> " + routes.get("/unknown").unwrap_or("Not Found"))

  // Check route exists
  println("\nRoute exists:")
  println("  /about: " + routes.contains("/about").to_string())
  println("  /admin: " + routes.contains("/admin").to_string())

  // Add new route
  println("\nAdding /contact route...")
  routes.insert("/contact", "ContactController")
  println("  /contact -> " + routes.get("/contact").unwrap_or("Not Found"))

  println("\nTotal routes now: " + routes.length().to_string())
}
