import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'parent_form.dart';
import 'teacher_form.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(milliseconds: 1600), () {
      showDialog(context: context, builder: (_) => RoleDialog());
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Lottie animation (placeholder). Replace with assets/animations/xxx.json
          SizedBox(
            width: 140, height: 140,
            child: Lottie.asset('assets/animations/loader.json', fit: BoxFit.contain, repeat: true),
          ),
          SizedBox(height:12),
          AnimatedTextKit(animatedTexts: [
            TyperAnimatedText('Unique School System', textStyle: TextStyle(fontSize:22,fontWeight: FontWeight.bold)),
            TypewriterAnimatedText('Smart. Simple. Stunning.', textStyle: TextStyle(fontSize:14)),
          ], isRepeatingAnimation: false),
          SizedBox(height:16),
          // 3D placeholder - replace model in assets/3d when ready
          SizedBox(
            width: 120, height: 120,
            child: Cube(onSceneCreated: (scene) {
              scene.world.add(Object(fileName: 'assets/3d/school.obj'));
              scene.update();
            }),
          )
        ]),
      ),
    );
  }
}

class RoleDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you a Parent or a Teacher?'),
      content: Text('Choose your role to continue.'),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => ParentForm()));
        }, child: Text('Parent')),
        TextButton(onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherForm()));
        }, child: Text('Teacher')),
      ],
    );
  }
}