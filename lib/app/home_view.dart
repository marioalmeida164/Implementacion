import 'package:flutter/material.dart';
import 'package:flutter_almeida/app/camara_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String> _urls = List();

  @override
  void initState() {
    setState(() {
      _urls.add('https://images.unsplash.com/photo-1547721064-da6cfb341d50');
      _urls.add(
          "https://images.unsplash.com/photo-1605051268785-c9199f2d2103?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1875&q=80");
      _urls.add(
          "https://images.unsplash.com/photo-1603456219129-811cd0bd776e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Service'),
      ),
      body: SafeArea(
        child: _urls.isEmpty
            ? Container(
                child: Center(
                  child: Text('Loading'),
                ),
              )
            : Container(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _urls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(_urls[index]))),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CamaraView()));
        },
      ),
    );
  }
}
