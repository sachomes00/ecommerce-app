# Setup Instructions

bundle install
yarn install --check-files
rake db:create
rake db:migrate
rake db:seed
export STRIPE_API_KEY=# YOUR STRIPE API TEST KEY
rails s
Open http://localhost:3000 in a web browser
