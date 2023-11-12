import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/userInfo.dart';
import 'package:found_adoption_application/repository/profile_api.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Future<InfoUser> userFuture;
  @override
  void initState() {
    super.initState();
    userFuture = getProfile(context);
  }

  bool isObsecurePassword = true;
  bool selectedRadio = true;

  setSelectedRadio(bool val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Edit Profile UI'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MenuFrame()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
          // onPressed: () {
          //   // Navigator.pop(context);
          // },

        ),
      ),
      body: FutureBuilder<InfoUser>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // If the Future is still loading, show a loading indicator
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If there is an error fetching data, show an error message
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // If data is successfully fetched, display the form
              InfoUser user = snapshot.data!;
              return Container(
                padding: EdgeInsets.only(left: 15, top: 20, right: 15),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 4, color: Colors.white),

                                  //hiệu ứng bóng đổ
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.1))
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(user!.avatar),
                                  )),
                            ),
                            Positioned(
                              // onPressed: (){},
                              bottom: 0.0,
                              right: 0.0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 4, color: Colors.white),
                                    color: Colors.blue),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //Thực hiện các inputField

                      buildTextField('First Name', user.firstName, false),
                      buildTextField('Last Name', user.lastName, false),

                      buildTextField("Phone Number", user.phoneNumber, false),
                      buildTextField("Email", user.email, true),
                      buildTextField("Role", user.role, true),
                      buildTextField("Address", user.address, false),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Experiences: ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),

                      //Radion button Experience
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio(
                              value: true,
                              groupValue: user.experience,
                              onChanged: (val) {
                                setSelectedRadio(val!);
                              }),
                          Text('Yes'),
                          SizedBox(
                            width: 50,
                          ),
                          Radio(
                              value: false,
                              groupValue: user.experience,
                              onChanged: (val) {
                                setSelectedRadio(val!);
                              }),
                          Text('No'),
                        ],
                      ),

                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Tell us about yourself',
                            helperText: 'Keep it short, this is just demo',
                            labelText: 'Life Story'),
                        maxLines: 4,
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.black),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isReadOnly) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        // obscureText: isReadOnly ? isObsecurePassword : false,
        readOnly: isReadOnly,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}