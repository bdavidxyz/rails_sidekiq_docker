mkdir "app/views/welcome"
printf "<h1 class='c-welcome'>Welcome</h1>\n<div>Find me under app/views/welcome/index.html.erb</div>\n" > app/views/welcome/index.html.erb
echo -e "added simple view under app/views/welcome/index.html.erb"

echo -e "require 'sidekiq/web'\n$(cat config/routes.rb)" > config/routes.rb
awk '/Rails.application.routes.draw do/ { print; print "  root \x27'''welcome#index'''\x27"; next }1' config/routes.rb > config/tmp && mv config/tmp config/routes.rb
awk '/Rails.application.routes.draw do/ { print; print "  get \x27'''welcome/index'''\x27, to: \x27'''welcome#index'''\x27"; next }1' config/routes.rb > config/tmp && mv config/tmp config/routes.rb
awk '/Rails.application.routes.draw do/ { print; print "  mount Sidekiq::Web => \x27'''/sidekiq'''\x27"; next }1' config/routes.rb > config/tmp && mv config/tmp config/routes.rb
echo -e "changed config/routes.rb for default and sidekiq routes"


sed -i.bak 's/check_yarn_integrity: true/check_yarn_integrity: false/g' config/webpacker.yml
echo 'changed yarn integrity to false in config/webpacker.yml'

printf "class WelcomeController < ApplicationController\n  def index\n  end\nend" > app/controllers/welcome_controller.rb
echo -e "added an empty app/controllers/welcome_controller.rb"

awk '/pool:/ { print; print "  host: db"; next }1' config/database.yml > config/tmp && mv config/tmp config/database.yml
echo -e "added host:db to config/database.yml"



