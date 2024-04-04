const Cart = require('../models/cartModel');
const cartItemController = require('./cartItem-controller');

async function create(req, res) {
  const data = req.body;
  const userid = '660041f8936a8699dbdf5ac5';
  const cartobj = {
    userId: userid,
  };
  try {
    const cart = await Cart.create(cartobj);
    const cartID = cart._id;

    res.status(201).json({ cartID: cartID });
  } catch {
    res.status(500).json({ error: error.message });
  }
}

async function get(req, res) {
  try {
    const carts = await Cart.find({});
    res.status(201).json(carts);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function getbyid(req, res) {
  const id = req.params.id;
  try {
    const cart = await Cart.findById(id);
    if (!cart) {
      return res.status(404).json({ message: 'Cart not found' });
    }
    res.status(200).json(cart);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function remove(req, res) {
  const id = req.params.id;
  try {
    const cart = await Cart.findByIdAndDelete(id);
    if (!cart) {
      return res.status(404).json({ message: 'Cart not found' });
    }
    res.status(200).json({ message: 'Cart deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function update(req, res) {
  const id = req.params.id;
  const updatedCartData = req.body;
  try {
    const cart = await Cart.findByIdAndUpdate(id, updatedCartData, {
      new: true,
    });
    if (!cart) {
      return res.status(404).json({ message: 'Cart not found' });
    }
    res.status(200).json(cart);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

module.exports = {
  get: get,
  getbyid: getbyid,
  create: create,
  remove: remove,
  update: update,
};
