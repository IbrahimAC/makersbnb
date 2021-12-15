class Booking
  attr_reader :id, :user_id, :space_id, :date, :confirmed

  def initialize(id, user_id, space_id, date, confirmed)
    @id = id
    @user_id = user_id
    @space_id = space_id
    @date = date
    @confirmed = confirmed
  end

  def self.request(user_id, space_id, date)
    return nil if Booking.already_booked?(space_id, date)
    result = DatabaseConnection.query(
      "INSERT INTO bookings (user_id, space_id, date) VALUES($1, $2, $3) 
      RETURNING id, user_id, space_id, date, confirmed;", 
      [user_id, space_id, date]
      )
    Booking.new(result[0]['id'], result[0]['user_id'], result[0]['space_id'], result[0]['date'], result[0]['confirmed'])
  end

  def self.confirm(id, decision)
    result = DatabaseConnection.query("UPDATE bookings SET confirmed = $2 WHERE id = $1 RETURNING id, user_id, space_id, date, confirmed;", [id, decision])
    Booking.new(result[0]['id'], result[0]['user_id'], result[0]['space_id'], result[0]['date'], result[0]['confirmed'])
  end

  def self.already_booked?(space_id, date)
    result = DatabaseConnection.query("select exists(select 1 from bookings where space_id=$1 AND date=$2 AND confirmed='t');", [space_id, date])
    result[0]['exists'] == 't'
  end

  def self.unavailable_dates(space_id)
    result = DatabaseConnection.query("SELECT * FROM bookings where space_id=$1 AND confirmed='t';", [space_id])
    result.map {|booking| booking['date']}
  end

end