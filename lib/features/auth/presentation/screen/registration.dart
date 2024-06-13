import 'package:chatw8me/features/auth/data/auth_provider.dart';
import 'package:chatw8me/features/auth/presentation/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:go_router/go_router.dart';


class Registration extends ConsumerStatefulWidget {
  const Registration({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegistrationState();
}

class _RegistrationState extends ConsumerState<Registration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool? isLoading;
  @override
  Widget build(BuildContext context) {
    final register = ref.watch(registrationProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            children: <Widget>[
              SizedBox(height: 3.h),
              Text(
                'Register',
                style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.h),
              Container(
                height: 70.h,
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: 'Name'),
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter Your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: 'email'),
                          validator: (String? value) {
                            if (value == null) {
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
                              return 'enter password !';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordConfirmController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            hintText: 'confirm password',
                          ),
                          validator: (String? value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                _passwordConfirmController.text !=
                                    _passwordController.text) {
                              return 'password doest not match !';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 3.h,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              if (_formKey.currentState!.validate()) {
                              
                                try {
                                  await register( _nameController.text, _emailController.text.trim(), _passwordController.text);
                                }catch (e){
                                 setState(() {
                                   isLoading = false;
                                 });
                                 ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                   content: Text(e.toString()), 
                                 ));
                                
                                
                                } 
                            
                              }
                            },
                            child: Text('Register')),
                        isLoading == true
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.red,
                                )),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 5.h,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Login();
                              }));
                            },
                            child: Text(
                              'Already Register ? please Login',
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }
}