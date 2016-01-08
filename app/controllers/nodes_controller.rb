class NodesController < ApplicationController
  before_action :find_node, only: [:edit]

  def edit
  end

  def update
    nodes = params[:node][:node]

    nodes.each do |node|
      thisnode = Node.find(node[0])
      puts thisnode.title.to_s + " \nzu: " + node[1][:title].to_s
      thisnode.update_attributes(:title => node[1][:title])
      @lastone1 = thisnode
      @lastone2 = thisnode
    end

    app = get_app_from_node(@lastone2)

    langu = app.languages.find_by(title: @lastone1.lang)


    langu.updated_at = Time.now
    if langu.save
      puts langu.updated_at
      puts "Alle Änderungen gespeichert"
    end

    respond_to do |format|
      format.js {}
    end
  end

  private
  def get_app_from_node(lastone)

    while lastone.app.nil? do
      lastone =  lastone.parent
      puts "Ebene rauf"
    end

    return lastone.app
  end

  def find_node
    @node = Node.find(params[:id])
  end

  def edit_node_params
    params.require(:node).permit(:title)
  end
end