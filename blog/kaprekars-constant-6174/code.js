
// load into node via: require('./code.js');

var num = 8614;

//iter = function(num) {
//  max = parseInt(num.toString().padStart(4, '0').split('').sort().reverse().join(''));
//  min = parseInt(num.toString().padStart(4, '0').split('').sort().join(''));
//  return max - min;
//}

kaprekar = function(num) {
  while(num != 6174) {
    max = parseInt(num.toString().padStart(4, '0').split('').sort().reverse().join(''));
    min = parseInt(num.toString().padStart(4, '0').split('').sort().join(''));
    num = max - min;
    console.log(num);
  }
  return num;
}

kaprekar(1);
