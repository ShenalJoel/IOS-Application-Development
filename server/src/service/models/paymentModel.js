const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const paymentSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  orderId: {
    type: Schema.Types.ObjectId,
    ref: 'Order',
    required: true,
  },
  amount: { type: Number, required: true },
  paymentMethod: { type: Number, required: true },
});

const Payment = mongoose.model('Payment', paymentSchema);

module.exports = Payment;
