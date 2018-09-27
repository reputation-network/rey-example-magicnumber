require 'sinatra'
require 'sinatra/json'
require 'base64'

MANIFEST = {
  version: '1.0',
  name: 'Magicnumber',
  description: 'Returns a magic number based on your public key',
  homepage_url: ENV['HOMEPAGE_URL'] || 'http://localhost:8000',
  picture_url: ENV['PICTURE_URL'] || 'https://avatars1.githubusercontent.com/u/42174428?s=200&v=4',
  address: ENV['APP_ADDRESS'] || '0x88032398beab20017e61064af3c7c8bd38f4c968',
  app_url: ENV['APP_URL'] || 'http://localhost:8000/data',
  app_reward: 0,
  app_dependencies: []
}.freeze
APP_SEED = (MANIFEST[:address] + ENV['SECRET_SALT'].to_s).to_i(16).freeze

def parse_subject_header(headers)
  Base64.decode64(headers['HTTP_X_PERMISSION_SUBJECT'] || 'null').gsub(/\A"|"\Z/, '')
end

get '/' do
  redirect '/index.html'
end

get '/manifest' do
  json MANIFEST
end

get '/data' do
  subject_seed = parse_subject_header(request.env).to_i(16)
  json data: Random.new(APP_SEED + subject_seed).rand
end
