import 'package:flutter/material.dart';
import 'package:mobile_application_development_cw1b/screens/categorised_news_screen.dart';

class CategoryScreen extends StatelessWidget {
  final List<String> categories = [
    'Business',
    'Political',
    'Crime',
    'Ideas',
    'Sports',
    'Cinema'
  ];

  final List<IconData> categoryIcons = [
    Icons.business,
    Icons.account_balance,
    Icons.policy,
    Icons.lightbulb_outline,
    Icons.sports_soccer,
    Icons.movie,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Categories'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategoryCard(
              category: categories[index],
              icon: categoryIcons[index],
            );
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;
  final IconData icon;

  const CategoryCard({Key? key, required this.category, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategorisedNewsScreen(category: category),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
