module Organisations
  class HeaderPresenter
    attr_reader :org

    def initialize(organisation)
      @org = organisation
    end

    def breadcrumbs
      [
        {
          title: "Home",
          url: "/",
        },
        index_page_breadcrumb,
        {
          title: @org.title,
          is_current_page: true,
        },
      ]
    end

    def organisation_logo
      component_data = {}
      component_data[:name] = org.formatted_title.html_safe if org.formatted_title
      component_data[:brand] = org.brand if org.brand
      component_data[:crest] = org.crest if org.crest

      if org.organisation_image_url
        component_data[:image] = {
          url: org.organisation_image_url,
          alt_text: org.organisation_image_alt_text,
        }
      end

      component_data
    end

    def ordered_featured_links
      if org.ordered_featured_links
        links = []

        if has_services_and_information_link?
          see_more_link = {
            text: "All #{org.acronym} services and information",
            path: "/government/organisations/#{org.slug}/services-information",
          }
        end

        org.ordered_featured_links.each do |link|
          links << {
            text: link["title"],
            path: link["href"],
          }
        end

        {
          small: org.is_news_organisation?,
          brand: org.brand,
          items: links,
          see_more_link: see_more_link,
        }
      end
    end

    def logo_wrapper_class
      return "govuk-grid-column-two-thirds" if org.is_news_organisation?

      "govuk-grid-column-one-third"
    end

    def link_wrapper_class
      return "govuk-grid-column-one-third" if org.is_news_organisation?

      "govuk-grid-column-two-thirds"
    end

    def translation_links
      if org.translations.present? && org.translations.count > 1
        links = []
        org.translations.each do |link|
          active = true if link["base_path"] == org.base_path

          links << {
            locale: link["locale"],
            base_path: link["base_path"],
            text: I18n.t("shared.language_names.#{link['locale']}"),
            active: active,
          }
        end

        {
          brand: org.brand,
          no_margin_top: true,
          translations: links.sort_by { |t| t[:locale] == I18n.default_locale.to_s ? "" : t[:locale] },
        }
      end
    end

  private

    def index_page_breadcrumb
      if org.is_court_or_hmcts_tribunal?
        {
          title: "Courts and Tribunals",
          url: "/courts-tribunals",
        }
      else
        {
          title: "Organisations",
          url: "/government/organisations",
        }
      end
    end

    def has_services_and_information_link?
      orgs_with_services_and_information_link = %w{
        department-for-education
        department-for-environment-food-rural-affairs
        driver-and-vehicle-standards-agency
        environment-agency
        high-speed-two-limited
        highways-england
        hm-revenue-customs
        marine-management-organisation
        maritime-and-coastguard-agency
        medicines-and-healthcare-products-regulatory-agency
        natural-england
        planning-inspectorate
      }
      return true if orgs_with_services_and_information_link.include?(org.slug)
    end
  end
end
