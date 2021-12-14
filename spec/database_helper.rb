# frozen_string_literal: true

require 'pg'

def test_database_setup
  connection = PG.connect(dbname: 'makersbnb_test')
  connection.exec('TRUNCATE users, spaces;')
end
