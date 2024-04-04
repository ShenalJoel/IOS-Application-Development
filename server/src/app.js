require('dotenv').config();
const express = require('express');
const app = express();
const {
  authenticateToken,
} = require('./service/controllers/middleware/auth-controller.js');

app.use(express.json());

const categoriesRoute = require('./api/routes/categories.routes.js');
const productsRoute = require('./api/routes/products.routes.js');
const cartsRoute = require('./api/routes/carts.routes.js');
const ordersoute = require('./api/routes/orders.routes.js');
const paymentsRoute = require('./api/routes/payments.routes.js');
const usersRoute = require('./api/routes/users.routes.js');
const loginRoute = require('./api/routes/token.routes.js');
const cartItemRoute = require('./api/routes/cartItem.routes.js');

app.use('/api/categories', categoriesRoute);
app.use('/api/products', productsRoute);
app.use('/api/carts', cartsRoute);
app.use('/api/orders', ordersoute);
app.use('/api/payments', paymentsRoute);
app.use('/api/users', usersRoute);
app.use('/api/login', loginRoute);
app.use('/api/cartItems', cartItemRoute);

module.exports = app;
