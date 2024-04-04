const Product = require('../models/productModel');
// const jwt = require('jsonwebtoken');
require('dotenv').config();

let items = [
  { id: 1, name: 'MetricsData 1' },
  { id: 2, name: 'MetricsData 2' },
];

// async function create(req, res) {
//   const newitem = req.body;
//   // const accessToken = jwt.sign(newitem, process.env.ACCESS_TOKEN_SECRET);
//   // // items.push(newitem);
//   // res.send(accessToken);
// }

async function create(req, res) {
  try {
    const newProduct = await Product.create(req.body);
    res.status(201).json(newProduct);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error._message });
  }
}

async function get(req, res) {
  try {
    const products = await Product.find({});
    res.status(201).json(products);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function getbyid(req, res) {
  const id = req.params.id;
  try {
    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.status(200).json(product);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function remove(req, res) {
  const id = req.params.id;
  try {
    const product = await Product.findByIdAndDelete(id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.status(200).json({ message: 'Product deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function update(req, res) {
  const id = req.params.id;
  const updatedProductData = req.body;

  try {
    const product = await Product.findByIdAndUpdate(id, updatedProductData, {
      new: true,
    });
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.status(200).json(product);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function getbycatid(req, res) {
  try {
    const id = req.params.id;
    const items = await Product.find({ categoryID: id }).exec();

    if (items.length > 0) {
      res.status(200).json(items);
    } else {
      res.status(404).send('Items not found');
    }
  } catch (error) {
    console.error('Error finding items by category ID:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

module.exports = {
  get: get,
  getbyid: getbyid,
  create: create,
  remove: remove,
  update: update,
  getbycatid: getbycatid,
};
