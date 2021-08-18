import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:machine_test/constants/colors.dart';
import 'package:machine_test/model/EmployeeDetails.dart';
import 'package:machine_test/provider/employee_details_provider.dart';
import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class HomeSCreen extends StatefulWidget {
  @override
  _HomeSCreenState createState() => _HomeSCreenState();
}

class _HomeSCreenState extends State<HomeSCreen> {
  TextEditingController contactscontroller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    final employeeDetails =
        Provider.of<EmployeeDetailsProvider>(context, listen: false);

    employeeDetails.getEmployeeDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    final employeeDetails = Provider.of<EmployeeDetailsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Container(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(child: _buildSearchBar()),
              Expanded(child: _buildList(employeeDetails)),
            ],
          ))),
    );
  }

  Widget _buildList(EmployeeDetailsProvider employees) {
    final suggestionlist = contactscontroller.text.isEmpty
        ? employees.allEmployees
        : employees.allEmployees
            .where((p) =>
                (p.name.toString().toLowerCase().contains(
                    contactscontroller.text.toString().toLowerCase())) ||
                (p.email.toString().toLowerCase().contains(
                    contactscontroller.text.toString().toLowerCase())))
            .toList();

    return employees.loading
        ? Container(
          child:Text('Loading ...')
          ):

          // Container(
          //   child:Text(suggestionlist.toString())
          // );

         ListView.separated(
            shrinkWrap: true,
            itemCount: suggestionlist.length,
            separatorBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Divider(height: 0.5, color: Colors.black26),
              );
            },
            itemBuilder: (content, index) {
              EmployeeDetails employee = suggestionlist[index];
              return ListTile(
                  leading:CachedNetworkImage(
              fit: BoxFit.fitWidth,
              imageUrl: '${employee.profileImage}',
              imageBuilder: (context, imageProvider) => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Center(
                child: Image(
                  image: AssetImage(
                    '',
                  ),
                  color: Colors.white,
                ),
              ),
            ),
                  title: Text(employee.name??''),
                  subtitle: Text(employee.company != null ?employee.company.name:''),
                  onTap: (){
                    Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeDetailsView( employee)),
              );
                  },
              );
            },
          );
  }

  PreferredSize _buildSearchBar() {
    return PreferredSize(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Container(
          color: Color(0xffeff0f1),
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: TextFormField(
            cursorColor: Theme.of(context).accentColor,
            controller: contactscontroller,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
                prefixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).accentColor,
                    )),
                suffix: Text(
                  '',
                  textAlign: TextAlign.right,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 0, bottom: 12, top: 12, right: 16),
                hintText: 'Search'),
          ),
        ),
      ),
      preferredSize: Size.fromHeight(80.0),
    );
  }
}



class EmployeeDetailsView extends StatefulWidget {
  final EmployeeDetails employee;
  EmployeeDetailsView(this.employee);
  @override
  _EmployeeDetailsViewState createState() => _EmployeeDetailsViewState();
}

class _EmployeeDetailsViewState extends State<EmployeeDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 330,
                    color: PRIMARY_COLOR,
                  ),
                 
                  Column(
                    children: <Widget>[
                      Container(
                        height: 90,
                        margin: EdgeInsets.only(top: 60),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: CachedNetworkImage(
              fit: BoxFit.fitWidth,
              imageUrl: '${widget.employee.profileImage}',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Center(
                child: Image(
                  image: AssetImage(
                    '',
                  ),
                  color: Colors.white,
                ),
              ),
            ),
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Text(
                        "${widget.employee.name}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Text(
                         "${widget.employee.username}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      UserInfo(widget.employee)
                      
                      
                    ],
                  )
                ],
              ),
            ],
          ),
      )

    );
  }
}


class UserInfo extends StatelessWidget {
  final EmployeeDetails employee;
  UserInfo(this.employee);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "User Information",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                      child: Column(
                    children: <Widget>[
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        
                        title: Text("User Name"),
                        subtitle: Text("${employee.username}"),
                      ),
                      ListTile(
                        
                        title: Text("Email"),
                        subtitle: Text("${employee.email}"),
                      ),
                      ListTile(
                        
                        title: Text("Phone"),
                        subtitle: Text("${employee.phone??''}"),
                      ),
                      ListTile(
                        title: Text("Website"),
                        subtitle: Text("${employee.website}"),
                      ),
                      ListTile(
                        title: Text("Company Name"),
                        subtitle: Text("${employee.company.name}"),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
