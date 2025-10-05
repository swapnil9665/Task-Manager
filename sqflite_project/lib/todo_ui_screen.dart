import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_project/todo_model.dart';
import 'package:sqflite_project/database.dart';

class TodoUiScrren extends StatefulWidget {
  const TodoUiScrren({super.key});

  @override
  State<TodoUiScrren> createState() => _TodoUiScrrenState();
}

class _TodoUiScrrenState extends State<TodoUiScrren> {
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  List<TodoModel> todoCardList = [];

  List<Color> colorList = [
    Color.fromRGBO(250, 231, 231, 1),
    Color.fromRGBO(250, 231, 231, 1),
    Color.fromRGBO(250, 231, 231, 1),
    Color.fromRGBO(250, 231, 231, 1),
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<Map> cardList = await TodoDatabase().getTodoItems();
    log("card list.$cardList");
    for (var element in cardList) {
      todoCardList.add(
        TodoModel(
          date: element['date'],
          description: element['description'],
          title: element['title'],
          id: element['id'],
        ),
      );
    }
    setState(() {});
  }

  void clearController() {
    titleController.clear();
    dateController.clear();
    descriptionController.clear();
  }

  void submit(bool doEdit, [TodoModel? obj]) {
    if (titleController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      if (doEdit) {
        obj!.title = titleController.text;
        obj.description = descriptionController.text;
        obj.date = dateController.text;

        Map<String, dynamic> dataMap = {
          'title': obj.title,
          'description': obj.description,
          'date': obj.date,
          'id': obj.id,
        };

        TodoDatabase().updateTodoItem(dataMap);
      } else {
        todoCardList.add(
          TodoModel(
            date: dateController.text,
            description: descriptionController.text,
            title: titleController.text,
          ),
        );

        Map<String, dynamic> dataobj = {
          'title': dateController.text,
          'description': descriptionController.text,
          'date': dateController.text,
          'id': 0,
        };
        TodoDatabase().insertTodoItem(dataobj);
      }

      clearController();
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  showBottomsheet(bool doEdit, [TodoModel? obj]) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add ToDo Task"),
              SizedBox(height: 10),
              Text(
                "title",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  hintText: "enter title",
                ),
              ),
              SizedBox(height: 10),

              Text(
                "description",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  hintText: "enter description",
                ),
              ),
              SizedBox(height: 10),

              Text(
                "date",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2026),
                  );
                  String strDate = DateFormat.yMMMMd().format(pickedDate!);
                  dateController.text = strDate;
                },
                controller: dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  hintText: "enter date",
                  suffixIcon: Icon(Icons.calendar_month),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  submit(doEdit);
                },
                child: Text("Submit", style: TextStyle(fontSize: 30)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo with SQFlite"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: colorList[index % colorList.length],
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network("", fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(todoCardList[index].title),
                            Text(todoCardList[index].description),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(todoCardList[index].date),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          titleController.text = todoCardList[index].title;
                          descriptionController.text =
                              todoCardList[index].description;
                          dateController.text = todoCardList[index].date;
                          showBottomsheet(true, todoCardList[index]);
                        },
                        child: Icon(
                          Icons.edit,
                          color: Color.fromRGBO(2, 167, 177, 1),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          int id = todoCardList[index].id;
                          todoCardList.removeAt(id);
                          setState(() {});
                        },
                        child: Icon(
                          Icons.delete,
                          color: Color.fromRGBO(2, 167, 177, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          itemCount: todoCardList.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomsheet(false);
        },
        backgroundColor: Color.fromRGBO(2, 167, 177, 1),
        child: Text("add"),
      ),
    );
  }
}
