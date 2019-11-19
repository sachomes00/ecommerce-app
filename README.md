# Setup Instructions

bundle install
rake db:create
rake db:migrate
export STRIPE_API_KEY=# YOUR STRIPE API TEST KEY
rails s
Open http://localhost:3000 in a web browser
