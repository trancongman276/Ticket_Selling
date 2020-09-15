import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_app/login_page_2.dart';
import 'login_page.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
@override
Widget build(BuildContext context) {
  // final wordpair = WordPair.random();
  return MaterialApp(
    theme: ThemeData(
      fontFamily: 'Nunito',

    ),
    debugShowCheckedModeBanner: false,
    title: "Welcome",
    home: loginPage2(),
    // home: Scaffold(
    //   body: RandomWords(),
    // ),
  );
}
}

class RandomWords extends StatefulWidget{
  @override
  RandomState createState() => RandomState();
}

class RandomState extends State<RandomWords>{

  final List<WordPair> suggestions = <WordPair>[];
  final TextStyle biggerFont = const TextStyle(fontSize: 18);
  final saved = Set<WordPair>();
  @override
  Widget build(BuildContext context) {

    Widget buildRow(WordPair pair) {
      final alreadySaved = saved.contains(pair);
      return ListTile(
        title: Text(pair.asPascalCase, style: biggerFont,),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved? Colors.green : null,
        ),
        onTap: (){
          setState(() =>
            alreadySaved ? saved.remove(pair) : saved.add(pair)
          );
        },
      );
    }

    Widget _buildSuggestions() {
      return ListView.builder(
          // padding: const EdgeInsets.all(16),
          itemBuilder: (BuildContext context, int i) {
            if (i.isOdd)
              return Divider();
            final int index = i ~/ 2;
            if (index >= suggestions.length) {
              suggestions.addAll(generateWordPairs().take(10));
            }
            return buildRow(suggestions[index]);
          }
      );
    }

    void pushSaved(){
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context){
            final tiles = saved.map(
                (WordPair pair){
                  return ListTile(
                    title: Text(
                      pair.asPascalCase,
                      style: biggerFont,
                    ),
                  );
                },
            );
            final divided = ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList();

            return Scaffold(
              appBar:  AppBar(
                title: Text('Saved'),
                backgroundColor: Colors.green,
              ),
              body: ListView(children: divided,)
            );
          }

        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Startup name'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: pushSaved,)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

}

