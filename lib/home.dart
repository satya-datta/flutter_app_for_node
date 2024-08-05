import 'package:flutter/material.dart';

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark, // Set brightness to dark
        primarySwatch: Colors.grey, // Use grey as primary color
        primaryColor: Colors.black, // Set primary color to black
        scaffoldBackgroundColor:
            Colors.white, // Set scaffold background to white
        colorScheme: ColorScheme.dark(
          primary: Colors.black, // Set primary color to black
          secondary: Colors.grey[800]!, // Use dark grey as secondary color
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // Set text color to black
          bodyMedium: TextStyle(color: Colors.black), // Set text color to black
        ),
        appBarTheme: AppBarTheme(
          backgroundColor:
              Colors.black, // Set app bar background color to black
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor:
              Colors.grey[900], // Use dark grey for drawer background
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Delivery App'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning Akila!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Delivering to'),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: 'Current Location',
                  items: <String>['Current Location', 'Home', 'Work']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search food',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryCard('Offers', 'assets/offers.png'),
                  CategoryCard('Sri Lankan', 'assets/srilankan.png'),
                  CategoryCard('Italian', 'assets/italian.png'),
                  CategoryCard('Indian', 'assets/indian.png'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Restaurants',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('View all'),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  RestaurantCard(
                    name: 'Minute by tuk tuk',
                    rating: 4.9,
                    cuisine: 'Cafe',
                    imageUrl: 'assets/pizza.png',
                  ),
                  // Add more RestaurantCard widgets here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;

  CategoryCard(this.title, this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(imagePath, height: 60, width: 60),
          SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String name;
  final double rating;
  final String cuisine;
  final String imageUrl;

  RestaurantCard({
    required this.name,
    required this.rating,
    required this.cuisine,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('$rating (${124} ratings) $cuisine'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
