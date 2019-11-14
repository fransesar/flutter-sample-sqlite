import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite/SQLiteHelper.dart';
import 'package:sqlite/User.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var formKey1 = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  var username = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var usernameEdit = TextEditingController();
  var emailEdit = TextEditingController();
  var passwordEdit = TextEditingController();
  var sqliteHelper = SQLiteHelper();

  save() {
    var u = username.text;
    var e = email.text;
    sqliteHelper.addUser(User('', u, e));
    setState(() {});
  }

  editUser(String id){
    var u = usernameEdit.text;
    var e = emailEdit.text;
    sqliteHelper.updateUser(User('', u, e),id);
    setState(() {});
  }

  deleteAllUsers() {
    sqliteHelper.deleteAllUsers();
    setState(() {});
  }

  deleteUser(String id) {
    sqliteHelper.deleteUser(id);
    setState(() {});
  }

  listUser() async {
    List<User> users = await sqliteHelper.getUser();
    return users;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title:
            Text('SQLite Application', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(20),
            child: Form(
              key: formKey1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text('Login',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                          labelText: 'Username', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please input username';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          labelText: 'Email', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please input email';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please input password';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.lightBlue,
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (formKey1.currentState.validate()) {
                            save();
                          }
                        },
                      )),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('List User',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlue)),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.lightBlue),
                        onPressed: () {
                          deleteAllUsers();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: FutureBuilder(
                    future: listUser(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot == null) {
                        return Container();
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: snapshot.data == null
                                ? 0
                                : snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20),
                                child: Row(
                                  children: <Widget>[
                                    Text((index + 1).toString()),
                                    SizedBox(width: 20),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].username,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(snapshot.data[index].email)
                                      ],
                                    )),
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: Colors.yellow[900]),
                                      onPressed: () {
                                        usernameEdit.text = snapshot.data[index].username;
                                        emailEdit.text = snapshot.data[index].email;
                                        return showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: Form(
                                                key: formKey2,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.all(20),
                                                      child: Text('Edit',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.lightBlue)),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                                      child: TextFormField(
                                                        controller: usernameEdit,
                                                        decoration: InputDecoration(
                                                            labelText: 'Username', border: OutlineInputBorder()),
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Please input username';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                                      child: TextFormField(
                                                        controller: emailEdit,
                                                        decoration: InputDecoration(
                                                            labelText: 'Email', border: OutlineInputBorder()),
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Please input email';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                                      child: TextFormField(
                                                        controller: passwordEdit,
                                                        obscureText: true,
                                                        decoration: InputDecoration(
                                                            labelText: 'Password', border: OutlineInputBorder()),
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Please input password';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                                        width: double.infinity,
                                                        child: RaisedButton(
                                                          color: Colors.lightBlue,
                                                          child: Text(
                                                            'Save',
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                          onPressed: () {
                                                            if (formKey2.currentState.validate()) {
                                                              editUser(snapshot.data[index].id);
                                                              Navigator.pop(context);
                                                            }
                                                          },
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        deleteUser(snapshot.data[index].id);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
