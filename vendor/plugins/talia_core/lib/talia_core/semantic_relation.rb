module TaliaCore
  class SemanticRelation < ActiveRecord::Base
    belongs_to :subject, :class_name => 'ActiveSource'
    belongs_to :object, :polymorphic => true
  end
end
