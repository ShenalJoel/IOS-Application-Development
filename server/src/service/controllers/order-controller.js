const Order = require('../models/orderModel');

async function create(req, res) {
  try {
    const order = await Order.create(req.body);
    res.status(201).json(order);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function get(req, res) {
  try {
    const orders = await Order.find({});
    res.status(201).json(orders);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function getbyid(req, res) {
  const id = req.params.id;
  try {
    const order = await Order.findById(id);
    if (!order) {
      return res.status(404).json({ message: 'order not found' });
    }
    res.status(200).json(order);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function remove(req, res) {
  const id = req.params.id;
  try {
    const order = await Order.findByIdAndDelete(id);
    if (!order) {
      return res.status(404).json({ message: 'order not found' });
    }
    res.status(200).json({ message: 'order deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function update(req, res) {
  const id = req.params.id;
  const updatedorderData = req.body;
  try {
    const order = await Order.findByIdAndUpdate(id, updatedorderData, {
      new: true,
    });
    if (!order) {
      return res.status(404).json({ message: 'order not found' });
    }
    res.status(200).json(order);
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
