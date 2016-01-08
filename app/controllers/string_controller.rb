class StringController < AppsController

  def read_strings(file, lang, coding, app, override, add)

    @app = app

    if add
      n = @app.node
    else
      n = Node.new(title: @app.title)
      n.save
    end

    puts "Zwischennode"
    nn = n.get_next_node(" ", true, nil, nil)

    data = []

    sign1 = ("/*").force_encoding(coding)
    sign2 = ("*/").force_encoding(coding)
    sign3 = ("//").force_encoding(coding)


    file.each_line do |line|
      if !line.start_with?(sign1) && !line.include?(sign2) && !line.start_with?(sign3)
        data.push(line)
      end
    end

    data.each do |d|
      d = d.encode("UTF-8", :undev => :replace, :replace => '')

      if d.include?("=") && d.include?(";")

        puts "Start node"

        ds = string_split_keyval(d)
        puts "Create node"
        puts ds[0]
        ns = nn.get_next_node(ds[0].squish, false, nil, nil)
        #ns = n.subnodes.build(title: stringrefresh(ds[0].squish))
        puts ns.id

        puts "Create subnode"
        puts ds[1]
        nss = ns.make_end_node(ds[1].gsub(';', '').squish, lang, override)
        #nss = ns.subnodes.build(title: stringrefresh(ds[1].gsub(';', '').squish))
        #nss.lang=lang
        #nss.save

        puts nss.id
        puts "Node done"
      end
    end
    return n
  end

  def string_split_keyval(d)

    if d.start_with?('"')
      puts "Split with REGEX"
      re = /\"([^"]*)\"/
      puts "String: "
      puts d
      ds = d.scan re
      i=0
      puts "Extracted: "
      ds[0 .. ds.length].each do|m|
        puts i.to_s + ": " + m.to_s
        i=i+1
      end
      ds2 = []
      ds2[0] = ds[0][0]
      ds2[1] = ds[1][0]
      ds = ds2
    else
      ds = d.split('=');
    end

    puts "Array: "
    puts ds[0]
    puts ds[1]
    puts "End of array"

    return ds
  end


  def export_strings(node, lang)
    file_name = 'Localizable.strings'

    text = ""
    node.subnodes.first.subnodes.each do |sn|
      text << '"'
      text << string_sign_re_changer(sn.title)
      text << '"'
      text << " = "
      text << '"'
      text << string_sign_re_changer(sn.subnodes.where(:lang => lang).first.title.gsub("\n", ""))
      text << '"'
      text << ";"
      text << "\n"
    end

    File.open(file_name, 'w+') do |f|
      f.write(text)
    end

    return file_name
  end

end
