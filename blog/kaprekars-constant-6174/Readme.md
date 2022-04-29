Notes

(Just saw this in a video on TikTok)

background - Kaprekar's constant

take a 4-digit number with at least 2 different digits
subtract maximum orientation of digits and minimum orientation

EG: 

7641 - 1467

eventually this will always converge to a magic number 6174


TODO: very simple code to input two numbers and compute

var num = 8614;

max = parseInt(num.toString().split('').sort().reverse().join(''));
min = parseInt(num.toString().split('').sort().join(''));

num = max - min;
