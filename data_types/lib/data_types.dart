import 'dart:ffi';
import 'dart:io';

void main(){
  List<String> fruits = ['Apple', 'Banana', 'Cherry'];
  Map<String, int> scores = {'Alice': 90, 'Bob': 85, 'Charlie': 95};
  String? nullableString = null;

  print('Fruits: $fruits');
  print('Score of Alice: ${scores['Alice']}');
  print('Nullable String: $nullableString');

  const double pi = 3.14;
  final DateTime currentTime = DateTime.now();
  print('Pi: $pi');
  print('Current Time: $currentTime');

  greet('Gamage');

  Person person = Person('Bob',24);
  person.displayInfo();
}

void greet(String name2){
  print('Hello $name2');
}


class Person{
  
  String name;
  int age;

  Person(this.name, this.age);

  void displayInfo(){
    print('Name : $name | Age : $age');
  }
}