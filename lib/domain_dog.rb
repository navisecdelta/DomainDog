class DomainDog

    def initialize()
        @agent = Mechanize.new()
        @provider = "https://viewdns.info/reversewhois/?q="
    end

    def reverse_whois(query)
        res = @agent.get("#{@provider}#{query}").body()
        table = Nokogiri::HTML(res).css("table")[2]

        domains = []

        table.css("table").css("tr").each do |tr|
            if tr.css("td")[0] != nil
                res = tr.css("td")[0].text

                if res != "Domain Name"
                    domains.push(res)
                end
            end
        end

        return domains
    end
end