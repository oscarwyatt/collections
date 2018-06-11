module Organisations
  class IndexPresenter
    include OrganisationsHelper

    def initialize(organisations)
      @organisations = organisations
    end

    def title
      @organisations.content_item.title
    end

    def ministerial_departments
      {
        number_10: @organisations.number_10,
        ministerial_departments: @organisations.ministerial_departments
      }
    end

    def non_ministerial_departments
      {
        non_ministerial_departments: non_ministerial_document_list(@organisations.non_ministerial_departments),
        agencies_and_other_public_bodies: non_ministerial_document_list(@organisations.ordered_agencies_and_other_public_bodies),
        high_profile_groups: non_ministerial_document_list(@organisations.ordered_high_profile_groups),
        public_corporations: non_ministerial_document_list(@organisations.ordered_public_corporations),
        devolved_administrations: non_ministerial_document_list(@organisations.ordered_devolved_administrations)
      }
    end

    def works_with(organisation)
      if organisation["works_with"].present? && organisation["works_with"].any?
        works_with_count = child_organisations_count(organisation)
        works_with_text = "Works with #{works_with_count}"

        if works_with_count === 1
          works_with_text << " public body"
        elsif works_with_count > 1
          works_with_text << " agencies and public bodies"
        end
      end
    end

  private

    def non_ministerial_document_list(organisation_list)
      if organisation_list
        organisation_list.each.map do |organisation|
          data = {
            link: {
              text: organisation["title"],
              path: organisation["href"],
              context: (I18n.t("organisations.separate_website") if organisation["separate_website"]),
              description: works_with(organisation)
            }
          }

          data
        end
      else
        []
      end
    end
  end
end