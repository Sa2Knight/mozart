require 'pp'
require 'yaml'
require 'date'
class Manga
 
  DIR = 'app/public/mozart'
  DB = 'data.yml'

  # debug - 標準出力に文字列を出力
  def self.debug(data)
    puts "----------"
    pp data
    puts "----------"
  end

  # read_data - データを取得
  def self.read_data(key)
    data = YAML.load_file(DB)
    if data[key]
      data[key]
    else
      Manga.write_data(key , {
        :origin => '' ,
        :name => '' ,
        :author => '' ,
        :lastview => '' ,
        :viewcount => 0 ,
        :good => []
      })
      Manga.read_data(key)
    end
  end

  # write_file - データを登録
  def self.write_data(key , val = nil)
    data = YAML.load_file(DB)
    data or data = {}
    if val
      data[key] = val
    else
      data.delete(key)
    end
    open(DB , "w"){|f| f.write(YAML.dump(data))}
  end

  # to_static - public以下のファイルパスをsinatraで参照できるパスに変換 
  def self.to_static(path)
    path =~ %r|^app/public(/.+)$|
    return $1
  end

  # thubnails - 作品一覧を取得
  def self.thumbnails
    Dir.glob("#{DIR}/*").map do |dir|
      path = Manga.to_static(Dir.glob("#{dir}/*").sort[0])
      {:id => path.split('/')[-2] , :url => path}
    end
  end

  # view_count - 対象作品へのアクセス回数(１日１回)
  def self.view_count(id)
    info = Manga.read_data(id)
    today = Date.today.strftime("%Y-%m-%d")
    if info[:lastview] && info[:lastview] == today
      return info[:viewcount]
    else
      info[:lastview] = today
      info[:viewcount] or info[:viewcount] = 0 #いずれ不要に
      info[:viewcount] += 1
      Manga.write_data(id , info)
      return info[:viewcount]
    end
  end

  # page_count - 対象作品のページ数を取得
  def self.page_count(id)
    Dir.glob("#{DIR}/#{id}/*").size
  end

  # pagelist - 対象作品のページリストを取得
  def self.pagelist(id)
    Dir.glob("#{DIR}/#{id}/*").sort.map {|p| Manga.to_static(p)}
  end

  # page - 対象作品の指定したページを取得
  def self.page(id , number)
    pagelist = Manga.pagelist(id)
    number < pagelist.size or return
    pagelist[number]
  end

  # add - 大賞作品にいいね！(隠語)を追加する
  def self.add_good(id)
    data = Manga.read_data(id)
    data.has_key?(:good) or data[:good] = []
    good_history = data[:good]
    today = Date.today.strftime("%Y-%m-%d")
    if good_history.include?(today)
      return false
    else
      good_history.push today
      Manga.write_data(id , data)
    end
    return good_history.length
  end

end
