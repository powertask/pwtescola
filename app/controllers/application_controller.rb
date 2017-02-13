class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

	I18n.locale = "pt-BR"

 private

    def index_class(klass, options = {})
      options[:order] = true if options[:order].nil?

      if params[:name].nil?
        list(klass, options)
      else
        filter_class(klass, options)
      end
    end

    def filter_class(klass, options = {})
      if params[:name].empty?
        list(klass, options)
      else
        list(klass, options).where("lower("<<klass.to_s.pluralize.downcase<<".name) like ?", params[:name].downcase << "%")
      end
    end

    def list(klass, options = {})
      if options[:type].nil?
        k = klass.where(klass.to_s.pluralize.downcase<<".unit_id = ?", current_user.unit_id).paginate(:page => params[:page], :per_page => 20)
        
        if options[:order]
          k = k.order('name ASC')
        end
        k
        
      elsif options[:type] == :id
        klass.where('id = ?', session[:unit_id])
      else
        k = klass.all.paginate(:page => params[:page], :per_page => 20)
        k = k.order('name ASC') unless options[:order]
      end
    end
end
