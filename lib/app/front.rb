class LandLordApp < Sinatra::Base
  
  get '/' do
    erb :front, locals: {who: params[:who]}
  end

end
