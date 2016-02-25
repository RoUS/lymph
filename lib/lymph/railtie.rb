module Lymph

  class Railtie < ::Rails::Railtie
    rake_tasks do
      load('lymph/tasks/lymph_tasks.rake')
    end

    initializer('Lymph.configure_rails_initialization') do
      #
      # Pull in our own app-specific modules.
      #
      require('lymph/classmethods')
      Lymph.load_definitions
    end

  end

end
