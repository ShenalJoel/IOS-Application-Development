const Category = require('../models/categoryModel');

async function create(req, res) {
  try {
    const category = await Category.create(req.body);
    res.status(201).json(category);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function get(req, res) {
  try {
    const categories = await Category.find({});
    res.status(201).json(categories);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function getbyid(req, res) {
  const id = req.params.id;
  try {
    const category = await Category.findById(id);
    if (!category) {
      return res.status(404).json({ message: 'Category not found' });
    }
    res.status(200).json(category);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function remove(req, res) {
  const id = req.params.id;
  try {
    const category = await Category.findByIdAndDelete(id);
    if (!category) {
      return res.status(404).json({ message: 'Category not found' });
    }
    res.status(200).json({ message: 'Category deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function update(req, res) {
  const id = req.params.id;
  const updatedCategoryData = req.body;

  try {
    const category = await Category.findByIdAndUpdate(id, updatedCategoryData, {
      new: true,
    });
    if (!category) {
      return res.status(404).json({ message: 'Category not found' });
    }
    res.status(200).json(category);
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
