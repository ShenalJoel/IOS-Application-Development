const mongoose = require('mongoose');

const mongoURI =
  'mongodb+srv://shenaljoel:a1234@assignments.atv2o7d.mongodb.net/iosassignment?retryWrites=true&w=majority&appName=assignments';

const options = {
  //   useNewUrlParser: true,
  //   useUnifiedTopology: true,
  //   useCreateIndex: true,
  //   useFindAndModify: false,
};

mongoose
  .connect(mongoURI, options)
  .then(() => console.log('Connected to MongoDB'))
  .catch((err) => console.error('Error connecting to MongoDB:', err));

module.exports = mongoose;
