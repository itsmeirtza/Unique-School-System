import 'package:flutter/material.dart';
import '../services/push_notifications.dart';

class TeacherForm extends StatefulWidget {
  @override
  _TeacherFormState createState() => _TeacherFormState();
}

class _TeacherFormState extends State<TeacherForm> {
  final _formKey = GlobalKey<FormState>();
  String name='', email='', phone='', className='';
  List<String> subjects = [];

  void addSubject(){
    setState(()=> subjects.add(''));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Teacher Registration')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView(children:[
          TextFormField(decoration: InputDecoration(labelText:'Teacher Name'), onChanged:(v)=>name=v),
          TextFormField(decoration: InputDecoration(labelText:'Email'), onChanged:(v)=>email=v),
          TextFormField(decoration: InputDecoration(labelText:'Phone'), onChanged:(v)=>phone=v),
          TextFormField(decoration: InputDecoration(labelText:'Class (you teach)'), onChanged:(v)=>className=v),
          SizedBox(height:10),
          Text('Subjects (tap add once to create template)'),
          ...subjects.asMap().entries.map((e){
            int i=e.key;
            return TextFormField(decoration: InputDecoration(labelText:'Subject ${i+1}'), onChanged:(val)=>subjects[i]=val);
          }),
          ElevatedButton.icon(onPressed: addSubject, icon: Icon(Icons.add), label: Text('Add Subject')),
          SizedBox(height:12),
          ElevatedButton(onPressed: () async {
            // TODO: Save teacher profile with subject template
            if (className.trim().isNotEmpty) {
              await PushNotificationService.instance.setSubscriptionForClass(className, true);
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved locally (stub).')));
            Navigator.pushReplacementNamed(context, '/dashboard');
          }, child: Text('Continue'))
        ]),
      ),
    );
  }
}