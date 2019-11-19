# Setup Instructions

1. bundle install
2. yarn install --check-files
3. rake db:create
4. rake db:migrate
5. rake db:seed
6. export STRIPE_API_KEY=# YOUR STRIPE API TEST KEY
7. rails s
8. Open http://localhost:3000 in a web browser
