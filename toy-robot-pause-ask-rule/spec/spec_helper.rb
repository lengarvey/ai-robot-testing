RSpec.configure do |config|
  # Use the expect syntax
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Use the new mock syntax
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output
    config.default_formatter = "doc"
  end

  # Run specs in random order to surface order dependencies
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  Kernel.srand config.seed

  # Allow filtering by focus
  config.filter_run_when_matching :focus

  # Disable monkey patching
  config.disable_monkey_patching!
end