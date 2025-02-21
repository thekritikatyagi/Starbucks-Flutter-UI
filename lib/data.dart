class Coffee{
  final String image;
  final int price;
  final String title;
  final String description;
  Coffee( {required this.title,required this.image, required this.price, required this.description,});
}
List<Coffee> coffeeList = [
  Coffee(
      title: "Caramel Delight Frappuccino",
      image: "assets/coffee1.png",
      price: 12,
      description: "A rich blend of caramel syrup, coffee, milk, and ice, topped with fluffy whipped cream and a smooth caramel drizzle. For a bolder twist, try it affogato-style with a hot espresso shot poured over the top."
  ),
  Coffee(
      title: "Mocha Crunch Frappuccino",
      image: "assets/coffee2.png",
      price: 14,
      description: "A satisfying mix of Frappuccino® Roast coffee, creamy mocha sauce, and crunchy chocolate chips blended with milk and ice. Layered with whipped cream, cookie crumbles, and a rich mocha drizzle for the ultimate chocolate indulgence."
  ),
  Coffee(
      title: "Java Bliss Frappuccino",
      image: "assets/coffee3.png",
      price: 11,
      description: "An irresistible fusion of mocha sauce, coffee, and Frappuccino® chips, blended with milk and ice. Topped with whipped cream and a decadent mocha drizzle, delivering a perfect balance of coffee and chocolate flavors."
  ),
  Coffee(
      title: "Strawberry Dream Frappuccino",
      image: "assets/coffee4.png",
      price: 13,
      description: "A creamy blend of ice, milk, and strawberry puree, layered over a burst of fresh strawberry flavor and finished with smooth vanilla whipped cream. A refreshing and fruity delight for any time of the day."
  ),
];
