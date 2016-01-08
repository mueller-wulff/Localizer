class XclifferController < AppsController

  require 'xliffer'

  def import(file, lang, app, override, add)
    xliff = XLIFFer::XLIFF.new(file)

    puts "geöffnet"
    file = xliff.files

    file.each do |f|
      puts file.to_s
      puts "Source: "+ f.source_language.to_s
      puts "Target: "+ f.target_language.to_s

      f.strings.each do |string|
        puts "Id: #{string.id}"
        puts "Vals: #{string.source} => #{string.target}"
      end
    end

  end

end