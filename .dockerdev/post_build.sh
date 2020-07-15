printf "class WelcomeController < ApplicationController\n  def index\n  end\nend" > app/controllers/welcome_controller.rb
echo -e "added an empty app/controllers/welcome_controller.rb"

mkdir "app/views/welcome"
printf "<h1 class='c-welcome'>Welcome</h1>\n<div>Find me under app/views/welcome/index.html.erb</div>\n" > app/views/welcome/index.html.erb
echo -e "added simple view under app/views/welcome/index.html.erb"


printf "Sidekiq.configure_server do |config|\n  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://redis:6379/1') }\nend\nSidekiq.configure_client do |config|\n  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://redis:6379/1') }\nend" > config/initializers/sidekiq.rb
echo -e "added an initializer for Sidekiq under config/initializers/sidekiq.rb"

awk '/Rails::Application/ { print; print "  config.active_job.queue_adapter = :sidekiq"; next }1' config/application.rb > config/tmp2 && mv config/tmp2 config/application.rb
echo -e "added config.active_job.queue_adapter = :sidekiq to config/application.rb"


echo -e "require 'sidekiq/web'\n$(cat config/routes.rb)" > config/routes.rb
awk '/Rails.application.routes.draw do/ { print; print "  root \x27'''welcome#index'''\x27"; next }1' config/routes.rb > config/tmp && mv config/tmp config/routes.rb
awk '/Rails.application.routes.draw do/ { print; print "  get \x27'''welcome/index'''\x27, to: \x27'''welcome#index'''\x27"; next }1' config/routes.rb > config/tmp && mv config/tmp config/routes.rb
awk '/Rails.application.routes.draw do/ { print; print "  mount Sidekiq::Web => \x27'''/sidekiq'''\x27"; next }1' config/routes.rb > config/tmp && mv config/tmp config/routes.rb
echo -e "changed config/routes.rb for default and sidekiq routes"


sed -i.bak 's/check_yarn_integrity: true/check_yarn_integrity: false/g' config/webpacker.yml
echo 'changed yarn integrity to false in config/webpacker.yml'


awk '/pool:/ { print; print "  host: db"; next }1' config/database.yml > config/tmp && mv config/tmp config/database.yml
awk '/pool:/ { print; print "  username: railsapp"; next }1' config/database.yml > config/tmp && mv config/tmp config/database.yml
echo -e "added host:db and username: railsapp to config/database.yml"

awk '/gem \x27'''bootsnap'''\x27/ { print; print "gem \x27'''sidekiq'''\x27"; next }1' Gemfile > config/tmp3 && mv config/tmp3 Gemfile
awk '/gem \x27'''bootsnap'''\x27/ { print; print "gem \"awesome_print\""; next }1' Gemfile > config/tmp3 && mv config/tmp3 Gemfile
echo -e "reinstalled sidekiq gem and awesome_print gem to Gemfile"


