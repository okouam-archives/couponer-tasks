class Geographies

  @logger = Logger.new(STDOUT)
  @terms = {}
  @term_taxonomies = {}

  def self.create_from_merchant_url(post, link, name)
    case name
      when 'Groupon'
        identify(link[31..-1], post)
      when 'KGB'
        identify(link[26..-1], post)
      when 'Living Social'
        identify('national/', post)
      when 'Mighty Deals'
        identify(link[35..-1], post)
      when 'Wowcher'
        identify(link[31..-1], post)
      else
        raise "Unknown merchant #{name}"
    end
  end

  def self.identify(fragment, post)
    length = fragment.index('/') - 1
    create(post, fragment[0..length])
  end

  def self.create(post, geography)
    if @terms.has_key?(geography)
      term_id = @terms[geography].term_id
      taxonomy = @term_taxonomies[term_id]
    else
      term = WPDB::Term.find(:name => geography)
      if term
        taxonomy = WPDB::TermTaxonomy.find(:term_id => term.term_id, :taxonomy => 'geography')
      else
        term = WPDB::Term.create(:name => geography) unless term
        taxonomy = WPDB::TermTaxonomy.create(:term_id => term.term_id, :taxonomy => 'geography')
      end
      cache(term, taxonomy, geography)
    end
    post.add_termtaxonomy(taxonomy)
    post.save
  end

  def self.cache(term, taxonomy, geography)
    @terms[geography] = term
    @term_taxonomies[term.term_id] = taxonomy
  end

end

