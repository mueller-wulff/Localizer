class CollaborationsController < ApplicationController

  include ApplicationHelper
  before_action :find_coll, only: [:show, :change_nodes, :edit_list_form]
  before_action :find_coll2, only: [:create]
  before_action :app_owner_or_admin, only: [:create]

  def new

  end

  def create
    @colls = @app.collaborations

    @coll = @app.collaborations.build
    @coll.baselang = params[:collaboration][:baselang]
    @coll.title = params[:collaboration][:title]
    @coll.lang = lang_list_build(params[:collaboration][:lang])

    if @coll.save
    else
      @colls.delete(@coll)
    end

    respond_to do |format|
      format.js {}
    end
  end

  def edit

  end

  def edit_list_form
    @lang = @langs.first
  end


  def change_nodes

    current_lang = @app.languages.find_by(title: params[:current_lang])
    if params[:editable] == "true"
      current_lang.in_work = false
      current_lang.save
      puts "\n\nSprache #{current_lang.title} freigegeben.\n\n"
    else
      puts "\n\nSprache #{current_lang.title} nicht freigegeben.\n\n"
    end

    @lang = params[:lang]
    respond_to do |format|
      format.js {}
    end


  end

  def show
    @lang = @langs.first
  end

  def update

  end

  private

  def lang_list_build(langs)
    text = ""
    langs.each do |s|
      text = text + s + ";"
    end
    if text.chars.first == ";"
      text.slice!(0)
    end

    return text
  end

  def find_coll
    @coll = Collaboration.find(params[:id])
    @app = App.find(@coll.app_id)
    @node = @app.node
    @langs = @coll.lang.split(";")
  end

  def find_coll2
    @app = App.find(params[:collaboration][:app_id])
  end

end