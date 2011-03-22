require 'bundler'
Bundler.require
require 'models'  

set :views, File.dirname(__FILE__) + '/views'

get '/images' do
  @images = Image.all
  erb :images
end

get '/images/new' do
  erb :new_image
end

post '/images' do
  
  if params[:file]
  
    filename = params[:file][:filename]
    file = params[:file][:tempfile]

    AWS::S3::Base.establish_connection!(:access_key_id => "YOUR_ACCESS_KEY", :secret_access_key => "YOUR_SECRET_ACCESS_KEY")
    AWS::S3::S3Object.store(filename, open(file), "webdevbucket", :access => :public_read)

    Image.create(:path => filename, :body => params[:body], :created_at => Time.now)

    "Image uploaded"
  else
    "You have to choose a file"
  end
  
end