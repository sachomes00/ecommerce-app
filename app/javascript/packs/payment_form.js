// Replace with your Stripe API key
const stripe = Stripe(process.env.STRIPE_API_PUBLISHABLE_KEY);

const elements = stripe.elements();
const form = document.getElementById('payment-form');
const email = document.getElementById('email').getAttribute('value');
const clientSecret = document.getElementById('client-secret').getAttribute('data-attribute')

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
card.mount("#card-element");

form.addEventListener('submit', async (event) => {
  event.preventDefault();

  console.log('card =>', card)
  stripe.confirmCardPayment(
    clientSecret,
    {
      payment_method: {card: card}
    }
  ).then(function(result) {
    if (result.error) {
      // Display error.message in your UI.
      console.log('Error: ', result.error)
    } else {
      // The payment has succeeded
      // Display a success message
      stripePaymentIntentHandler(result.paymentIntent)
    }
  });

  stripe.createPaymentMethod({
    type: 'card',
    card: card,
    billing_details: {
      email: email,
    },
  }).then(function(result) {
    console.log('result payment =>', result)
    stripePaymentMethodHandler(result.paymentMethod)
  });
});

const stripePaymentIntentHandler = (paymentIntent) => {
  const form = document.getElementById('payment-form');
  console.log('paymentIntent =>', paymentIntent)

  const paymentIntentInput = document.createElement('input');

  paymentIntentInput.setAttribute('type', 'hidden');
  paymentIntentInput.setAttribute('name', 'paymentIntentId');
  paymentIntentInput.setAttribute('value', paymentIntent.id);

  form.appendChild(paymentIntentInput);
}

const stripePaymentMethodHandler = (paymentMethod) => {
  const form = document.getElementById('payment-form');

  const paymentMethodInput = document.createElement('input');

  paymentMethodInput.setAttribute('type', 'hidden');
  paymentMethodInput.setAttribute('name', 'paymentMethod');
  paymentMethodInput.setAttribute('value', paymentMethod.id);

  form.appendChild(paymentMethodInput);

  form.submit()
}
