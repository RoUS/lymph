# desc "Explaining what the task does"
# task :lymph do
#   # Task goes here
# end
namespace(:lymph) do
  desc('Produce DOT graph of model relationships')
  task(:graph) do
    require('lymph/graph')
    Lymph.graph!
  end                           # task(:graph)

  desc('Delete models and reset to empty definitions file')
  task(:reset) do
    Lymph.load_definitions
    models	= Lymph.definitions['models'].keys
    models.each do |model|
      puts('%12s  model %s' % [ 'deleting', model ])
      Dir[File.join(Rails.root, 'app', 'models', "#{model}.rb")].each do |f|
        File.unlink(f) if (File.exists?(f))
      end
      Dir[File.join(Rails.root, 'test', 'models', "test_#{model}.rb")].each do |f|
        File.unlink(f) if (File.exists?(f))
      end
    end
    system('bundle exec rails generate lymph:config --force')
  end                           # task(:reset)

end                             # namespace(:lymph)

