// Define an interface to specify the structure of a person
interface Person {
    firstName: string;
    lastName: string;
  }
  
  // A function that takes a Person object and returns a greeting
  function greet(person: Person): string {
    return `Hello, ${person.firstName} ${person.lastName}!`;
  }
  
  // Create a person object that conforms to the Person interface
  const user: Person = { firstName: "Alice", lastName: "Smith" };
  
  // Log the greeting to the console
  console.log(greet(user));
  
  // --- A bit more advanced example using classes ---
  
  // Define a class to represent an Animal
  class Animal {
    name: string;
  
    constructor(name: string) {
      this.name = name;
    }
  
    move(distance: number = 0): void {
      console.log(`${this.name} moved ${distance}m.`);
    }
  }
  
  // Extend the Animal class to create a Dog class
  class Dog extends Animal {
    bark(): void {
      console.log("Woof! Woof!");
    }
  }
  
  const myDog = new Dog("Buddy");
  myDog.bark();
  myDog.move(10);
  