var mongoose = require("mongoose");
bcrypt = require("bcryptjs");
Schema = mongoose.Schema;

var UserSchema = new Schema({
  userName: {
    type: String,
  },
  email: {
    type: String,
    trim: true,
    required: true,
    unique: true,
    lowerCase: true,
  },
  password: {
    type: String,
    required: true,
  },
});

UserSchema.methods.comparePassword = function (userPassword) {
  return bcrypt.compareSync(userPassword, this.password);
};

const User = mongoose.model("users", UserSchema);

module.exports = User;
