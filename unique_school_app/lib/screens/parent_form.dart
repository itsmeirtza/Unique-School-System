import 'package:flutter/material.dart';

class ParentForm extends StatefulWidget {
  @override
  _ParentFormState createState() => _ParentFormState();
}

class _ParentFormState extends State<ParentForm> {
  final _formKey = GlobalKey<FormState>();
  String name='', email='', phone='';
  List<Map<String,String>> children = [];

  void addChild() {
    setState(()=> children.add({'name':'','fatherName':'','class':''}));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Parent Registration')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(decoration: InputDecoration(labelText:'Parent Name'), onChanged:(v)=>name=v),
            TextFormField(decoration: InputDecoration(labelText:'Email'), onChanged:(v)=>email=v),
            TextFormField(decoration: InputDecoration(labelText:'Phone'), onChanged:(v)=>phone=v),
            SizedBox(height:12),
            Text('Children', style: TextStyle(fontWeight: FontWeight.bold)),
            ...children.asMap().entries.map((e){
              int idx = e.key;
              return Card(
                margin: EdgeInsets.symmetric(vertical:6),
                child: Padding(padding: EdgeInsets.all(8), child: Column(children:[
                  TextFormField(decoration: InputDecoration(labelText: 'Child Name'), onChanged:(v)=>children[idx]['name']=v),
                  TextFormField(decoration: InputDecoration(labelText: 'Father Name'), onChanged:(v)=>children[idx]['fatherName']=v),
                  TextFormField(decoration: InputDecoration(labelText: 'Class (e.g. Prep, 1)'), onChanged:(v)=>children[idx]['class']=v),
                ])),
              );
            }),
            ElevatedButton.icon(onPressed: addChild, icon: Icon(Icons.add), label: Text('Add Child')),
            SizedBox(height:12),
            ElevatedButton(onPressed: (){
              // TODO: Save to Firestore -> users + students
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved locally (stub).')));
              Navigator.pushReplacementNamed(context, '/dashboard');
            }, child: Text('Continue'))
          ]),
        ),
      ),
    );
  }
}