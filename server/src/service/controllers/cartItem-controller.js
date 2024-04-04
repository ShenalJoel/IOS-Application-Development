const CartItem = require('../models/cartItemModel');

const Cart = require('../models/cartModel');

// Controller function to handle adding cart items
async function addCartItem(req, res) {
  let { userId, cartID, cartItems } = req.body;

  try {
    let cart;

    // Check if a cart exists for the user
    if (cartID) {
      // If cartID is provided, verify it belongs to the user
      cart = await Cart.findOne({ _id: cartID, userId });
      if (!cart) {
        return res.status(404).json({ message: 'Cart not found for the user' });
      }
    } else {
      // If cartID is not provided, find or create a cart for the user
      cart = await Cart.findOne({ userId });
      if (!cart) {
        cart = await Cart.create({ userId });
      }
    }

    // Remove existing cart items associated with the cart
    await CartItem.deleteMany({ cartID: cart._id });

    // Add cart items to the cart
    for (const item of cartItems) {
      await CartItem.create({
        productID: item.productId,
        quantity: item.quantity,
        cartID: cart._id,
        size: item.size,
        color: item.color,
        // Add other item properties as needed
      });
    }

    // Return success response
    res.status(200).json({ message: 'Cart items added successfully' });
  } catch (error) {
    console.error('Error adding cart items:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

async function getCartItems(req, res) {
  const userId = req.params.id; // Get userId from URL parameters

  try {
    // Find the cart associated with the user
    const cart = await Cart.findOne({ userId });

    if (!cart) {
      return res.status(404).json({ message: 'Cart not found for the user' });
    }

    // Find all cart items associated with the cart
    const cartItems = await CartItem.find({ cartID: cart._id }).populate(
      'productID'
    );

    res.status(200).json({ cartItems });
  } catch (error) {
    console.error('Error retrieving cart items:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

async function get(req, res) {
  try {
    const cartitems = await CartItem.find({});
    res.status(200).json(cartitems);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

// async function getbyid(req, res) {
//   const id = req.params.id;
//   try {
//     const cartItem = await CartItem.findById(id);
//     if (!cartItem) {
//       return res.status(404).json({ message: 'Cart Item not found' });
//     }
//     res.status(200).json(cartItem);
//   } catch (error) {
//     res.status(500).json({ error: error.message });
//   }
// }

async function remove(req, res) {
  const id = req.params.id;
  try {
    const cartitem = await CartItem.findByIdAndDelete(id);
    if (!cartitem) {
      return res.status(404).json({ message: 'Cart item not found' });
    }
    res.status(200).json({ message: 'Cart item deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function update(req, res) {
  const id = req.params.id;
  const updatedCartItemData = req.body;
  try {
    const cart = await CartItem.findByIdAndUpdate(id, updatedCartItemData, {
      new: true,
    });
    if (!cart) {
      return res.status(404).json({ message: 'Cart Item not found' });
    }
    res.status(200).json(cart);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

module.exports = {
  get: get,
  getbyid: getCartItems,
  create: addCartItem, // Renamed create function to addCartItem
  remove: remove,
  update: update,
};
