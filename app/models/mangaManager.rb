require 'pp'
require 'yaml'
require 'date'
class MangaManager

  # list - 作品の一覧を取得
  def self.list(opt = {})
    # 全ての作品を取得
    data = Util.read_all
    Dir.glob("#{Util.dir}/*").map do |path|
      thumbnail = Util.to_static(Dir.glob("#{path}/*").sort[0])
      id = path.scan(%r|^.+/(.+)$|)[0][0]
      data[id] or data[id] = Util.empty
      data[id][:id] = id
      data[id][:thumbnail] = thumbnail
    end

    # 元ネタ、作品名、作者名で絞込
    [:origin , :author , :name].each do |key|
      if opt[key]
        data = data.select {|k , v| v[key] =~ /#{opt[key]}/}
      end
    end

    return data
  end

end
