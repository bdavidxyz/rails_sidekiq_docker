sed -i.bak 's/check_yarn_integrity: true/check_yarn_integrity: false/g' config/webpacker.yml
echo 'changed yarn integrity to false'

printf "class WelcomeController < ApplicationController\nend" > app/controllers/welcome_controller.rb
echo -e "added an empty app/controllers/welcome_controller.rb"

mkdir "app/views/welcome"
printf "<h1 class='c-welcome'>Welcome</h1><div>Find me under app/views/welcome/index.html.erb</div>\n" > app/views/welcome/index.html.erb
echo -e "added simple view under app/views/welcome/index.html.erb"

