// Replace with your Stripe API key
const stripe = Stripe('pk_test_CYMrYVdDzeol6VXWGHyMfRPF00j4qD6PjG');

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

const cardElement = elements.create("card", { style: style });
cardElement.mount("#card-element");

form.addEventListener('submit', async (event) => {
  event.preventDefault();
  const email = document.getElementById('email').getAttribute('value')

  stripe.createPaymentMethod('card', cardElement, {
    billing_details: {
      email: email,
    },
  }).then(function(result) {
    if (result.error) {
      console.log('Error creating payment method: ', result.error)
    } else {
      stripePaymentMethodHandler(result.paymentMethod.id, email)
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

// const stripeTokenHandler = (token) => {
//   const form = document.getElementById('payment-form');
//   const hiddenInput = document.createElement('input');
//   hiddenInput.setAttribute('type', 'hidden');
//   hiddenInput.setAttribute('name', 'stripeToken');
//   hiddenInput.setAttribute('value', token.id);
//   form.appendChild(hiddenInput);
//
//   form.submit();
// }


const stripePaymentMethodHandler = (paymentMethod, email) => {

  fetch('/customers', {
    method: 'post',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      email: email,
      payment_method: paymentMethod
    })
  }).then(response => {
    return response.json();
  })
  .then(customer => {
    console.log('Customer: ', customer)
    // The customer has been created
  });
}
