require 'pp'
require 'yaml'
require 'date'
class Util

  attr_reader :DIR , :DB

  @@DIR = 'app/public/mozart'
  @@DB = 'data.yml'

  # debug - 標準出力に文字列を出力
  def self.debug(data)
    puts "----------"
    pp data
    puts "----------"
  end

  # today - 本日の日付
  def self.today
    Date.today.strftime("%Y-%m-%d")
  end

  # 作品のディレクトリパス
  def self.dir
    @@DIR
  end

  # 作品情報のファイルパス
  def self.db
    @@DB
  end

  # read_data - データを取得
  def self.read_data(key)
    data = YAML.load_file(@@DB)
    if data[key]
      data[key]
    else
      Util.write_data(key , {
        :origin => '' ,
        :name => '' ,
        :author => '' ,
        :lastview => '' ,
        :viewcount => 0 ,
        :good => []
      })
      Util.read_data(key)
    end
  end

  # write_file - データを登録
  def self.write_data(key , val = nil)
    data = YAML.load_file(@@DB)
    data or data = {}
    if val
      data[key] = val
    else
      data.delete(key)
    end
    open(@@DB , "w"){|f| f.write(YAML.dump(data))}
  end

  # to_static - public以下のファイルパスをsinatraで参照できるパスに変換 
  def self.to_static(path)
    path =~ %r|^app/public(/.+)$|
    return $1
  end

  # thubnails - 作品一覧を取得
  def self.thumbnails
    Dir.glob("#{@@DIR}/*").map do |dir|
      path = Util.to_static(Dir.glob("#{dir}/*").sort[0])
      {:id => path.split('/')[-2] , :url => path}
    end
  end

end
