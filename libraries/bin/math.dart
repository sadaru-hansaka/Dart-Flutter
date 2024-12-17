
import 'dart:math';
void main(){
  // The dart:math library provides mathematical functions and constants.
  double angle = pi / 4;
  double sine = sin(angle);
  double cosine = cos(angle);
  Random random = Random();
  int randomNumber = random.nextInt(100);

  print("Uses od dart math library\n");
  print('Sine: $sine');
  print('Cosine: $cosine');
  print('Random Number: $randomNumber');
}