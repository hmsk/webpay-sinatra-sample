# coding: utf-8
require 'bundler'
Bundler.require

WebPay.api_key = 'test_secret_eHn4TTgsGguBcW764a2KA8Yd'
WEBPAY_PUBLIC_KEY = 'test_public_19DdUs78k2lV8PO8ZCaYX3JT'
WEBDB_PRESS_PRICE = 1554

set :haml, format: :html5

get '/' do
  haml :index
end

get '/partial' do
  haml :partial
end

post '/purchase' do
  begin
    @charge = WebPay::Charge.create(currency: 'jpy', amount: WEBDB_PRESS_PRICE, card: params['webpay-token'])
    haml :purchased, locals: { buyer: params[:buyer] }
  rescue => e
    redirect to('/')
  end
end
