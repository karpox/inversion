const {Schema, model} = require('mongoose');

const userSchema = new Schema({
    name: String,
    invmin: Number,
    invmax: Number,
    tasa: Number,
    duracion: Number,
});

module.exports = model('Plan', userSchema);