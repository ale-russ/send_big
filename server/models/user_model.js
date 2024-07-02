var mongoose = require("mongoose");
bcrypt = require("bcryptjs");
Schema = mongoose.Schema;

var UserSchema = new Schema({
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
  files: [
    {
      filename: String,
      originalname: String,
      path: String,
      size: Number,
      mimetype: String,
      encoding: String,
      createdAt: { type: Date, default: Date.now },
      updatedAt: { type: Date, default: Date.now },
      uploadedAt: { type: Date, default: Date.now },
    },
  ],
});

UserSchema.methods.comparePassword = function (userPassword) {
  return bcrypt.compareSync(userPassword, this.password);
};

const User = mongoose.model("users", UserSchema);

module.exports = User;
