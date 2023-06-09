import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/main_provider.dart';
import 'screens/add_screen.dart';

void main() async {
  // load .env file
  await dotenv.load(fileName: 'assets/env');
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ListProvider()),
        ],
        child: const MaterialApp(
          title: 'Todo List',
          debugShowCheckedModeBanner: false,
          home: MyApp(),
        )),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // get list provider
    final listProvider = Provider.of<ListProvider>(context);
    return FutureBuilder(
        future: listProvider.getData(),
        builder: (context, snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('Todo List'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddPage(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => setState(() {}),
                  ),
                ],
              ),
              body: Center(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  width: 600,
                  child: ListView.builder(
                    // separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) => Container(
                      decoration: const BoxDecoration(border: Border(top: BorderSide())),
                      child: ListTile(
                        // give style to list tile
                        // shape: RoundedRectangleBorder(
                        //   side: const BorderSide(width: 2, color: Colors.amberAccent),
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        leading: Checkbox(
                          value: listProvider.list[index]['status'],
                          onChanged: (value) => listProvider.updateStatus(listProvider.list[index]['id'], status: !listProvider.list[index]['status']),
                        ),
                        title: Text(
                          listProvider.list[index]['name'],
                          style: TextStyle(decoration: listProvider.list[index]['status'] ? TextDecoration.lineThrough : TextDecoration.none),
                        ),
                        subtitle: Text(listProvider.list[index]['description']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => listProvider.removeFromList(listProvider.list[index]['id']),
                        ),
                      ),
                    ),
                    itemCount: listProvider.list.length,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
