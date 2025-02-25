import 'package:flutter/material.dart';

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;

  const Person({
    required this.name,
    required this.age,
    required this.emoji,
  });
}

const people = [
  Person(name: "John", age: 20, emoji: "🙋🏿"),
  Person(name: "Jane", age: 25, emoji: "🙋🏽"),
  Person(name: "Jack", age: 30, emoji: "🙋🏼"),
];

class ExampleHeroAnimations extends StatefulWidget {
  const ExampleHeroAnimations({super.key});

  @override
  State<ExampleHeroAnimations> createState() => _ExampleHeroAnimationsState();
}

class _ExampleHeroAnimationsState extends State<ExampleHeroAnimations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("People"),
        ),
        elevation: 5,
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          final person = people[index];
          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DetailsPage(person: person);
                  },
                ),
              );
            },
            leading: Hero(
              tag: person.name,
              child: Text(
                person.emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            title: Text(person.name),
            subtitle: Text(
              "${person.age} years old",
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        },
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    super.key,
    required this.person,
  });

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: person.name,
          flightShuttleBuilder: (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) {
            switch (flightDirection) {
              case HeroFlightDirection.push:
                return Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                    scale: animation.drive(
                      Tween<double>(
                        begin: 0,
                        end: 1,
                      ).chain(
                        CurveTween(
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                    ),
                    child: toHeroContext.widget,
                  ),
                );
              case HeroFlightDirection.pop:
                return Material(
                  color: Colors.transparent,
                  child: fromHeroContext.widget,
                );
            }
          },
          child: Center(
            child: Text(
              person.emoji,
              style: const TextStyle(
                fontSize: 40,
              ),
            ),
          ),
        ),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              person.name,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              "${person.age} years old",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
