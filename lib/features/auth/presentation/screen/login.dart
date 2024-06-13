import 'dart:convert';
import 'package:chatw8me/features/auth/data/auth_provider.dart';
import 'package:chatw8me/features/auth/presentation/screen/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool? isLoading;
  @override
  Widget build(BuildContext context) {
    final login = ref.watch(loginProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            children: <Widget>[
              SizedBox(height: 3.h),
              Text(
                'SignIn',
                style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.h),
              Container(
                height: 50.h,
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_outline),
                              hintText: 'Email'),
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter Your Email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            hintText: 'password',
                          ),
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Write your unit price';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 80.w,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 40.w),
                              Text('Forgot Password ?')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Wrap(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                               if (_formKey.currentState!.validate()) {
                              
                                try {
                                  await login(_emailController.text, _passwordController.text);
                                }catch (e){
                                 setState(() {
                                   isLoading = false;
                                 });
                                 ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                   content: Text(e.toString()), 
                                 ));
                                
                                
                                } finally {
                                  context.go('/');
                                  
                                }
                                
                            
                              }
                              },
                              child: Text('Login'),
                            ),
                            isLoading == true
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.red,
                                    )),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return Registration();
                              }));
                            },
                            child: Text(
                              'Register as a new User.',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ))
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
