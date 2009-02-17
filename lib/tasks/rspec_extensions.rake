namespace :spec do
  desc "Save HTML Specdoc for all specs (excluding plugin specs)"
  Spec::Rake::SpecTask.new(:html_doc) do |t|
    t.spec_opts = ['--format html:doc/rspec_report.html']#, '--dry-run', #,'--backtrace']
    t.spec_files = FileList['spec/**/*/*_spec.rb']
  end
end
