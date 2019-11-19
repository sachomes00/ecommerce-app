# README

Setup Instructions

1. bundle install
2. rake db:create
3. rake db:migrate
4. export STRIPE_API_KEY=<YOUR STRIPE API TEST KEY>
5. Add your Stripe API key to line 2 in app/javascript/packs/payment_form.js
6. rails s
7. Open http://localhost:3000 in a web browser
