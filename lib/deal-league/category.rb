class Category

  @logger = Logger.new(STDOUT)
  @terms = {}
  @term_taxonomies = {}

  def self.create(post, category)
    if @terms.has_key?(category)
      term_id = @terms[category].term_id
      taxonomy = @term_taxonomies[term_id]
    else
      term = WPDB::Term.find(:name => category)
      if term
        taxonomy = WPDB::TermTaxonomy.find(:term_id => term.term_id, :taxonomy => 'category')
      else
        term = WPDB::Term.create(:name => category)
        taxonomy = WPDB::TermTaxonomy.create(:term_id => term.term_id, :taxonomy => 'category')
      end
      cache(term, taxonomy, category)
    end
    post.add_termtaxonomy(taxonomy)
    post.save
  end

  def self.cache(term, taxonomy, category)
    @terms[category] = term
    @term_taxonomies[term.term_id] = taxonomy
  end

end

