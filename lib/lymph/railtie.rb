module Lymph

  class Railtie < ::Rails::Railtie
    rake_tasks do
      load('lymph/tasks/lymph_tasks.rake')
    end
  end

end
