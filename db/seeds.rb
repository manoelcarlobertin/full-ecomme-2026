# Criação do Admin Inicial
if User.where(email: "admin@onebitcode.com").empty?
  User.create!(
    name: "Manoel Admin",
    email: "admin@onebitcode.com",
    password: "password123",
    password_confirmation: "password123",
    profile: :admin # Importante: Define como ADMIN
  )
  puts "✅ Admin criado: admin@onebitcode.com / password123"
end
