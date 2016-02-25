desc('Convert markdown files to HTML')
task(:markdown) do
  Dir['*.md'].each do |mdname|
    muname	= mdname.sub(%r!\.md$!, '.html')
    $stdout.print("Converting #{File.basename(mdname)}:")
    system("rdiscount < \"#{mdname}\" > \"#{muname}\"")
    $stdout.puts(' done.')
  end
end
