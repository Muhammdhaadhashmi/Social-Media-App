import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Screens/homeScreen.dart';
import '../../components/common_textfield.dart';
import '../signup/signup.dart';
import 'ForgotPassword.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // User logged in successfully
        print('Login successful');
      }
    } catch (error) {
      print('Error: $error');
    }
    Fluttertoast.showToast(
        msg: 'Login Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor:Color(0xFF0064e0),
        textColor: Colors.white,
        fontSize: 10.0);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF112724),
                Color(0xFF0e202e),
                Color(0xFF1c1e2b),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 20,),
              // Padding(
              //   padding: const EdgeInsets.only(top: 20),
              //   child: const Text(
              //     "English (UK)",
              //     style: TextStyle(
              //       color: Colors.white24,
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 5),
              //   child: const Text(
              //     "Urdu(PAK)",
              //     style: TextStyle(
              //       color: Colors.white24,
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              Image.asset("asset/logo.png", height: 70),
              Column(
                children: [
                  CommonTextfieldConst(
                    padding: true,
                    hintText: "Email Address",
                    controller: _emailController, obscureText: null,
                  ),
                  const SizedBox(height: 12),
                  CommonTextfieldConst(
                    hintText: "Password",
                    padding: true,
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: const Color(0xFF0064e0),
                      ),
                      child: TextButton(
                        onPressed: _login,
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                      );
                    },
                    child: const Text(
                      "Forgotten Password ?",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return const SignupPage();
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF0064e0),
                            width: 0.0,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.transparent,
                        ),
                        child: const Center(
                          child: Text(
                            "Create new account",
                            style: TextStyle(
                              color: Color(0xFF0064e0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Broaxsaxfy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}























// import 'package:flutter/material.dart';
// import '../../components/common_textfield.dart';
// import '../signup/signup.dart';
// import 'ForgotPassword.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           height: double.infinity,
//           width: MediaQuery.of(context).size.width,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.bottomRight,
//               end: Alignment.bottomLeft,
//               colors: [
//                 Color(0xFF112724),
//                 Color(0xFF0e202e),
//                 Color(0xFF1c1e2b),
//               ],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(top: 20),
//                 child: Text(
//                   "English (UK)",
//                   style: TextStyle(
//                     color: Colors.white24,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               Image.asset("asset/logo.png", height: 70),
//               Column(
//                 children: [
//                   CommonTextfieldConst(
//                     padding: true,
//                       hintText: "Mobile number or email address"),
//                   const SizedBox(height: 12),
//                   CommonTextfieldConst(hintText: "Password", padding: true,
//                   ),
//                   const SizedBox(height: 12),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Container(
//                       height: 50,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(24),
//                         color: const Color(0xFF0064e0),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "Log In",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 14),
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
//                     },
//                     child: const Text(
//                       "Forgotten Password ?",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//               Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) {
//                               return const SignupPage();
//                             },
//                           ),
//                         );
//                       },
//                       child: Container(
//                         height: 50,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: const Color(0xFF0064e0),
//                             width: 0.0,
//                           ),
//                           borderRadius: BorderRadius.circular(24),
//                           color: Colors.transparent,
//                         ),
//                         child: const Center(
//                           child: Text(
//                             "Create new account",
//                             style: TextStyle(
//                               color: Color(0xFF0064e0),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text("Broaxsaxfy",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
