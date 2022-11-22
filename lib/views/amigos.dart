import 'package:flutter/material.dart';
import 'package:paywallet_app/pages/amigos_page.dart';

class Amigos extends StatelessWidget {
  const Amigos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xff3a4d54),
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Amigos",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xff202f36),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AmigosPage()));
                              },
                              child: Icon(
                                Icons.person_add,
                                color: Colors.white,
                                size: 28,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
        )
    );
  }
}