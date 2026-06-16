// Example: Session management with BiMap
// Demonstrates BiMap for bidirectional user-to-session mapping

///|
fn session_management_example() -> Unit {
  let sessions = @moonindex.BiMap::new()

  // Map user IDs to session tokens
  sessions.insert("user_001", "sess_abc123") |> ignore
  sessions.insert("user_002", "sess_def456") |> ignore
  sessions.insert("user_003", "sess_ghi789") |> ignore

  // Lookup session by user
  let session1 = sessions.get("user_001")
  println("User 001 session: \{session1}")

  // Lookup user by session (reverse lookup)
  let user_from_session = sessions.get_key("sess_def456")
  println("Session sess_def456 belongs to: \{user_from_session}")

  // Check if user has active session
  let has_session = sessions.contains_key("user_002")
  println("User 002 has session: \{has_session}")

  // Check if session token is valid
  let valid_session = sessions.contains_value("sess_abc123")
  println("sess_abc123 is valid: \{valid_session}")

  // Remove user session (logout)
  sessions.remove_by_key("user_002") |> ignore
  let after_logout = sessions.get("user_002")
  println("User 002 after logout: \{after_logout}")

  // Force new session (invalidates old one)
  sessions.force_insert("user_001", "sess_new_token")
  let new_session = sessions.get("user_001")
  let old_session = sessions.get_key("sess_abc123")
  println("User 001 new session: \{new_session}")
  println("Old session still valid: \{old_session}")

  // Get all active sessions
  println("Active users: \{sessions.keys()}")
  println("Active sessions: \{sessions.values()}")
  println("Total active sessions: \{sessions.length()}")
}
