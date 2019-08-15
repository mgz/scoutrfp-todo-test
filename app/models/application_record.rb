class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def self.find_or_create_by_threadsafe!(opts)
    retry_count = 0
    begin
      return find_or_create_by!(opts)
    rescue ActiveRecord::RecordNotUnique
      retry_count += 1
      retry if retry_count < 2
    end
  end
end
