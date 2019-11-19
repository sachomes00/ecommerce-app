# Setup Instructions

1. bundle install
2. yarn install --check-files
3. rake db:create
4. rake db:migrate
5. rake db:seed
6. export STRIPE_API_PUBLISHABLE_KEY=# YOUR STRIPE API TEST PUBLISHABLE KEY
7. export STRIPE_API_SECRET_KEY=# YOUR STRIPE API TEST SECRET KEY
8. rails s
9. Open http://localhost:3000 in a web browser
