# frozen_string_literal: true

require_relative 'database_connection'

class Space
  attr_reader :id, :title, :description, :picture, :price, :user_id

  def initialize(id:, title:, description:, picture:, price:, user_id:)
    @id = id
    @title = title
    @description = description
    @picture = picture
    @price = price
    @user_id = user_id
  end

  def self.create(title:, description:, picture:, price:, user_id:)
    res = DatabaseConnection.query("INSERT INTO spaces(title,description,picture,price,user_id)
    VALUES($1,$2,$3,$4,$5) RETURNING id,title,description,picture,price,user_id;",
                                   [title, description, picture, price, user_id])

    Space.new(
      id: res[0]['id'],
      title: res[0]['title'],
      description: res[0]['description'],
      picture: res[0]['picture'],
      price: res[0]['price'],
      user_id: res[0]['user_id']
    )
  end

  def self.all
    res = DatabaseConnection.query('SELECT * FROM spaces;')
    res.map do |space|
      Space.new(
        id: space['id'],
        title: space['title'],
        description: space['description'],
        picture: space['picture'],
        price: space['price'],
        user_id: space['user_id']
      )
    end
  end

  def self.find(id:)
      res = DatabaseConnection.query("SELECT * FROM spaces WHERE id = $1", [id])
      Space.new(
        id: res[0]['id'],
        title: res[0]['title'],
        description: res[0]['description'],
        picture: res[0]['picture'],
        price: res[0]['price'],
        user_id: res[0]['user_id']
      )
  end

end
