require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

get '/' do
  erb :home
end

get '/drivers' do
  @drivers = query_db "SELECT * FROM drivers"
  erb :drivers_index
end

get '/drivers/new' do
  erb :drivers_new
end

post '/drivers' do
    query_db "INSERT INTO drivers (name, team, podiums, image) VALUES ('#{params[:name]}', '#{params[:team]}', '#{params[:podiums]}', '#{params[:image]}')"
    redirect to('/drivers')
end

get '/drivers/:id' do
  @driver = query_db "SELECT * FROM drivers WHERE id='#{params[:id]}'"
  @driver = @driver.first
  @team = query_db_team "SELECT * FROM teams WHERE name='#{@driver["team"]}'"
  @team = @team.first
  erb :drivers_show
end

get '/drivers/:id/edit' do
  @driver = query_db "SELECT * FROM drivers WHERE id='#{params[:id]}'"
  @driver = @driver.first
  erb :drivers_edit
end

get '/drivers/:id/delete' do
  query_db "DELETE FROM drivers WHERE id='#{params[:id]}'"
  redirect to ('/drivers')
end

post '/drivers/:id' do
  query_db "UPDATE drivers SET name='#{params[:name]}', team='#{params[:team]}', podiums='#{params[:podiums]}', image='#{params[:image]}' WHERE id='#{params[:id]}'"
  redirect to("/drivers/#{params[:id]}")
end

get '/teams' do
  @teams = query_db_team "SELECT * FROM teams"
  erb :teams_index
end

get '/teams/:id' do
    @team = query_db_team "SELECT * FROM teams WHERE id='#{params[:id]}'"
    @team = @team.first
    @drivers = query_db "SELECT * FROM drivers WHERE team='#{@team["name"]}'"
    erb :teams_show
end


def query_db(sql_statement)
  puts sql_statement #Optional but nice for debugging
  db = SQLite3::Database.new 'database.sqlite3'
  db.results_as_hash = true
  results = db.execute sql_statement
  db.close
  results #implicitly return
end

def query_db_team (sql_statement)
  puts sql_statement #Optional but nice for debugging
  db = SQLite3::Database.new 'database2.sqlite3'
  db.results_as_hash = true
  results = db.execute sql_statement
  db.close
  results #implicitly return
end
