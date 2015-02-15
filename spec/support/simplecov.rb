SimpleCov.start do
  add_group 'api', 'api'
  add_group 'models', 'app/models'
  add_group 'policies', 'app/policies'

  add_filter 'spec'
  add_filter 'config'
  add_filter 'app/cyberbrain_app'
end
