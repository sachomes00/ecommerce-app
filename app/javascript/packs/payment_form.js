// Replace with your Stripe API key
// const stripe = Stripe(process.env.STRIPE_API_PUBLISHABLE_KEY);
const stripe = Stripe('pk_test_CYMrYVdDzeol6VXWGHyMfRPF00j4qD6PjG');
const elements = stripe.elements();

const form = document.getElementById('payment-form');
const spinner = document.getElementById('spinner');
spinner.style.display = 'none'

const style = {
  base: {
    color: "#32325d",
    fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
    fontSmoothing: "antialiased",
    fontSize: "16px",
    "::placeholder": {
      color: "#aab7c4"
    }
  },
  invalid: {
    color: "#fa755a",
    iconColor: "#fa755a"
  }
};

const card = elements.create("card", { style: style });
const clientSecret = document.getElementById('card-submit').getAttribute('data-secret')
card.mount("#card-element");


card.addEventListener('change', function(event) {
  console.log('here')
  var displayError = document.getElementById('card-errors');
  if (event.error) {
    displayError.textContent = event.error.message;
  } else {
    displayError.textContent = '';
  }
});

var submitButton = document.getElementById('card-submit');

submitButton.addEventListener('click', function(ev) {
  stripe.confirmCardPayment(clientSecret, {
    payment_method: {card: card}
  }).then(function(result) {
    if (result.error) {
      // Show error to your customer (e.g., insufficient funds)
      console.log(result.error.message);
    } else {
      submitButton.disabled = true;
      spinner.style.display = 'inline';
      // The payment has been processed!
      if (result.paymentIntent.status === 'succeeded') {
        spinner.style.display = 'none';
        stripeTokenHandler(result.paymentIntent.id)
        // Show a success message to your customer
        // There's a risk of the customer closing the window before callback
        // execution. Set up a webhook or plugin to listen for the
        // payment_intent.succeeded event that handles any business critical
        // post-payment actions.
      }
    }
  });
});

const stripeTokenHandler = (paymentIntentId) => {
  const form = document.getElementById('payment-form');
  const hiddenInput = document.createElement('input');
  hiddenInput.setAttribute('type', 'hidden');
  hiddenInput.setAttribute('name', 'paymentIntentId');
  hiddenInput.setAttribute('value', paymentIntentId);
  form.appendChild(hiddenInput);

  form.submit();
}
