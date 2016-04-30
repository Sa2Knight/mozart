require 'pp'
require 'yaml'
require 'date'
require 'json'

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

  # read_all - 全データを取得
  def self.read_all
    YAML.load_file(@@DB)
  end

  # read_data - データを取得
  def self.read_data(key)
    data = YAML.load_file(@@DB)
    if data[key]
      data[key]
    else
      Util.write_data(key , Util.empty)
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

  # to_json - RubyオブジェクトをJSONに変換する
  #---------------------------------------------------------------------
  def self.to_json(data)
    data.kind_of?(Hash) or data.kind_of?(Array) or return ""
    JSON.generate(data)
  end

  # 初期状態のハッシュを生成
  def self.empty
    {
      :origin => '',
      :name => '',
      :author => '',
      :lastview => '',
      :good => []
    }
  end

end
