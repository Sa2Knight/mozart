require 'pp'

class Manga
 
  DIR = 'app/public/mozart'

  def self.debug(data)
    puts "----------"
    pp data
    puts "----------"
  end

  def self.to_static(path)
    path =~ %r|^app/public(/.+)$|
    return $1
  end

  def self.thumbnails
    Dir.glob("#{DIR}/*").map do |dir|
      path = Manga.to_static(Dir.glob("#{dir}/*").sort[0])
      {:id => path.split('/')[-2] , :url => path}
    end
  end

  def self.pagelist(id)
    Dir.glob("#{DIR}/#{id}/*").sort.map {|p| Manga.to_static(p)}
  end

  def self.page(id , number)
    pagelist = Manga.pagelist(id)
    number = pagelist.size - 1 if number >= pagelist.size
    pagelist[number]
  end

end
