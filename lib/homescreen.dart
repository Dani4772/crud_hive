import 'package:crud_hive/person.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box<Person>? personBox;
  final _idEditingController = TextEditingController();
  final _nameEditingController = TextEditingController();
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();

  @override
  void initState() {
    openBox();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    personBox?.close();
  }

  openBox() async {
    personBox = await Hive.openBox<Person>('user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Crud'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Center(
                  child: ListView.builder(
                      itemBuilder: (BuildContext context, i) {
                        final _personData = personBox?.values.toList()[i];
                        return Card(
                          child: ListTile(
                            title: Text(_personData!.name,style: const TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Column(
                              children: [
                                Text(_personData.id),
                                Text(_personData.email),
                                Text(_personData.password),
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  personBox?.delete(_personData.key);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete)),
                            leading: IconButton(
                                onPressed: () {
                                  _idEditingController.text = _personData.id;
                                  _nameEditingController.text=_personData.name;
                                  _passwordEditingController.text=_personData.password;
                                  _emailEditingController.text=_personData.email;
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return Dialog(
                                          child: SizedBox(
                                            height: 400,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller:
                                                        _idEditingController,
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text('id'),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller:
                                                        _nameEditingController,
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text('name'),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller:
                                                        _emailEditingController,
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text('email'),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller:
                                                        _passwordEditingController,
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text('password'),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                      onPressed: () async {
                                                        _personData.email =
                                                            _emailEditingController
                                                                .text;
                                                        _personData.password=_passwordEditingController.text;
                                                        _personData.name=_nameEditingController.text;
                                                        _personData.id=_idEditingController.text;
                                                        await _personData.save();
                                                        Navigator.pop(context);

                                                        _idEditingController
                                                            .clear();
                                                        _nameEditingController
                                                            .clear();
                                                        _emailEditingController
                                                            .clear();
                                                        _passwordEditingController
                                                            .clear();
                                                        setState(() {});
                                                      },
                                                      child:
                                                          const Text('submit')),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                  setState(() {});
                                },
                                icon: const Icon(Icons.edit)),
                          ),
                        );
                      },
                      itemCount: personBox?.values.length ?? 0))),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (_) {
                return Dialog(
                  child: SizedBox(
                    height: 400,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _idEditingController,
                            decoration: const InputDecoration(
                              label: Text('id'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _nameEditingController,
                            decoration: const InputDecoration(
                              label: Text('name'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _emailEditingController,
                            decoration: const InputDecoration(
                              label: Text('email'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _passwordEditingController,
                            decoration: const InputDecoration(
                              label: Text('password'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                final model = Person(
                                    id: _idEditingController.text,
                                    name: _nameEditingController.text,
                                    email: _emailEditingController.text,
                                    password:
                                    _passwordEditingController.text);
                                await personBox?.add(model);
                                await model.save();
                                Navigator.pop(context);
                                _idEditingController.clear();
                                _passwordEditingController.clear();
                                _nameEditingController.clear();
                                _emailEditingController.clear();
                                setState(() {});
                              },
                              child: Text('submit')),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
