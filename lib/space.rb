# frozen_string_literal: true

require_relative 'database_connection'
require 'date'

class Space
  attr_reader :id, :title, :description, :picture, :price, :user_id, :availability_from, :availability_until

  def initialize(id:, title:, description:, picture:, price:, user_id:, availability_from:, availability_until:)
    @id = id
    @title = title
    @description = description
    @picture = picture
    @price = price
    @user_id = user_id
    @availability_from = availability_from
    @availability_until = availability_until
  end

  def self.create(title:, description:, picture:, price:, user_id:, availability_from:, availability_until:)
    res = DatabaseConnection.query("INSERT INTO spaces(title, description, picture, price, user_id, availability_from, availability_until)
    VALUES($1,$2,$3,$4,$5,$6,$7) RETURNING id, title, description, picture, price, user_id, availability_from, availability_until;",
                                   [title, description, picture, price, user_id, availability_from, availability_until])

    Space.new(
      id: res[0]['id'],
      title: res[0]['title'],
      description: res[0]['description'],
      picture: res[0]['picture'],
      price: res[0]['price'],
      user_id: res[0]['user_id'],
      availability_from: res[0]['availability_from'],
      availability_until: res[0]['availability_until']
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
        user_id: space['user_id'],
        availability_from: space['availability_from'],
        availability_until: space['availability_until']
      )
    end
  end

  def self.find(id:)
    res = DatabaseConnection.query('SELECT * FROM spaces WHERE id = $1', [id])
    Space.new(
      id: res[0]['id'],
      title: res[0]['title'],
      description: res[0]['description'],
      picture: res[0]['picture'],
      price: res[0]['price'],
      user_id: res[0]['user_id'],
      availability_from: res[0]['availability_from'],
      availability_until: res[0]['availability_until']
    )
  end


  def self.list_available_dates(space:)
    result = []
    (Date.parse("#{space.availability_from}")..Date.parse("#{space.availability_until}")).uniq { |d| result << d.strftime('%Y-%m-%d') }
    result
  end

  def self.delete(id:)
    #Booking.delete could be added below! ----
    DatabaseConnection.query('DELETE FROM bookings WHERE space_id = $1;', [id])
    # ------- 
    DatabaseConnection.query('DELETE FROM spaces WHERE id = $1;', [id])
  end

  def self.update(id:, title:, description:, picture:, price:, availability_from:, availability_until:)
    res = DatabaseConnection.query("UPDATE spaces
          SET title=$2, description=$3, picture=$4, price=$5, availability_from=$6, availability_until=$7
          WHERE id = $1
          RETURNING id, title, description, picture, price, user_id, availability_from, availability_until;",
          [id, title, description, picture, price, availability_from, availability_until])
    Space.new(
      id: res[0]['id'],
      title: res[0]['title'],
      description: res[0]['description'],
      picture: res[0]['picture'],
      price: res[0]['price'],
      user_id: res[0]['user_id'],
      availability_from: res[0]['availability_from'],
      availability_until: res[0]['availability_until']
    )
  end

end


