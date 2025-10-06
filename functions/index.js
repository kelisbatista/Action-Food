const functions = require("firebase-functions");
const axios = require("axios");

exports.createPixPayment = functions.https.onRequest(async (req, res) => {
  try {
    const { orderId, total, payer } = req.body;

    // Aqui você coloca o seu token de acesso do Mercado Pago
    const mpToken = "SEU_ACCESS_TOKEN";

    const response = await axios.post(
      "https://api.mercadopago.com/v1/payments",
      {
        transaction_amount: total,
        payment_method_id: "pix",
        description: `Pedido ${orderId}`,
        payer: payer
      },
      {
        headers: {
          Authorization: `Bearer ${mpToken}`,
          "Content-Type": "application/json"
        }
      }
    );

    res.json({ ok: true, mp: response.data });
  } catch (error) {
    console.error(error.response?.data || error.message);
    res.json({ ok: false, error: error.response?.data || error.message });
  }
});
