class Concept::Unit::Base

  def self.inherited(sub_klass)
    sub_klass.class_eval do

      is_a_neo_node do
        db do
          meta_info true
          validations true
        end
      end

      property :name, :text
      index :name

      validates_presence_of :name

      has_one(:creator).from(User, :created_concept_units)
      has_one(:concept).to(Concept).relationship(Concept::Unit::Relationship)
    end
  end

end
