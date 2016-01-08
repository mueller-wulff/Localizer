class App < ActiveRecord::Base
  has_one :node, :dependent => :destroy
  has_many :collaborations, :dependent => :destroy
  has_many :languages, :dependent => :destroy
  belongs_to :user

  cattr_accessor :file, :lang, :override

  include ApplicationHelper

  #before_validation 'file_validation', on: :create

  #validates :node, presence: true

  validates :title, presence: true
  validates :lang, presence: true
  validates :file, presence: true


  def new_app
    self.file_validation

    if self.errors.count == 0
      puts "Errors 0"
      build_node(@encode_arr, @file, false, false)
    else
      puts "Errors: #{self.errors.messages}"
    end

  end


  def add_file_to_app(app_params)

    self.file = app_params[:file]
    self.lang = app_params[:lang]

    self.file_validation

    puts "Validation for file_add done"

    if self.errors.count == 0
      if self.file.original_filename.include?("."+self.plattform)
      else
        self.errors.add(:fileformat, I18n.t("errors.messages.wrong_fileformat"))
      end

      if self.errors.count == 0

        puts "No errors, start file_add"

        override = app_params[:override]

        if override == "0"
          override = false
          puts "override changed"
        end
        if override == "1"
          override = true
          puts "override changed"
        end

        puts override
        puts lang

        add = true
        puts "Errors 0"
        build_node(@encode_arr, @file, override, add)
      else
        puts "Errors: #{self.errors.messages}"
      end
    else
      puts "Errors: #{self.errors.messages}"
    end

  end


  def file_validation

    puts "file_validation"
    if self.file

      filename = self.file.original_filename

      if !filename.include?(".xml") &&
          !filename.include?(".xliff") &&
          !filename.include?(".yml") &&
          !filename.include?(".strings")
        self.errors.add(:fileformat, "muss '.xml', '.yml' oder '.strings' sein!")
      end

      @file = self.file.read
      @encode_arr = test_encode(@file)
      check_file_encoding(self.file, @encode_arr)
      @file.force_encoding("ASCII-8BIT")

    else
      self.errors.add(:file, I18n.t("errors.messages.choose_file"))
    end

  end


  def add_language_to_app(lang)
    if !load_languages(self).include?(lang)

      l = self.languages.build
      l.title = lang
      l.in_work = false
      l.save

    end
  end


  def test_encode(file)
    encode = file.encode.to_s

    utf_8 = false
    utf_16 = false

    if file.force_encoding("UTF-8").valid_encoding?
      encode = "UTF-8"
      utf_8 = true
    end

    if !utf_8
      if file.force_encoding("UTF-16LE").valid_encoding?
        encode = "UTF-16LE"
        utf_16 = true
      end
    end

    [utf_8, utf_16, encode]
  end

  def check_file_encoding(file, encode_arr)

    utf_8, utf_16, encode = encode_arr


    if file.original_filename.include?(".xml")
      if !utf_8
        self.errors.add(:encoding, I18n.t("errors.messages.encodings.xml"))
      end
    end

    if file.original_filename.include?(".yml")
      if !utf_8
        self.errors.add(:encoding, I18n.t("errors.messages.encodings.yml"))
      end
    end

    if file.original_filename.include?(".strings")
      if !utf_8 && !utf_16
        self.errors.add(:encoding, I18n.t("errors.messages.encodings.strings"))
      end
    end
  end


  def check_empty_nodes
    langs = load_languages(self)
    self.node.subnodes.each do |s|
      s.check_nodes(langs)
    end
  end


  private


  def build_node(encode_arr, file, override, add)
    lang = self.lang
    filename = self.file.original_filename

    utf_8, utf_16, encode = encode_arr

    if filename.include?(".xliff")
      @node = XclifferController.new.import(file.force_encoding(encode), lang, self, override, add)
      self.plattform = 'xliff'
    end

    if filename.include?(".xml")
      @node = XmlController.new.add_xml(file.force_encoding(encode), lang, self, override, add)
      self.plattform = 'xml'
    end

    if filename.include?(".yml")
      @node = YmlController.new.read_yml(file.force_encoding(encode), lang, self, override, add)
      self.plattform = 'yml'
    end

    if filename.include?(".strings")
      @node = StringController.new.read_strings(file.force_encoding(encode), lang, encode, self, override, add)
      self.plattform = 'strings'
    end

    puts "Nodeausgabe:"
    puts @node.inspect
    puts "Ende Ausgabe"
    self.node = @node

    add_language_to_app(lang)
    puts "Fertig mit Insert"
  end


end
