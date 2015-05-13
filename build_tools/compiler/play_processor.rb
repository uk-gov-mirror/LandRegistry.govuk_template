require 'erb'
require 'compiler/template_processor'

module Compiler
  class PlayProcessor < TemplateProcessor

    @@yield_hash = {
      layout: "<!-- Page content goes here -->",
      html_lang: "@htmlLang.getOrElse(\"en\")",
      page_title: "@title.getOrElse(\"GOV.UK - The best place to find government services and information\")",
      top_of_page: "@(title: Option[String], bodyClasses: Option[String], htmlLang: Option[String] = None)(head:Html, bodyStart:Html, bodyEnd:Html, insideHeader:Html, afterHeader:Html, footerTop:Html, footerLinks:Html, headerClass:Html = Html.empty, propositionHeader:Html = Html.empty)(content:Html)",
      head: "@head",
      body_classes: "@bodyClasses.getOrElse(\"\")",
      header_class: "@headerClass",
      propositional_header: "@propositionHeader",
      content: "@content",
      body_start: "@bodyStart",
      body_end: "@bodyEnd",
      inside_header: "@insideHeader",
      after_header: "@afterHeader",
      footer_top: "@footerTop",
      footer_support_links: "@footerLinks",
    }

    def render_erb
      f=File.read(@file)
      f.gsub!(/@-ms-viewport/, "@@-ms-viewport") unless @is_stylesheet
      ERB.new(f).result(binding)
    end

    def handle_yield(section = :layout)
      @@yield_hash[section]
    end

    def asset_path(file, options={})
      return file if @is_stylesheet
      case File.extname(file)
      when '.css'
        "@routes.Template.at(\"stylesheets/#{file}\")"
      when '.js'
        "@routes.Template.at(\"javascripts/#{file}\")"
      else
        "@routes.Template.at(\"images/#{file}\")"
      end
    end

    def content_for?(*args)
      @@yield_hash.has_key?(args[0])
    end
  end
end
