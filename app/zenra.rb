#----------------------------------------------------------------------
# Zenra - ルーティングと各種モデル、ビューの呼び出しを行うクラス
#----------------------------------------------------------------------

require 'sinatra/base'
require_relative 'models/util'
require_relative 'models/manga'
require_relative 'models/mangaManager'

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
    opt = {}
    if params[:search_word]
      opt[params[:category].to_sym] = params[:search_word]
    end
    manga_list_hash = MangaManager.list(opt)
    @manga_list = manga_list_hash.values.sort_by {|item| item[:name]}
    @database = Util.to_json(manga_list_hash)
		erb :index
	end

  # get '/detail/:id' - 詳細ページ
  #---------------------------------------------------------------------
  get '/detail/:id' do
    manga = Manga.new(params[:id])
    @id = params[:id]
    @page_count = manga.page_count
    @page_number = params[:page].to_i >= 0 ? params[:page].to_i : @page_count - 1
    @page_right = manga.page(@page_number.to_i)
    @page_left = manga.page(@page_number.to_i + 1)
    @page_number == 0 and manga.view_count

    if @page_right && @page_left
      @origin = manga.origin
      @name = manga.name
      @author = manga.author
      @good_count = manga.good_count
      erb :detail
    else
      pagenum = manga.page_count - 2
      redirect "/detail/#{@id}?page=#{pagenum}"
    end
  end

  # post '/detail/:id' - 作品情報の編集
  #--------------------------------------------------------------------
  post '/detail/:id' do
    id = params[:id]
    manga = Manga.new(id)
    if params[:submit] == '更新'
      manga.set_info(params[:origin] , params[:name] , params[:author])
      page = params[:page] || 0
      redirect "/detail/#{id}?page=#{page}"
    elsif params[:submit].match(/^いいね！/)
      manga.add_good
      redirect "/detail/#{id}"
    end
  end
end
