class YmlController < AppsController

  def read_yml(file1, lang, app, override, add)

    @override = override
    @app = app

    if add
      n = @app.node
    else
      n = Node.new(title: @app.title)
      n.save
    end

    items = YAML.load(file1)

    @first = true
    @file = File.open("text.txt", 'a')
    check_items(items, n, lang)
    @file.close

    return n
  end

  def check_items(i, n, lang)

    if i.is_a?(Hash)
      i.each do |key, value|
        #ns = sn_builder(key.to_s, nil, true, n)
        # Schneide ersten Node ( Sprachangabe ) weg.
        if @first
          ns = n.get_next_node(" ", true, nil, nil)
          @first = false
        else
          ns = n.get_next_node(key.to_s, true, nil, nil)
        end
        check_items(value, ns, lang)
      end
    end

    if i.is_a?(String)
      n.list = false
      n.save
      #sn_builder(i, lang, false, n)
      n.make_end_node(i, lang, @override)
    end

    if i.is_a?(Array)
      cnt = 0
      i.each do |a|
        n.listtype = "yml-array"
        n.save
        #ns = sn_builder("", nil, false, n)
        ns = n.get_next_node(cnt.to_s, false, nil, nil)
        cnt = cnt+1
        #sn_builder(a, lang, false, ns)
        ns.make_end_node(a, lang, @override)
      end
    end


  end


  def export_yml(node, lang)
    @lang = lang

    file_name = @lang+'.yml'
    @text = ""

    export_yml_node(node, 0)

    File.open(file_name, 'w+') do |f|
      f.write(@text)
    end

    return file_name
  end



  def export_yml_node(ns, ebene)
    ns.subnodes.each do |nss|
      if nss.parent.listtype == "yml-array"
        (ebene-1).times do
          @text << "  "
        end
      else
        ebene.times do
          @text << "  "
        end
      end


      if nss.list
        if ebene == 0
          @text << @lang
        else
          @text << nss.title
        end
        @text << ":\n"
        export_yml_node(nss, ebene+1)
      else

        if nss.parent.listtype == "yml-array"
        else
          @text << nss.title
        end


        if nss.parent.listtype == "yml-array"
          @text << "- "
        else
          @text << ": "
        end
        if nss.subnodes.where(lang: @lang).size > 0
          @text << "\""
          if nss.subnodes.where(:lang => @lang).first.title
            @text << nss.subnodes.where(:lang => @lang).first.title.gsub('"', "\\\"")
          end
          @text << "\""
          @text << "\n"
        end
      end
    end
  end
end