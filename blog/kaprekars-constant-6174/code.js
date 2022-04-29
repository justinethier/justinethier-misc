
// load into node via: require('./code.js');

var num = 8614;

iter = function(num) {
  max = parseInt(num.toString().split('').sort().reverse().join(''));
  min = parseInt(num.toString().split('').sort().join(''));
  return max - min;
}

kaprekar = function(num) {
  while(num != 6174) {
    num = iter(num);
    console.log(num);
  }
}

