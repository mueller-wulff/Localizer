class XmlController < AppsController

  def add_xml(file, lang, app, override, add)
    @app = app

    if add
      n = @app.node
    else
      n = Node.new(title: @app.title)
      n.save
    end

    nn = n.get_next_node(" ", true, nil, nil)
    nn.save

    doc = Nokogiri::XML(file)

    stringsxml = doc.xpath("//string")
    stringsxml.each do |s|
      ns = nn.get_next_node(s.attr('name'), false, nil, nil)
      ns.make_end_node(s.text, lang, override)
    end

    stringsarrayxml = doc.xpath("//string-array")
    stringsarrayxml.each do |s|
      ns = nn.get_next_node(s.attr('name'), true, 'string-array', nil)
      strings = s.xpath("./item")
      i = 0
      strings.each do |d|
        nss = ns.get_next_node(d.attr('name'), false, nil, i)
        nss.make_end_node(d.text, lang, override)
        i = i+1
      end
    end

    plurals = doc.xpath("//plurals")

    plurals.each do |s|
      ns = nn.get_next_node(s.attr('name'), true, 'plurals', nil)
      strings = s.xpath("./item")
      strings.each do |d|
        nss = ns.get_next_node(d.attr('quantity'), false, nil, nil)
        nss.make_end_node(d.text, lang, override)
      end
    end

    return n
  end


  def export_xml(node, lang)

    @node = node
    @lang = lang

    @file_name = 'strings.xml'

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.resources {
        @node.subnodes.first.subnodes.each do |s|
          if s.list
            if s.listtype == 'string-array'
              xml.stringarray('name' => string_sign_re_changer(s.title)) {
                s.subnodes.each do |ns|
                  if ns.subnodes.where(lang: @lang).size > 0
                    xml.item string_sign_re_changer(ns.subnodes.where(lang: @lang).first.title)
                  end
                end
              }
            else
              xml.plurals('name' => string_sign_re_changer(s.title)) {
                s.subnodes.each do |ns|
                  if ns.subnodes.where(lang: @lang).size > 0
                    xml.quantity('name' => string_sign_re_changer(ns.title)) {
                      xml << string_sign_re_changer(ns.subnodes.where(lang: @lang).first.title)
                    }
                  end
                end
              }
            end
          else
            xml.string('name' => string_sign_re_changer(s.title)) {
              if s.subnodes.where(lang: @lang).size > 0
                xml << string_sign_re_changer(s.subnodes.where(lang: @lang).first.title)
              end
            }
          end
        end
      }
    end

    text = builder.to_xml
    text = text.gsub("stringarray", "string-array")

    File.open(@file_name, 'w+') do |f|
      f.write(text)
    end

    return @file_name

  end


end