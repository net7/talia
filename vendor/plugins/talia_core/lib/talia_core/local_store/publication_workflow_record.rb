require File.join('talia_core','local_store', 'workflow_record')


module TaliaCore

  class PublicationWorkflowRecord < WorkflowRecord

    acts_as_state_machine :initial => :submitted, :initial_properties => {:vote => 0}, :column => 'state', :properties => 'arguments'
    
    state :submitted
    state :accepted
    state :rejected
    state :published
    
    event :vote, :require_role => :reviewer do
      transitions :from => :submitted, :to => :submitted, 
        :guard => :is_submittable?,
        :on_transition => :vote
      transitions :from => :submitted, :to => :accepted,
        :guard => :is_acceptable?,
        :on_transition => :vote
      transitions :from => :submitted, :to => :rejected,
        :guard => :is_rejectable?,
        :on_transition => :vote
    end
    
    event :direct_publish, :require_role => :admin do
      transitions :from => :submitted, :to => :published
    end
    
    event :publish, :require_role => :editor do
      transitions :from => :accepted, :to => :published
    end
    
    private
    
    # vote method is called by transition
    # 
    # Syntax example:
    # record.vote!(my_user, 10)
    def vote(value)
      args = self.state_properties
      args[:vote] += value[0]
      self.state_properties=args
    end
    
    def is_submittable?(value)
      vote = self.state_properties[:vote] + value[0]
      (vote >= 0) && (vote <= 5)
    end
    
    def is_acceptable?(value)
      (self.state_properties[:vote] + value[0]) > 5
    end
    
    def is_rejectable?(value)
      (self.state_properties[:vote] + value[0]) < 0
    end
    
  end

end