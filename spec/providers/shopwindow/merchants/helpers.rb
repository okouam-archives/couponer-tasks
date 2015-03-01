def find_merchant_deals(name)
  deal_counter = 0
  error_counter = 0
  provider = Couponer::Providers::ShopWindow.new
  provider.on(:started) do |watcher, merchant_name|
    puts ">> Starting Shop Window for " + merchant_name + "."
  end
  provider.on(:ended) do |watcher, merchant_name|
    puts ">> Completed Shop Window for " + merchant_name + " with " + deal_counter.to_s + " deals."
  end
  provider.on(:deals_found) do |watcher, deal_count, merchant_name|
    puts ">> " + deal_count.to_s + " deals found for " + merchant_name + "."
  end
  provider.on(:error) do |watcher, label, id , ex|
    raise ex 
  end
  provider.on(:deal_processed) do |watcher|
    deal_counter = deal_counter + 1
    print "."
    $stdout.flush
  end
  provider.find_deals(name)
end