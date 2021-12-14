require 'database_connection'

describe DatabaseConnection do
  it "connects to a database" do
    expect(PG).to receive(:connect).with(dbname: "makersbnb_test")
    DatabaseConnection.setup("makersbnb_test")
  end

  it "executes a sql query" do 
    result = DatabaseConnection.setup("makersbnb_test")
    expect(result).to receive(:exec_params).with("SELECT * FROM users;", []) 
    DatabaseConnection.query("SELECT * FROM users;")
  end
end