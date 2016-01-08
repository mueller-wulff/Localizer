class Node < ActiveRecord::Base
  has_many :subnodes, class_name: "Node",
           foreign_key: "parent_id",
           :dependent => :destroy
  belongs_to :parent, class_name: "Node",
             :dependent => :destroy

  belongs_to :app, class_name: "App",
             :dependent => :destroy
  accepts_nested_attributes_for :subnodes


  def add_new_language(lang)
    self.subnodes.each do |nss|
      if nss.list
        nss.add_new_language(lang)
      else
        x = nss.subnodes.build(lang: lang, title: '')
        x.save
      end
    end
  end


  def check_langs(langs)
    langs.each do |lang|
      if self.subnodes.where(lang: lang).size > 0
      else
        self.make_end_node("", lang, false)
      end
    end
  end

  def check_nodes(langs)
    if self.list
      self.subnodes.each do |ns|
        ns.check_nodes(langs)
      end
    else
      self.check_langs(langs)
    end
  end

  def make_end_node(title, lang, override)

    if self.subnodes.where(lang: lang).first
      ns = self.subnodes.where(lang: lang).first
      if override
        ns.title = stringrefresh(title)
        puts "refreshed"
      else
        puts "belassen"
      end
    else
      ns = self.subnodes.build(title: stringrefresh(title), lang: lang)
      puts "new"
    end
    ns.save
    return ns
  end

  def get_next_node(newtitle, list, listtype, i)


    newtitle = stringrefresh(newtitle)
    puts "Serch for: #{newtitle}"

    if i.nil?
      if self.subnodes.where(title: newtitle).first
        ns = self.subnodes.where(title: newtitle).first
      else
        ns = self.subnodes.build(title: newtitle, listtype: listtype, list: list)
        ns.save
      end
    else
      if self.subnodes.where(title: newtitle)[i]
        ns = self.subnodes.where(title: newtitle)[i]
      else
        ns = self.subnodes.build(title: newtitle, listtype: listtype, list: list)
        ns.save
      end
    end

    return ns
  end


  private

  def stringrefresh(string)

    puts string
    if string.nil?
    else
      if string.is_a?(Symbol)
      else
        # Anführungszeichen entfernen
        if string.chars.first == "\""
          string.slice!(0)
        end
        len = string.length-1
        if string.chars.last == "\""
          string.slice!(len)
        end
        string = string_sign_changer(string)
      end


    end
    return string
  end

  def string_sign_changer(string)


    # \n herausnehmen
    string = string.gsub('\n', "\n")
    # \t herausnehmen
    string = string.gsub('\t', "\t")
    # \r herausnehmen
    string = string.gsub('\r', "\r")

    return string
  end




end
