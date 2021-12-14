require 'bcrypt'

class User

  attr_reader :id, :name, :email

  def initialize(id, name, email, password)
    @id = id
    @name = name
    @email = email
    @password = password
  end

  def self.create(name:, email:, password:)
    encrypted_password = BCrypt::Password.create(password)
    result = DatabaseConnection.query("INSERT INTO users(name, email, password)
                                      VALUES($1,$2,$3) RETURNING id, name, email, password;", 
                                      [name, email, encrypted_password])
    User.new(result[0]['id'], result[0]['name'], result[0]['email'], result[0]['password'])
  end

end