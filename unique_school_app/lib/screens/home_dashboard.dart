import 'package:flutter/material.dart';

class HomeDashboard extends StatefulWidget {
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  Map<String, List<Map>> classes = {
    'Prep': [
      {'name':'Ahmed','star':false,'id':'s1'},
      {'name':'Sara','star':true,'id':'s2'},
    ],
    'One': [
      {'name':'Bilal','star':false,'id':'s3'},
      {'name':'Hina','star':false,'id':'s4'},
    ],
  };

  void toggleStar(String className, int idx){
    setState(()=> classes[className]![idx]['star'] = !(classes[className]![idx]['star'] ?? false));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Star updated for ${classes[className]![idx]['name']}')));
    // TODO: Save to Firestore class/{className}/starOfMonth doc
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text('Today\'s Diary', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('No diary today — demo mode'),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
          SizedBox(height:12),
          Text('Classes', style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
          ...classes.entries.map((entry){
            String cname = entry.key;
            List<Map> students = entry.value;
            return Card(
              margin: EdgeInsets.symmetric(vertical:8),
              child: ExpansionTile(
                leading: CircleAvatar(child: Text(cname[0])),
                title: Text(cname),
                children: students.asMap().entries.map((e){
                  int i = e.key;
                  var s = e.value;
                  return ListTile(
                    leading: CircleAvatar(child: Text(s['name'][0])),
                    title: Text(s['name']),
                    trailing: IconButton(
                      icon: Icon(s['star'] ? Icons.star : Icons.star_border, color: s['star'] ? Colors.amber : null),
                      onPressed: ()=> toggleStar(cname, i),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}