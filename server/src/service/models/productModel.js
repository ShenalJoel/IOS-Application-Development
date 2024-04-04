const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const productSchema = new Schema({
  categoryID: {
    type: Schema.Types.ObjectId,
    ref: 'Category',
    required: true,
  },
  name: { type: String, required: true },
  image: { type: String, required: true },
  prize: { type: String, required: true },
  availability: { type: Number, default: 1 },
  size: { type: String, required: false },
  color: { type: String, required: false },
});

const Product = mongoose.model('Product', productSchema);

module.exports = Product;
