// Replace with your Stripe API key
const stripe = Stripe(process.env.STRIPE_API_PUBLISHABLE_KEY);

const elements = stripe.elements();
const form = document.getElementById('payment-form');
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

  // const {token, error} = await stripe.createToken(card);
  //
  // if (error) {
  //   const errorElement = document.getElementById('card-errors');
  //   errorElement.textContent = error.message;
  //   console.log("Stripe error: ", error.message)
  // } else {
  //   stripeTokenHandler(token);
  // }
});

const stripePaymentIntentHandler = (paymentIntent) => {
  const form = document.getElementById('payment-form');
  console.log('paymentIntent =>', paymentIntent)

  const paymentIntentInput = document.createElement('input');
  const paymentMethodInput = document.createElement('input');

  paymentIntentInput.setAttribute('type', 'hidden');
  paymentIntentInput.setAttribute('name', 'paymentIntentId');
  paymentIntentInput.setAttribute('value', paymentIntent.id);

  paymentMethodInput.setAttribute('type', 'hidden');
  paymentMethodInput.setAttribute('name', 'paymentMethod');
  paymentMethodInput.setAttribute('value', paymentIntent.payment_method);

  form.appendChild(paymentIntentInput);
  form.appendChild(paymentMethodInput);

  form.submit();
}
