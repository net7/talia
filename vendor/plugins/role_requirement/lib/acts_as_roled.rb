module ActsAsRoled
  def self.included(mod)
    Role.find_all_names.each do |role|
      mod.class_eval <<-END
        def #{role}?
          has_role?('#{role}')
        end
      END
    end
  end
end