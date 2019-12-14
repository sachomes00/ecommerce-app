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

const card = elements.create("card", { style: style });
card.mount("#card-element");

var successMessage = document.getElementById('card-save-success')
successMessage.style.display = "none"

const cardholderName = document.getElementById('cardholder-name')
const cardButton = document.getElementById('card-button')
const clientSecret = cardButton.dataset.secret

cardButton.addEventListener('click', function(ev) {
  ev.preventDefault();
  stripe.confirmCardSetup(
    clientSecret,
    {
      payment_method: {
        card: card,
        billing_details: {name: cardholderName.value}
      }
    }
  ).then(function(result) {
    if (result.error) {

    } else {
      successMessage.style.display = "block"
      paymentMethodHandler(result.setupIntent.payment_method)
    }
  })
})



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

const paymentMethodHandler = (paymentMethod) => {
  var myData = {
    paymentMethod: paymentMethod,
  }

  $.ajax({
    type: 'POST',
    url: '/cards',
    data: myData,
    success: function(data, textStatus, jqXHR){},
    error: function(jqXHR, textStatus, errorThrown){}
  })
}
