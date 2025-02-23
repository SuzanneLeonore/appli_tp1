import 'package:appli_tp1/Type_donnee/oeuvre.dart';
import 'package:appli_tp1/bdd_Init.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage>createState() =>_HomePageState();
}

class _HomePageState extends State<HomePage>{

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _addTaskButton(context),
      body: function(),
    );
  }

  Widget _addTaskButton(BuildContext context){
    return FloatingActionButton(
      onPressed: (){
        showDialog(
          context : context, 
          builder: (_) => AlertDialog(
            title : const Text('Add Task'),
            content : Column(

              children: [TextField(),],
            ),
          ),
        );
      },
      child : const Icon(
        Icons.add,
      ),
    );
  }

  Widget function(){
    return FutureBuilder(
      future: _databaseHelper.getOeuvres(), 
      builder: (context, snapshot){
        return ListView.builder(
          itemCount : snapshot.data?.length ?? 0,
          itemBuilder: (context, index){
            Oeuvre oeuvre = snapshot.data![index];
            return ListTile(
              title : Text(
                oeuvre.description,
              ),
              trailing: Checkbox(value: false, onChanged: (value) {}
              ),
            );
          },
        );
      },
    );
  }
}