require 'pp'
require 'yaml'

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
      Manga.write_data(key , {:origin => '' , :name => '' , :author => ''})
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

end
