import 'package:flutter/material.dart';
import '../../../generated/assets.dart';
import '../widgets/login_form.dart';
import '../widgets/login_hero_section.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isDesktop = width >= 1200;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(Assets.images.loginBg.path), fit: .fitWidth),
                ),
                child: const LoginHeroSection(),
              ),
            ),

          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: Center(child: LoginForm()),
            ),
          ),
        ],
      ),
    );
  }
}
