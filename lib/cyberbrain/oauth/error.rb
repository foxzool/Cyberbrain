module Cyberbrain
  module OAuth
    class Error < Struct.new(:name, :state)
      def description
        I18n.translate name, scope: [:cyberbrain, :errors, :messages]
      end
    end
  end
end
