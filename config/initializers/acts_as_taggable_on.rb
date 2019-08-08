class CommaIgnoringParser < ActsAsTaggableOn::GenericParser
  def parse
    ActsAsTaggableOn::TagList.new.tap do |tag_list|
      tag_list.add @tag_list
    end
  end
end

ActsAsTaggableOn.default_parser = CommaIgnoringParser