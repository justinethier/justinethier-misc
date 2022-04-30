
// load into node via: require('./code.js');

var num = 8614;

//iter = function(num) {
//  max = parseInt(num.toString().padStart(4, '0').split('').sort().reverse().join(''));
//  min = parseInt(num.toString().padStart(4, '0').split('').sort().join(''));
//  return max - min;
//}

validate = function(num) {
  for (i = 0; i < 10000; i += 1111) {
    if (num == i) {
      return false;
    }
  }
  return true;
}

kaprekar = function(num) {
  if (!validate(num)) {
    console.log("Invalid number " + num);
    return false;
  }
  console.log(num);
  while(num != 6174) {
    // Build 0-padded string representing number
    str = num.toString().padStart(4, '0');
    // Break digits into an array so we can arrange them into min/max number combinations
    // Array operations are in-place, so create new arrays here
    max = parseInt(str.split('').sort().reverse().join(''));
    min = parseInt(str.split('').sort().join(''));
    num = max - min;
    console.log(num);
  }
}

var n = Math.random() * 10000 | 0; // from https://stackoverflow.com/a/61696576
kaprekar(n); 
