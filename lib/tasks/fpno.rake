
desc 'Generate FeliCa Pocket Number'

task :fpno do
  count = ENV['number'].to_i
  count.times do
    puts SecureRandom.hex(5)
  end
end
