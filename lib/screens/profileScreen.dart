import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:bluesky_project/providers/auth.dart';
import 'package:bluesky_project/screens/loginScreen.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bluesky_project/utils/constants.dart';
import 'package:provider/provider.dart';







class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  bool isEditing = false;
  String userImageUrl;
  File _image;
  final picker = ImagePicker();





  _getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, maxWidth: 400.0, maxHeight: 400.0);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        uploadImageToFirebase();
      });
    }
    else {
      print('nooooooo image seleccccccccted');
    }
  }


  Future<void> uploadImageToFirebase() async {
    final userProvider = Provider.of<Auth>(context, listen: false);
    buildShowDialog(context, 'جار تغيير الصورة');
    TaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child("users/${userProvider.userEmail}")
        .putFile(_image).whenComplete(() => print('donnnnnnnnnnnnnnnnnnnnnnnne')).onError((error, stackTrace) => buildShowDialog(context, 'حدث خطأ! حاول ثانية في وقت لاحق'));
    Navigator.of(context).pop();
    userProvider.getProfileImage();
  }




  @override
  Widget build(BuildContext context) {

    final ThemeData themeData = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    final double padding = isLandscape ? screenSize.height * 0.04 : screenSize.width * 0.04;
    final userProvider = Provider.of<Auth>(context);






    return SafeArea(
      child: Container(
        color: Color(0xfff6f6f6),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: MyCustomClipper(),
                    child: Container(
                      height: isLandscape ? screenSize.width * 0.40 : screenSize.height * 0.30,
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: padding * 2),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (userProvider.profileImageUrl == null) {
                                _getImageFromGallery();
                              }
                              else {
                                return showDialog(context: context, builder: (context) => AlertDialog(backgroundColor: Colors.white,
                                  content: Text('Do you want to change the profile picture?', style: themeData.textTheme.headline6.copyWith(color: Colors.green[700], fontSize: size / 1.6),),
                                  actions: [
                                    Padding(
                                      padding: EdgeInsets.only(right: padding * 4),
                                      child: IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red,),
                                        onPressed: () {
                                          if (userProvider.profileImageUrl != null) {
                                            userProvider.deleteProfileImage();
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ),
                                    TextButton(
                                      child: Text('No', style: TextStyle(color: Colors.red),),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Yes', style: TextStyle(color: Colors.green[700]),),
                                      onPressed: () {
                                        _getImageFromGallery();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                                );
                              }
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  child: Container(
                                    width: size * 4,
                                    height: size * 4,
                                    child: FadeInImage(
                                      placeholder: AssetImage('images/empty.png'),
                                      fit: BoxFit.cover,
                                      image: _image == null ? userProvider.profileImageUrl == null ? AssetImage('images/user image.png') : NetworkImage(userProvider.profileImageUrl) : FileImage(_image),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: size * 3,
                                  top: size * 3,
                                  child: Icon(LineAwesomeIcons.camera, size: size, color: Colors.white,),
                                ),
                              ],
                            ),
                          ),
                          // Positioned(child: Icon(Icons.camera_alt_outlined, color: Color(0xFFB40284A), size: size,)),
                          SizedBox(height: padding,),
                          Text('${userProvider.userName}', style: themeData.textTheme.headline6.copyWith(color: Colors.white, fontSize: size / 1.2),),
                          // TextButton.icon(
                          //   label: Text('تعديل' , style: themeData.textTheme.headline6.copyWith(color: Color(0xFFFFFFFF)),),
                          //   icon: Icon(Icons.camera_alt_outlined, color: Color(0xFFFFFFFF), size: size,),
                          //   onPressed: () {
                          //     _getImageFromGallery();
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Padding(
                  //     padding: EdgeInsets.only(top: padding, right: padding),
                  //     child: Container(
                  //       child: IconButton(
                  //           icon: Icon(isEditing ? Icons.save : Icons.edit),
                  //           color: Color(0xff89FF8B),
                  //           onPressed: _validation
                  //       ),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(50.0),
                  //         // color: Color(0xff89FF8B),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              // addVerticalSpace(size * 2),
              // isEditing ? Form(
              //   key: _formKey,
              //   child: EditingContent(
              //     isEditing: isEditing,
              //     screenSize: screenSize,
              //     padding: padding,
              //     size: size,
              //     name: '${userProvider.userName}',
              //     phoneNumber: '${owner.phoneNumber}',
              //     email: '${userProvider.userEmail}',
              //     password: '●●●●●●',
              //     nameController: _userNameController,
              //     phoneController: _userPhoneController,
              //     emailController: _userEmailController,
              //     oldPasswordController: _userOldPasswordController,
              //     newPasswordController: _userNewPasswordController,
              //   ),
              // )
              //     :
              NonEditingContent(
                isEditing: isEditing,
                screenSize: screenSize,
                padding: padding,
                size: size,
                name: '${userProvider.userName}',
                email: '${userProvider.userEmail}',
                password: '********',
                // password: '●●●●●●',
              ),
              // addVerticalSpace(size),
              Padding(
                padding: EdgeInsets.only(
                    top: padding, left: padding, right: padding, bottom: padding),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: InkWell(
                    onTap: () {
                      return showDialog(context: context, builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        content: Text('Do you want to logout?', style: themeData.textTheme.headline6.copyWith(color: Colors.green[700], fontSize: size / 1.6),),
                        actions: [
                          TextButton(
                            child: Text('No', style: TextStyle(color: Colors.green[700]),),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Yes', style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              print('loggggggggouuuuuuuuuuuttttttt');
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                              Provider.of<Auth>(context, listen: false).logout();
                              // Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),);
                    },
                    child: isEditing ? Container() : Container(
                      height: isLandscape ? screenSize.width * 0.8 * 0.07 : screenSize.height * 0.8 * 0.07,
                      padding: EdgeInsets.symmetric(horizontal: padding,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            LineAwesomeIcons.alternate_sign_out,
                            size: size,
                            color: Colors.green[700],
                          ),
                          addHorizontalSpace(padding / 2),
                          Text(
                            'Logout',
                            style: TEXT_THEME_DEFAULT.headline3.copyWith(color: Colors.green[700], fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



buildShowDialog(BuildContext context, String text) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              height: 200.0,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Colors.green[700],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 7.0,),
                    Text(text, style: TextStyle(color: Colors.black),),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

class NonEditingContent extends StatelessWidget {

  final Size screenSize;
  final double padding;
  final double size;
  final String name;
  final String email;
  final String password;
  final bool isEditing;
  final formKey = GlobalKey<FormState>();

  NonEditingContent({
    this.screenSize,
    this.padding,
    this.size,
    this.name,
    this.email,
    this.password,
    this.isEditing
  });


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    return Container(
      height: isLandscape ? screenSize.width * 0.8 * 0.5 : screenSize.height * 0.8 * 0.45,
      // height: isLandscape ? screenSize.width * 0.8 * 0.5 : screenSize.height * 0.8 * 0.5,
      // color: Colors.red,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileListItem(
                screenSize: screenSize,
                isEditing: isEditing,
                icon: LineAwesomeIcons.user,
                text: name,
                padding: padding,
                size: size,
                enable: true,
              ),
              addVerticalSpace(padding / 3),
              // ProfileListItem(
              //   screenSize: screenSize,
              //   isEditing: isEditing,
              //   icon: LineAwesomeIcons.phone,
              //   text: phoneNumber,
              //   padding: padding,
              //   size: size,
              // ),
              // addVerticalSpace(padding / 3),
              ProfileListItem(
                screenSize: screenSize,
                isEditing: isEditing,
                icon: Icons.email,
                text: email,
                padding: padding,
                size: size,
              ),
              addVerticalSpace(padding / 3),
              ProfileListItem(
                screenSize: screenSize,
                isEditing: isEditing,
                icon: LineAwesomeIcons.user_lock,
                text: password,
                padding: padding,
                size: size,
                isPassword: true,
              ),
            ]),
      ),
    );
  }
}




// class EditingContent extends StatelessWidget {
//
//   final Size screenSize;
//   final double padding;
//   final double size;
//   final String name;
//   final String phoneNumber;
//   final String email;
//   final String password;
//   final bool isEditing;
//   final TextEditingController nameController;
//   final TextEditingController phoneController;
//   final TextEditingController emailController;
//   final TextEditingController oldPasswordController;
//   final TextEditingController newPasswordController;
//
//
//   EditingContent({
//     this.screenSize,
//     this.padding,
//     this.size,
//     this.name,
//     this.phoneNumber,
//     this.email,
//     this.password,
//     this.isEditing,
//     this.nameController,
//     this.phoneController,
//     this.emailController,
//     this.oldPasswordController,
//     this.newPasswordController,
//   });
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final isLandscape = (mediaQuery.orientation == Orientation.landscape);
//     return Container(
//       width: isLandscape ? screenSize.width * 0.7 : screenSize.width * 0.8,
//       height: isLandscape ? screenSize.width * 0.5 : screenSize.height * 0.5,
//       // color: Colors.red,
//       // decoration: BoxDecoration(
//       //   border: Border(left: BorderSide(color: Colors.red, width: 2.0), right: BorderSide(color: Colors.red, width: 2.0)),
//       // ),
//       child: RawScrollbar(
//         thumbColor: Color(0xFFB40284A),
//         thickness: 5.0,
//         radius: Radius.circular(15.0),
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//             },
//             child: Column(
//               // mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   ProfileListItem(
//                     screenSize: screenSize,
//                     isEditing: isEditing,
//                     icon: LineAwesomeIcons.user,
//                     text: name,
//                     padding: padding,
//                     size: size,
//                     controller: nameController,
//                     type: 'name',
//                   ),
//                   // ProfileListItem(
//                   //   screenSize: screenSize,
//                   //   isEditing: isEditing,
//                   //   icon: LineAwesomeIcons.phone,
//                   //   text: phoneNumber,
//                   //   padding: padding,
//                   //   size: size,
//                   //   controller: phoneController,
//                   //   type: 'phone',
//                   // ),
//                   ProfileListItem(
//                     screenSize: screenSize,
//                     isEditing: isEditing,
//                     icon: Icons.email,
//                     text: email,
//                     padding: padding,
//                     size: size,
//                     // enable: false,
//                     controller: emailController,
//                     type: 'email',
//                   ),
//                   ProfileListItem(
//                     screenSize: screenSize,
//                     isEditing: isEditing,
//                     icon: LineAwesomeIcons.user_lock,
//                     text: 'كلمة السر القديمة',
//                     padding: padding,
//                     size: size,
//                     isPassword: true,
//                     controller: oldPasswordController,
//                     type: 'oldPassword',
//                   ),
//                   ProfileListItem(
//                     screenSize: screenSize,
//                     isEditing: isEditing,
//                     icon: LineAwesomeIcons.user_lock,
//                     text: 'كلمة السر الجديدة',
//                     padding: padding,
//                     size: size,
//                     isPassword: true,
//                     controller: newPasswordController,
//                     type: 'newPassword',
//                   ),
//                   ProfileListItem(
//                     screenSize: screenSize,
//                     isEditing: isEditing,
//                     icon: LineAwesomeIcons.user_lock,
//                     text: 'تأكيد كلمة السر',
//                     padding: padding,
//                     size: size,
//                     isPassword: true,
//                     controller: newPasswordController,
//                     type: 'submitPassword',
//                   ),
//                   addVerticalSpace(padding * 3),
//                 ]),
//           ),
//         ),
//       ),
//     );
//   }
// }









class ProfileListItem extends StatefulWidget {


  final Size screenSize;
  final double padding;
  final double size;
  final IconData icon;
  final String text;
  final bool isEditing;
  final bool enable;
  final bool isPassword;
  final TextEditingController controller;
  final String type;

  const ProfileListItem({
    this.screenSize,
    this.icon,
    this.text,
    this.padding,
    this.size,
    this.isEditing,
    this.enable = true,
    this.isPassword = false,
    this.controller,
    this.type,

  });

  @override
  _ProfileListItemState createState() => _ProfileListItemState();
}

class _ProfileListItemState extends State<ProfileListItem> {
  bool isNumberOnly(String value){
    var data = int.tryParse(value);
    if (data!=null) return true;
    else return false ;
  }

  bool isCharOnly(String value){
    for(int i = 0 ; i <= 9 ; i ++) {
      if(value.contains(i.toString())) {
        return false;
      }
    }
    return true;
  }
  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);



    return Padding(
      padding:
      // widget.isEditing ? EdgeInsets.only(bottom: widget.padding / 2,
      // ) :
      EdgeInsets.only(top: widget.padding * 1.5, left: widget.padding, right: widget.padding),
      child: Container(
        height:
        // widget.isEditing ? widget.size * 4.5 :
        widget.size * 2,
        padding: EdgeInsets.symmetric(horizontal: widget.padding,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color:
          // widget.isEditing ? Colors.white :
          Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            // widget.isEditing ? Container() :
            Icon(
              widget.icon,
              size: widget.size,
              color: Colors.green[700],
            ),
            if (!widget.isEditing) addHorizontalSpace(widget.padding),
            // widget.isEditing ? Container(
            //   child: Expanded(
            //     child: Theme(
            //       data: ThemeData(
            //         primaryColor: Color(0xFFB40284A),
            //       ),
            //       child: TextFormField(
            //         textDirection: TextDirection.rtl,
            //         controller: widget.controller,
            //         enabled: widget.enable,
            //         // style: TextStyle(color: Color(0xFF89FF8B)),
            //         // autofocus: true,
            //         textInputAction: widget.type == 'oldPassword' || widget.type == 'newPassword' || widget.type == 'submitPassword' ? TextInputAction.done : TextInputAction.next,
            //         keyboardType: widget.type == 'phone' ? TextInputType.number : widget.type == 'email' ? TextInputType.emailAddress : TextInputType.text,
            //         obscureText: widget.type == 'oldPassword' || widget.type == 'newPassword' || widget.type == 'submitPassword' ? isObsecure : false,
            //         style: TextStyle(
            //             color: Colors.black,
            //             decorationColor: Colors.black,
            //             fontSize: isLandscape ? widget.screenSize.width * 0.018 : widget.screenSize.height * 0.018
            //         ),
            //         cursorColor: Color(0xFFB40284A),
            //         scrollPhysics: BouncingScrollPhysics(),
            //         decoration: InputDecoration(
            //           // enabledBorder:  OutlineInputBorder(
            //           //   borderSide: BorderSide(color: Color(0xFFB40284A)),
            //           // ),
            //           suffix: widget.type =='oldPassword' || widget.type == 'newPassword' || widget.type == 'submitPassword'
            //               ?
            //           IconButton(
            //             icon: Icon(Icons.remove_red_eye, size: widget.size,),
            //             onPressed: () {
            //               setState(() {
            //                 isObsecure = !isObsecure;
            //               });
            //             },
            //
            //           )
            //               : null,
            //           hintStyle: TextStyle(
            //             color: Color(0xFFB40284A).withOpacity(0.5),
            //             fontSize: widget.size / 1.6,
            //           ),
            //           errorStyle: TextStyle(
            //             fontSize: widget.size / 2.3,
            //           ),
            //           prefixIcon: Icon(
            //             widget.icon,
            //             size: widget.size,
            //             color: Color(0xFFB40284A),
            //           ),
            //           // border: OutlineInputBorder(),
            //           hintText: widget.text,
            //         ),
            //         validator: (value) {
            //           if (value.isEmpty) {
            //             return 'الرجاء ادخال القيمة';
            //           }
            //           if (widget.type == 'name' && value.startsWith(' ')) {
            //             return 'لا يمكن ان يبدأ الاسم بفراغ';
            //           }
            //           if (widget.type != 'name' && value.contains(' ')) {
            //             return 'لا يمكن استخدام الفراغ';
            //           }
            //           if (widget.type == 'name' && (value.contains('٠') || value.contains('١') || value.contains('٢') || value.contains('٣')
            //               || value.contains('٤') || value.contains('٥') || value.contains('٦') || value.contains('٧') || value.contains('٨') || value.contains('٩')
            //               || value.contains('0') || value.contains('1') || value.contains('2') || value.contains('3') || value.contains('4') || value.contains('5')
            //               || value.contains('6') || value.contains('7') || value.contains('8') || value.contains('9'))) {
            //             return 'لا يمكن استخدام الارقام';
            //           }
            //           if ((widget.type != 'name') && (value.contains('ج') || value.contains('ح') || value.contains('خ') || value.contains('ه') || value.contains('ع') || value.contains('غ') || value.contains('ف')
            //               || value.contains('ق') || value.contains('ث') || value.contains('ص') || value.contains('ض') || value.contains('ت') || value.contains('ا') || value.contains('ل')
            //               || value.contains('ب') || value.contains('ي') || value.contains('س') || value.contains('ش') || value.contains('ن') || value.contains('م') || value.contains('ك')
            //               || value.contains('ط') || value.contains('د') || value.contains('ظ') || value.contains('ز') || value.contains('ى') || value.contains('ة') || value.contains('و')
            //               || value.contains('ئ') || value.contains('ر') || value.contains('ؤ') || value.contains('ء') || value.contains('ذ') || value.contains('٠') || value.contains('١') || value.contains('٢') || value.contains('٣')
            //               || value.contains('٤') || value.contains('٥') || value.contains('٦') || value.contains('٧') || value.contains('٨') || value.contains('٩'))) {
            //             return 'لا يمكن استخدام الحروف العربية';
            //           }
            //           if ((widget.type == 'phone') && !value.startsWith('0')) {
            //             return 'يجب ان يبدأ رقم الهاتف ب 0';
            //           }
            //           if ((widget.type == 'phone') && value.contains('.') || value.contains(',') || value.contains('-') || value.contains('*') || value.contains('/')) {
            //             return 'الرجاء ادخال الرقم بدون فواصل';
            //           }
            //           if ((widget.type == 'phone') && value.length < 10) {
            //             return 'لا يمكن ان يكون رقم الهاتف اقل من 10 ارقام';
            //           }
            //           if ((widget.type == 'phone') && value.length > 10) {
            //             return 'لا يمكن ان يكون رقم الهاتف اكبر من 10 ارقام';
            //           }
            //           if (widget.type == 'email' && (!value.contains('@') || !value.endsWith('.com'))) {
            //             return 'صيغة الايميل خاطئة';
            //           }
            //           // if (value.contains('٠') || value.contains('١') || value.contains('٢') || value.contains('٣') || value.contains('٤') || value.contains('٥') ||
            //           //     value.contains('٦') || value.contains('٧') || value.contains('٨') || value.contains('٩')) {
            //           //   return 'لا يمكن استخدام الارقام';
            //           // }
            //           else {
            //             return null;
            //           }
            //         },
            //       ),
            //     ),
            //   ),
            // ) :
            Text(
              widget.text,
              overflow: TextOverflow.ellipsis,
              style: TEXT_THEME_DEFAULT.headline4.copyWith(color: Colors.green[700], fontSize: isLandscape ? widget.screenSize.width * 0.015 : widget.screenSize.height * 0.015),
            ),
            // Spacer(),
          ],
        ),
      ),
    );
  }
}





class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 100);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}
