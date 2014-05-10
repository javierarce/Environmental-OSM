require 'sinatra'
require 'faraday'
require 'json'

get '/' do
  send_file 'public/index.html'
end

get '/edit/:pa_id' do
  query = "SELECT ST_X(ST_Centroid(the_geom)) AS x, ST_Y(ST_Centroid(the_geom)) AS y FROM pairreplaceabilityscoresandranks WHERE cartodb_id = #{params[:pa_id]}"
  response = Faraday.get "http://carbon-tool.cartodb.com/api/v2/sql?q=#{query}"

  coords = JSON.parse(response.body)["rows"][0]

  if coords.nil?
    status 404
  else
    redirect "http://www.openstreetmap.org/edit?editor=id#map=10/#{coords["y"]}/#{coords["x"]}"
  end
end
