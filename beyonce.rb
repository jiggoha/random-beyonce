# encoding: utf-8
require 'sinatra'
require 'pry'

enable :sessions
enable :method_override

get '/' do
  videos = ['//www.youtube.com/embed/aA9OqUuA6a0',
            '//www.youtube.com/embed/VBmMU_iwe6U',
            '//www.youtube.com/embed/4m1EFMoRFvY',
            '//www.youtube.com/embed/Ob7vObnFUJc',
            '//www.youtube.com/embed/LXXQLa-5n5w',
            '//www.youtube.com/embed/pZ12_E5R3qc']
  vid1 = videos.sample
  result = vid1 #+'?rel=0&autoplay=1'

  setname ||= ''

  erb :index, locals: { result: result, setname: setname }
end

get '/sets' do
  session[:sets] ||= {}
  erb :sets
end

get '/sets/new' do
  erb :new, locals: {}
end

post '/sets' do
  session[:sets] ||= {}

  setname = params[:setname]
  videolist = params[:videolist]
  description = params[:description]
  videolistarray = videolist.split("\n")
  videolistarray.each do |vid|
    vid.chomp!
    vid.gsub!("\t", '')
  end
  videolistarray.delete_if { |vid| vid == '' }
  session[:sets][setname.to_sym] = { 'name' => setname,
                                     'vidnums' => videolistarray,
                                     'description' => description }
  erb :sets
end

get '/sets/:setname' do
  setname = params[:setname]
  erb :template, locals: { setname: setname }
end

get '/sets/:setname/play' do
  setname = params[:setname]
  videos = session[:sets][setname.to_sym]['vidnums']
  vid1 = videos.sample
  result = '//www.youtube.com/embed/' + vid1 + '?rel=0&autoplay=1'

  erb :index, locals: { result: result, setname: setname }
end

get '/sets/:setname/edit' do
  setname = params[:setname]

  erb :edit, locals: { setname: setname }
end

put '/sets/:oldsetname' do
  oldsetname = params[:oldsetname]
  session[:sets].delete(oldsetname.to_sym)

  setname = params[:setname]
  videolist = params[:videolist]
  description = params[:description]
  videolistarray = videolist.split("\n")
  videolistarray.each do |vid|
    vid.chomp!
    vid.gsub!("\t", '')
  end
  videolistarray.delete_if { |vid| vid == '' }
  session[:sets][setname.to_sym] = { 'name' => setname,
                                     'vidnums' => videolistarray,
                                     'description' => description }
  erb :sets
end

delete '/sets/:setname' do
  setname = params[:setname]
  session[:sets].delete(setname.to_sym)

  redirect '/sets'
end
