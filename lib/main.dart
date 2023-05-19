import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/provider_page.dart';

import 'db_helper/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'To Do List'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionupdateController = TextEditingController();
  TextEditingController titleupdateController = TextEditingController();

  List<String>? titlelist = [];
  late AppProvider appProvider;
  List<Map<String, dynamic>>? tododata;
  @override
  void initState() {
    appProvider = Provider.of<AppProvider>(context, listen: false);
    getfulldata();
    print(titlelist);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appProvider = context.watch<AppProvider>();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      actions: [
                        Container(
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    hintText: "Title",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                TextFormField(
                                  controller: descriptionController,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    hintText: "Description",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel")),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await DataBaseHelper.instance
                                              .insertrecord(
                                            {
                                              DataBaseHelper.columntitle:
                                                  titleController.text,
                                              DataBaseHelper.columnDescription:
                                                  descriptionController.text,
                                            },
                                          );
                                          var dbquery = await DataBaseHelper
                                              .instance
                                              .queryDatabase();
                                          print(dbquery);
                                          titleController.clear();
                                          descriptionController.clear();
                                          Navigator.pop(context);
                                          tododata?.clear();
                                          getfulldata();
                                          appProvider.refresh();
                                        },
                                        child: Text("Save")),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ));
          },
          child: Text("Add"),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Center(
                child: Text(
              "Here the Task List",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            )),
            Expanded(
              child: ListView.builder(
                itemCount: tododata?.length,
                itemBuilder: (context, index) => SizedBox(
                  height: 60,
                  child: InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (context) => 
                        AlertDialog(
                          actions: [
                            Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Title - ${tododata?[index]["title"]}",style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12
                                    )),
                                    Wrap(children:[ Text("Description - ${tododata?[index]["description"]}"
                                    ,style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange
                                      ),)])
                                  ,ElevatedButton(onPressed: (){
                                    Navigator.pop(context);
                                    }, child: Text("Ok"))
                                  ],

                                ),
                              ),
                            )
                          ],
                        ),);
                    },
                    child: Card(
                      color: Colors.greenAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.work_history_outlined),
                          SizedBox(
                            width: 30,
                          ),
                          Text(tododata?[index]["title"] ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(
                            width: 130,
                          ),
                          IconButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(actions: [
                                          Container(
                                              height: 300,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              titleupdateController,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: "Title",
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30)),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              descriptionupdateController,
                                                          maxLines: 5,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Description",
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30)),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    "Cancel")),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                await DataBaseHelper
                                                                    .instance
                                                                    .update({
                                                                  DataBaseHelper
                                                                          .columnid:
                                                                      index + 1,
                                                                  DataBaseHelper
                                                                          .columntitle:
                                                                      titleupdateController
                                                                          .text,
                                                                  DataBaseHelper
                                                                          .columnDescription:
                                                                      descriptionupdateController
                                                                          .text,
                                                                });
                                                                titleupdateController
                                                                    .clear();
                                                                descriptionupdateController
                                                                    .clear();
                                                                tododata?.clear();
                                                                getfulldata();
                                                                appProvider
                                                                    .refresh();

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text("Save"),
                                                            )
                                                          ],
                                                        )
                                                      ])))
                                        ]));
                              },
                              icon: Icon(Icons.update,color: Colors.blue,)),
                          IconButton(
                              onPressed: () async {
                                await DataBaseHelper.instance
                                    .deleterecord(index + 1);
                                tododata?.clear();
                                getfulldata();
                                appProvider.refresh();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Task Deleted Successfully"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Okay"))
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(Icons.delete,color: Colors.red,)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  // loadtitle() async {
  //   var dbquery = await DataBaseHelper.instance.queryDatabase();
  //   dbquery.forEach((element) {
  //     titlelist?.add(element["title"]);
  //   });
  //   appProvider.refresh();
  // }

  getfulldata() async {
    var res = await DataBaseHelper.instance.queryDatabase();
      tododata = res.toList();
    appProvider.refresh();
    print(">>>>>>>>>>>>this is full list>>>${tododata}");
   // print("${tododata?[0]["title"]}");
  }
}
