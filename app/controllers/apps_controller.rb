class AppsController < ApplicationController

  require 'yaml'
  include ApplicationHelper
  before_action :find_app, only: [:show, :update, :change_nodes, :add_language, :export_file,
                                  :edit, :destroy, :add_additional_file]
  before_action :logged_in_user
  before_action :admin_user, only: [:index]
  before_action :app_owner_or_admin, only: [:show, :update, :change_nodes, :add_language, :export_file,
                                            :edit, :destroy, :add_additional_file]


  def new
    @app = App.new
  end


  def destroy
    @app.node.delete
    @app.delete
    redirect_to request.referrer
  end


  def create
    @app = current_user.apps.build(app_params)
    @app.node = nil

    @app.new_app

    if @app.save
      redirect_to app_path(@app.id)
    else
      #@app.errors.add(:unknown, I18n.t("errors.messages.unknown_error"))
      render 'new'
    end


  end


  def update

  end

  def edit
    @langs =load_languages(@app)
    @nodes = @app.node.subnodes
    if @lang.nil?
      @lang = @langs.first
    end
  end


  def show
    @node = @app.node
    if @lang.nil?
      @lang = load_languages(@app).first
    end

    @coll = Collaboration.new
    @app_id = @app.id
    @colls = @app.collaborations
  end


  # this is to set the flag "in_work" for the language which is currently in work by a user
  # if you don't set the flag, more than one user can edit the language an destroy each other work
  # to provide this problem, it' planed, to provide collaborational work, where changes automaticly are displayed at all workers
  def change_nodes

    current_lang = @app.languages.find_by(title: params[:current_lang])
    if params[:editable] == "true"
      current_lang.in_work = false
      current_lang.save
      puts "\n\nSprache #{current_lang.title} freigegeben.\n\n"
    else
      puts "\n\nSprache #{current_lang.title} nicht freigegeben.\n\n"
    end

    @langs = load_languages(@app)
    @lang = params[:lang]
    respond_to do |format|
      format.js {}
    end
  end


  # adds a new language without a file
  def add_language

    @lang = params[:lang]
    fehler = false

    if load_languages(@app).include?(@lang)
      @app.errors.add(:language, " '"+@lang+"' "+I18n.t("errors.messages.taken"))
      fehler = true
    end

    if @lang == ""
      @app.errors.add(:language, I18n.t("errors.messages.empty_text"))
      fehler = true
    end

    if fehler == false
      @node.add_new_language(@lang)

      @app.add_language_to_app(@lang)
    end

    respond_to do |format|
      format.js {}
    end
  end


  # adds an additional file
  def add_additional_file

    if remotipart_submitted?
      puts "Korrekt hochgeladen"
    else
      puts "Fehler"
    end


    @app.add_file_to_app(app_params)


    @app.check_empty_nodes
    @coll = Collaboration.new

    respond_to do |format|
      format.js {}
    end

  end


  def export_file

    @lang = params[:lang]
    puts "Start"
    puts @lang
    puts "End"

    #hier die Methode wählen
    if @app.plattform == 'xml'
      excon = XmlController.new
      file_name = excon.export_xml(@node, @lang)
    end

    if @app.plattform == 'strings'
      excon = StringController.new
      file_name = excon.export_strings(@node, @lang)
    end

    if @app.plattform == 'yml'
      excon = YmlController.new
      file_name = excon.export_yml(@node, @lang)
    end

    send_file file_name

  end


  private



  def string_sign_re_changer(string)

    # \n herausnehmen
    string = string.gsub("\n", '\n')
    # \t herausnehmen
    string = string.gsub("\t", '\t')
    # \r herausnehmen
    string = string.gsub("\r", '\r')

    return string
  end


  def app_params
    params.require(:app).permit(:title, :file, :lang, :override)
  end



  def find_app
    @app = App.find(params[:id])
    @node = @app.node
    @coll = Collaboration.new
  end




end