import 'package:flutter/material.dart';
import 'package:machine_test/model/EmployeeDetails.dart';
import 'package:machine_test/provider/employee_details_provider.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(),
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

  Widget _buildList(employeeDetails) {
    final suggestionlist = contactscontroller.text.isEmpty
        ? employeeDetails
        : employeeDetails
            .where((p) =>
                (p.name.toString().toLowerCase().contains(
                    contactscontroller.text.toString().toLowerCase())) ||
                (p.email.toString().toLowerCase().contains(
                    contactscontroller.text.toString().toLowerCase())))
            .toList();

    return employeeDetails.loading
        ? Container(
            child: CircularProgressIndicator(),
          )
        : ListView.separated(
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
              return ContactListTile(content, employee);
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

class ContactListTile extends ListTile {
  ContactListTile(BuildContext context, employee)
      : super(
            title: Text(employee.name),
            subtitle: Text(employee.co),
            leading: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: '${employee.profileImage}',
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeDetailsView()),
              );
            });
}

class EmployeeDetailsView extends StatefulWidget {
  @override
  _EmployeeDetailsViewState createState() => _EmployeeDetailsViewState();
}

class _EmployeeDetailsViewState extends State<EmployeeDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
