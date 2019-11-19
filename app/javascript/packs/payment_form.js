// Replace with your Stripe API key
const stripe = Stripe(process.env.STRIPE_API_PUBLISHABLE_KEY);

const elements = stripe.elements();

const form = document.getElementById('payment-form');

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

  const {token, error} = await stripe.createToken(card);

  if (error) {
    const errorElement = document.getElementById('card-errors');
    errorElement.textContent = error.message;
    console.log("Stripe error: ", error.message)
  } else {
    stripeTokenHandler(token);
  }
});

const stripeTokenHandler = (token) => {
  const form = document.getElementById('payment-form');
  const hiddenInput = document.createElement('input');
  hiddenInput.setAttribute('type', 'hidden');
  hiddenInput.setAttribute('name', 'stripeToken');
  hiddenInput.setAttribute('value', token.id);
  form.appendChild(hiddenInput);

  form.submit();
}
