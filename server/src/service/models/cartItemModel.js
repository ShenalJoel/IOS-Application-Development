const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const cartItemSchema = new Schema({
  cartID: {
    type: Schema.Types.ObjectId,
    ref: 'Cart',
    required: true,
  },
  productID: {
    type: Schema.Types.ObjectId,
    ref: 'Product',
    required: true,
  },
  quantity: { type: Number, required: true },
  size: { type: String, required: true },
  color: { type: String, required: true },
});

const CartItem = mongoose.model('CartItem', cartItemSchema);

module.exports = CartItem;
