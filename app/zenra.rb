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
    @page_number = params[:page].to_i > 0 ? params[:page].to_i : 0
    @page_count = Manga.page_count(@id)
    @page_right = Manga.page(@id , @page_number.to_i)
    @page_left = Manga.page(@id , @page_number.to_i + 1)

    if @page_number == 0
      Manga.view_count(@id)
    end

    if @page_right && @page_left
      data = Manga.read_data(@id)
      @origin = data[:origin] || ''
      @name = data[:name] || ''
      @author = data[:author] || ''
      @good_count = data[:good] ? data[:good].length : 0
      erb :detail
    else
      pagenum = Manga.page_count(@id) - 2
      redirect "/detail/#{@id}?page=#{pagenum}"
    end
  end

  # post '/detail/:id' - 作品情報の編集
  #--------------------------------------------------------------------
  post '/detail/:id' do
    id = params[:id]
    if params[:submit] == '更新'
      page = params[:page] || 0
      data = {
        :origin => params[:origin],
        :name => params[:name],
        :author => params[:author]
      }
      Manga.write_data(id , data)
      redirect "/detail/#{id}?page=#{page}"
    else
      Manga.add_good(id)
      redirect "/detail/#{id}"
    end
  end
end
