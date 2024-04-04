const Payment = require('../models/paymentModel');

async function create(req, res) {
  try {
    const payment = await Payment.create(req.body);
    res.status(201).json(payment);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function get(req, res) {
  try {
    const payments = await Payment.find({});
    res.status(201).json(payments);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function getbyid(req, res) {
  const id = req.params.id;
  try {
    const payment = await Payment.findById(id);
    if (!payment) {
      return res.status(404).json({ message: 'payment not found' });
    }
    res.status(200).json(payment);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function remove(req, res) {
  const id = req.params.id;
  try {
    const payment = await Payment.findByIdAndDelete(id);
    if (!payment) {
      return res.status(404).json({ message: 'payment not found' });
    }
    res.status(200).json({ message: 'payment deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function update(req, res) {
  const id = req.params.id;
  const updatedpaymentData = req.body;
  try {
    const payment = await Payment.findByIdAndUpdate(id, updatedpaymentData, {
      new: true,
    });
    if (!payment) {
      return res.status(404).json({ message: 'payment not found' });
    }
    res.status(200).json(payment);
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
