# desc "Explaining what the task does"
# task :lymph do
#   # Task goes here
# end
namespace(:lymph) do
  desc('Produce DOT graph of model relationships')
  task(:graph) do
  end
end

desc('Foo!')
task(:derp) do
  puts('Derp!')
end
