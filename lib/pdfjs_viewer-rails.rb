require "pdfjs_viewer-rails/version"
require "pdfjs_viewer-rails/helpers"

module PdfjsViewer
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :pdfjs_file_origins, :pdfjs_type_origin

    def initialize
      @pdfjs_file_origins = nil
      @pdfjs_type_origin = nil
    end
  end

  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace PdfjsViewer

      initializer 'pdfjs_viewer-rails.load_static_assets' do |app|
        app.middleware.unshift ::ActionDispatch::Static, "#{root}/public"
      end

      initializer "pdfjs_viewer-rails.view_helpers" do
        ActionView::Base.send :include, ViewHelpers
      end
    end
  end
end
