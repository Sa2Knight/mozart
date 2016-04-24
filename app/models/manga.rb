require 'pp'
require_relative 'util.rb'
class Manga

  # 作品IDでオブジェクトを生成
  def initialize(id)
    @id = id
    @data = Util.read_data(id)
  end

  # 元ネタ
  def origin
    @data[:origin] || ''
  end

  # 作品名
  def name
    @data[:name] || ''
  end

  # 作者名
  def author
    @data[:author] || ''
  end

  # 作品情報を設定
  def set_info(origin , name , author)
    @data[:origin] = origin
    @data[:name] = name
    @data[:author] = author
    self.save_info
  end

  # 作品情報を上書き
  def save_info
    Util.write_data(@id , @data)
  end

  # いいね！(隠語)の数
  def good_count
    @data[:good] ? @data[:good].length : 0
  end

  # いいね！(隠語) を追加
  def add_good
    @data.has_key?(:good) or @data[:good] = []
    today = Util.today
    unless @data[:good].include? today
      @data[:good].push today
      self.save_info
    end
    return @data[:good].length
  end

  # ページリスト
  def page_list
    Dir.glob("#{Util.dir}/#{@id}/*").sort.map {|p| Util.to_static(p)}
  end

  # ページを取得
  def page(number)
    pagelist = self.page_list
    number < pagelist.size or return
    pagelist[number]
  end

  # ページ数
  def page_count
    self.page_list.size
  end

  # アクセス数更新
  def view_count
    today = Util.today
    if @data[:lastview] && @data[:lastview] == today
      return @data[:viewcount]
    else
     @data[:lastview] = today
     @data[:viewcount] or @data[:viewcount] = 0
     @data[:viewcount] += 1
      self.save_info
      return @data[:viewcount]
    end
  end



end
