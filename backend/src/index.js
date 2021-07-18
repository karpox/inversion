const app = require('./app')
require('./database');

async function init(){
    await app.listen(8000);
    console.log('Server on Localhost:8000')
}

init();