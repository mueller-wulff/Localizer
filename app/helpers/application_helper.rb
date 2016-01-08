module ApplicationHelper


  # loads Languages from app and returns list
  # if no list for app or list empty it will check all nodes of the app (if there are any) for they'r languages
  #     this is to avoid problems with apps from a older version
  def load_languages(app)


    #Error with output while using this, must change views before
    #@list = app.languages

    @list = []
    if app.languages.count == 0
      app.node.subnodes.each do |s|
        check_node(s)
      end
    else
      app.languages.each do |l|
        @list.push(l.title)
      end
    end
    return @list
  end


  # check that a language is in work or not
  def check_language_in_work(lang, app)
    if app.languages.find_by(title: lang)
      langu = app.languages.find_by(title: lang)
      puts langu.in_work
      if langu.in_work == true
        puts Time.now
        puts langu.updated_at.localtime
        if (Time.now - langu.updated_at) < 90.seconds
          @erg = true
        end
        return @erg
      else
        return false
      end
    else
      return true
    end
  end


  def add_lang_to_list(lang)
    unless @list.include?(lang)
      @list.push(lang)
    end
  end


  # add language to list of app
  # if no list for app or list empty it will check all nodes of the app (if there are any) for they'r languages
  #     this is to avoid problems with apps from a older version
  def check_node(s)
    if s.list
      s.subnodes.each do |ns|
        check_node(ns)
      end
    else
      s.subnodes.each do |ns|
        add_lang_to_list(ns.lang)
      end
    end
  end


  def load_collaboration_edit_path(c)
    @hostname = request.host
    if @hostname == 'localhost'
      @hostname = @hostname+':3000'
    end
    return @hostname+'/collaborations/'+c.id.to_s
  end


  def load_app_edit_path(c)
    @hostname = request.host
    if @hostname == 'localhost'
      @hostname = @hostname+':3000'
    end
    return @hostname+'/apps/'+c.id.to_s
  end


end
