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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState(){
    super.initState();
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _logoController, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack));
    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        showDialog(context: context, builder: (_) => RoleDialog());
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // App logo with fade + scale animation
          FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: SizedBox(
                width: 140, height: 140,
                child: Image.asset('assets/logo/unique_logo.jpg', fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height:12),
          // Lottie loader below the logo
          SizedBox(
            width: 56, height: 56,
            child: Lottie.asset('assets/animations/loader.json', fit: BoxFit.contain, repeat: true),
          ),
          const SizedBox(height:12),
          AnimatedTextKit(animatedTexts: [
            TyperAnimatedText('Unique School System', textStyle: const TextStyle(fontSize:22,fontWeight: FontWeight.bold)),
            TypewriterAnimatedText('Smart. Simple. Stunning.', textStyle: const TextStyle(fontSize:14)),
          ], isRepeatingAnimation: false),
          const SizedBox(height:16),
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