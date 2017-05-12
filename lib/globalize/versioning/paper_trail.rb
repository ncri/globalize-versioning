require 'paper_trail'

module Globalize
  module Versioning
    module PaperTrail
      # At present this isn't used but we may use something similar in paper trail
      # shortly, so leaving it around to reference easily.
      #def versioned_columns
        #super + self.class.translated_attribute_names
      #end
    end
  end
end

module Globalize::Versioning::PaperTrailExtensions
  def has_paper_trail(*args)
    super(*args)
    include Globalize::Versioning::PaperTrail
  end
end

ActiveRecord::Base.class_eval do
  class << self
    prepend Globalize::Versioning::PaperTrailExtensions
  end
end

# to handle different versions of paper_trail
# version_class = PaperTrail::VERSION.is_a?(String) ? Version : PaperTrail::Version


module PaperTrail::VersionExtensions
  def sibling_versions
    super.for_this_locale
  end
end


PaperTrail::Version.class_eval do
  before_save do |version|
    version.locale = Globalize.locale.to_s
  end

  def self.for_this_locale
    where :locale => Globalize.locale.to_s
  end

  prepend PaperTrail::VersionExtensions
end
