#----------------------------------------------------------------------
# Zenra - ルーティングと各種モデル、ビューの呼び出しを行うクラス
#----------------------------------------------------------------------

require 'sinatra/base'
require_relative 'models/manga'

class Zenra < Sinatra::Base

	# helpers - コントローラを補佐するメソッドを定義
	#---------------------------------------------------------------------
	helpers do
	end

	# before - 全てのURLにおいて初めに実行される
	#---------------------------------------------------------------------
	before do
	end

	# get '/' - トップページへのアクセス
	#---------------------------------------------------------------------
	get '/' do
    @thumbnails = Manga.thumbnails
		erb :index
	end

  # get '/detail/:id' - 詳細ページ
  #---------------------------------------------------------------------
  get '/detail/:id' do
    @id = params[:id]
    @page_number = params[:page] || 0
    @page_right = Manga.page(@id , @page_number.to_i)
    @page_left = Manga.page(@id , @page_number.to_i + 1)
    if @page_right && @page_left
      data = Manga.read_data(@id)
      @origin = data[:origin] || ''
      @name = data[:name] || ''
      @author = data[:author] || ''
      erb :detail
    else
      pagenum = Manga.page_count(@id)
      redirect "/detail/#{@id}?page=#{pagenum}"
    end
  end

  # post '/detail/:id' - 作品情報の編集
  #--------------------------------------------------------------------
  post '/detail/:id' do
    id = params[:id]
    page = params[:page] || 0
    data = {
      :origin => params[:origin],
      :name => params[:name],
      :author => params[:author]
    }
    Manga.write_data(id , data)
    redirect "/detail/#{id}?page=#{page}"
  end

end
