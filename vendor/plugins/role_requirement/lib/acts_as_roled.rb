module ActsAsRoled
  Role.find_all_names.each do |role|
    class_eval <<-END
      def #{role}?
        has_role?('#{role}')
      end
    END
  end
end