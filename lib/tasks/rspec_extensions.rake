def recent_specs(touched_since)
  recent_app_specs = FileList['app/**/*.*'].map do |path|
    if File.mtime(path) > touched_since
      spec = File.join('spec', File.dirname(path).split("/")[1..-1].join('/'), "#{File.basename(path, '.rb')}_spec.rb")
      spec if File.exists?(spec)
    end
  end.compact

  recent_lib_specs = FileList['lib/**/*.*'].map do |path|
    if File.mtime(path) > touched_since
      spec = File.join('spec', 'lib', File.dirname(path).split("/")[1..-1].join('/'), "#{File.basename(path, '.rb')}_spec.rb")
      spec if File.exists?(spec)
    end
  end.compact

  recent_app_specs + recent_lib_specs + FileList['spec/**/*_spec.rb'].select do |path|
    File.mtime(path) > touched_since
  end.uniq
end


def recent_specs_by_number(number_of_specs)
  apps = FileList['app/**/*.*'].map do |path|
    spec = File.join('spec', File.dirname(path).split("/")[1..-1].join('/'), "#{File.basename(path, '.rb')}_spec.rb")
    [path, spec] if File.exists?(spec)
  end.compact

  libs = FileList['lib/**/*.*'].map do |path|
    spec = File.join('spec', 'lib', File.dirname(path).split("/")[1..-1].join('/'), "#{File.basename(path, '.rb')}_spec.rb")
    [path, spec] if File.exists?(spec)
  end.compact

  specs = FileList['spec/**/*_spec.rb'].map{|spec| [spec, spec]}

  (apps + libs + specs).sort_by do |path, spec|
    File.mtime(path)
  end.reverse.map(&:last)[0, number_of_specs]
end


namespace :spec do
  desc "Save HTML Specdoc for all specs (excluding plugin specs)"
  Spec::Rake::SpecTask.new(:html_doc) do |t|
    t.spec_opts = ['--format html:doc/rspec_report.html']#, '--dry-run', #,'--backtrace']
    t.spec_files = FileList['spec/**/*/*_spec.rb']
  end

  # based http://nullcreations.net/entries/general/rspec-on-rails-rake-task-for-recent-specs
  desc 'Run recent specs'
  Spec::Rake::SpecTask.new(:recent) do |t|
    t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
    t.spec_files = recent_specs(Time.now - 600) # 10 min.
  end

  namespace :recent do
    desc 'Run most recent spec'
    Spec::Rake::SpecTask.new(:last) do |t|
      t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
      t.spec_files = recent_specs_by_number(1)
    end

    desc 'Run 5 most recent specs'
    Spec::Rake::SpecTask.new('5') do |t|
      t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
      t.spec_files = recent_specs_by_number(5)
    end
  end
end