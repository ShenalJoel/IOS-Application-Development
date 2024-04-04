const jwt = require('jsonwebtoken');
require('dotenv').config();

// async function login(req, res) {
//   const username = req.body.username;
//   const password = req.body.password;
//   console.log(username);
//   console.log(password);
//   try {
//     const user = await User.findOne({
//       username: username,
//       password: password,
//     }).exec();
//     if (!user) {
//       return res.status(404).json({ message: 'User not found' });
//     }
//     const accessToken = jwt.sign(
//       user.toJSON(),
//       process.env.ACCESS_TOKEN_SECRET
//     );
//     res.status(200).json({ authtoken: accessToken });
//   } catch (error) {
//     res.status(500).json({ error: error.message });
//   }
// }

// module.exports = {
//   login: login,
// };

const User = require('../models/userModel');
const Cart = require('../models/cartModel');
const cartItemController = require('./cartItem-controller');

async function login(req, res) {
  const { username, password } = req.body;
  try {
    const user = await User.findOne({ username, password }).exec();
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Fetch the cart details for the user if available
    const cart = await Cart.findOne({ userId: user._id }).exec();
    const userData = { ...user.toJSON(), cart }; // Add cart details to user data

    res.status(200).json({ user: userData });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

module.exports = {
  login: login,
};
