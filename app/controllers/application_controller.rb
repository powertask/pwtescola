class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

	I18n.locale = "pt-BR"

 private

    def index_list(klass)
      if params[:name].nil?
        list(klass)
      else
        filter(klass)
      end
    end

    def filter(klass)
      if params[:name].empty?
        list(klass)
      else
        list(klass).where("lower("<<klass.to_s.pluralize.downcase<<".name) like ?", params[:name].downcase << "%")
      end
    end

    def list(klass)
      if klass == Customer
        return klass.where(klass.to_s.pluralize.downcase<<".unit_id = ? AND id = ?", current_user.unit_id, session[:customer_id]).paginate(:page => params[:page], :per_page => 20)
      else
        return klass.where(klass.to_s.pluralize.downcase<<".unit_id = ? AND customer_id = ?", current_user.unit_id, session[:customer_id]).paginate(:page => params[:page], :per_page => 20)
      end
    end
end
