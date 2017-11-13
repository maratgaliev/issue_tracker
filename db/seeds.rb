password = 'password'
moderator = User.create!(
  email: 'moderator@example.com',
  login: 'moderator',
  password: 'password',
  role: User::MODERATOR_ROLE
)

puts "\n== Creating moderator =="
puts "\nCredentials: #{moderator.email}:#{password}"
