# coding: utf-8
require 'bundler'
Bundler.require

webpay = WebPay.new('test_secret_eHn4TTgsGguBcW764a2KA8Yd')
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
    @charge = webpay.charge.create(currency: 'jpy', amount: WEBDB_PRESS_PRICE, card: params['webpay-token'])
    haml :purchased, locals: { buyer: params[:buyer] }
  rescue => e
    redirect to('/')
  end
end

require './env'
class Subscriber < ActiveRecord::Base
  validates_presence_of :customer_id
end

get '/subscribers' do
  @subscribers = Subscriber.all
  haml :subscribers
end

post '/subscribe' do
  begin
    customer = webpay.customer.create(card: params['webpay-token'])
    Subscriber.create(customer_id: customer.id, uuid: UUID.new.generate)
    redirect to('/subscribers')
  rescue => e
    redirect to('/')
  end
end

post '/renew' do
  begin
    Subscriber.all.each do |subscriber|
      charge = webpay.charge.create(currency: 'jpy', amount: WEBDB_PRESS_PRICE, customer: subscriber.customer_id, uuid: subscriber.uuid)
      if charge.id != subscriber.last_charge_id
        subscriber.charge_count += 1
        subscriber.last_charge_id = charge.id
        subscriber.save
      end
      sleep 1
    end
    redirect to('/subscribers')
  rescue => e
    redirect to('/')
  end
end
