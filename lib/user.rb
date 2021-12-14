# frozen_string_literal: true

require 'bcrypt'

class User
  attr_reader :id, :name, :email

  def initialize(id, name, email, password)
    @id = id
    @name = name
    @email = email
    @password = password
  end

  def self.create(name, email, password)
    return nil if User.exists?(email)

    encrypted_password = BCrypt::Password.create(password)
    result = DatabaseConnection.query("INSERT INTO users(name, email, password)
                                      VALUES($1,$2,$3) RETURNING id, name, email, password;",
                                      [name, email, encrypted_password])
    User.new(result[0]['id'], result[0]['name'], result[0]['email'], result[0]['password'])
  end

  def self.find(id)
    return nil if id.nil?

    result = DatabaseConnection.query('SELECT * FROM users WHERE id=$1', [id])
    User.new(result[0]['id'], result[0]['name'], result[0]['email'], result[0]['password'])
  end

  def self.exists?(email)
    result = DatabaseConnection.query('SELECT exists (SELECT 1 FROM users WHERE email = $1 LIMIT 1);', [email])
    result[0]['exists'] == 't'
  end

  def self.authenticate(email, password)
    return nil unless User.exists?(email)

    result = DatabaseConnection.query('SELECT * FROM users WHERE email=$1', [email])
    if BCrypt::Password.new(result[0]['password']) == password
      User.new(result[0]['id'], result[0]['name'], result[0]['email'], result[0]['password'])
    end
  end
end
