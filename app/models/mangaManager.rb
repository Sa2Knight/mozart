require 'pp'
require 'yaml'
require 'date'
class MangaManager

  # list - 作品の一覧を取得
  def self.list(opt = {})
    data = Util.read_all
    Dir.glob("#{Util.dir}/*").map do |path|
      thumbnail = Util.to_static(Dir.glob("#{path}/*").sort[0])
      id = path.scan(%r|^.+/(.+)$|)[0][0]
      data[id] or data[id] = Util.empty
      data[id][:id] = id
      data[id][:thumbnail] = thumbnail
    end
    return data
  end

end
