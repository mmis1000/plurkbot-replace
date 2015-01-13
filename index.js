require('coffee-script/register');

var config = require('./config.json');
require('./lib/plurkbot.coffee')(config)