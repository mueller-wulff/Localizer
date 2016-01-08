class LanguagesController < ApplicationController


  def set_free


    app = App.find(params[:app])
    lang = app.languages.find_by(title: params[:lang])

    if params[:editable] == "true"
      lang.in_work = false
      lang.save
      puts "\n\nSprache #{params[:lang]} freigegeben durch Seite verlassen\n\n"
    else
      puts "\n\nSprache #{params[:lang]} nicht geändert durch Seite verlassen\n\n"
    end

    redirect_to request.referrer

  end

  def set_un_free

    app = App.find(params[:app])
    lang = app.languages.find_by(title: params[:lang])

    if params[:editable] == "true"
      lang.in_work = true
      puts "\n\nSprache #{params[:lang]} gesperrt durch auf Seite bleiben\n\n"
    else
      puts "\n\nSprache #{params[:lang]} nicht geändert durch auf Seite bleiben\n\n"
    end

    redirect_to request.referrer

  end

end