desc "Run govuk-lint with similar params to CI"
task "lint" do
  unless ENV["JENKINS"]
    sh "bundle exec govuk-lint-ruby --parallel --format clang app spec lib"
  end
end
