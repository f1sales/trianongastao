require "trianongastao/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"
# require "f1sales_custom/hooks"
require "f1sales_helpers"

module Trianongastao
  class Error < StandardError; end
  # class F1SalesCustom::Hooks::Lead
  #
  #   class << self
  #
  #     def switch_source(lead)
  #
  #       if lead.source.name.downcase.include?('webmotors') && !lead.source.name.downcase.include?('pendentes')
  #
  #         if lead.product.name.downcase.include?('peugeot')
  #           lead.source.name + source[:webmotors_peugeot]
  #
  #         elsif lead.product.name.downcase.include?('citroën')
  #           lead.source.name + source[:webmotors_citroen]
  #         else
  #           lead.source.name
  #         end
  #       else
  #         lead.source.name
  #       end
  #     end
  #
  #     def source
  #       {
  #         webmotors_peugeot: ' - Peugeot',
  #         webmotors_citroen: ' - Citroen'
  #       }
  #     end
  #   end
  # end
  #
  class F1SalesCustom::Email::Source 
    def self.all
      [
        {
          email_id: 'websitegastao',
          name: 'Website - Gastão - Citroen'
        },
        {
          email_id: 'websitegastao',
          name: 'Website - Gastão - Pegeout'
        },
        {
          email_id: 'websitegastao',
          name: 'Website - Gastão - PCD'
        },
        {
          email_id: 'websitegastao',
          name: 'Website - Gastão - Utilitários'
        },
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash(/(Telefone|Origem|Nome|E-mail|Site|Mensagem|Link da Land).*?:/, false)

      all_sources = F1SalesCustom::Email::Source.all
      destinatary = @email.to.map { |email| email[:email].split('@').first } 
      source = all_sources[0] 

      if destinatary.include?('websitegastao')
        source = all_sources[1] if (parsed_email['link_da_land'] || parsed_email['origem'] || parsed_email['site']).downcase.include?('peugeot')
        source = all_sources[1] if (parsed_email['site'] || '').downcase.include?('peugeot')
        source = all_sources[2] if @email.subject.downcase.include?('pcd')
        source = all_sources[3] if (parsed_email['link_da_land'] || parsed_email['origem'] || '').downcase.include?('utilitarios')
      else
        source = nil
      end

      {
        source: {
          name: source[:name],
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: (parsed_email['interesse'] || ''),
        message: (parsed_email['menssage'] || parsed_email['mensagem']).gsub('-', ' ').gsub("\n", ' ').strip,
        description: parsed_email['assunto'],
      }
    end
  end
end
