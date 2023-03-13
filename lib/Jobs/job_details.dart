import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupwork/Jobs/jobs_screen.dart';
import 'package:cupwork/Services/global_methods.dart';
import 'package:cupwork/Services/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

class JobDetailsScreen extends StatefulWidget {
  final String uploadedBy;
  final String jobID;
  const JobDetailsScreen({required this.uploadedBy, required this.jobID});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;
  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDataTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int applicants = 0;
  bool isDeadlineAvailable = false;
  bool showComment = false;
  void getJobData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get('name');
        userImageUrl = userDoc.get('userImage');
      });
    }
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobID)
        .get();

    if (jobDatabase == null) {
      return;
    } else {
      setState(() {
        jobTitle = jobDatabase.get('jobTitle');
        jobDescription = jobDatabase.get('jobDescription');
        recruitment = jobDatabase.get('recruitment');
        emailCompany = jobDatabase.get('email');
        locationCompany = jobDatabase.get('location');
        applicants = jobDatabase.get('applicants');
        postedDataTimeStamp = jobDatabase.get('createdAt');
        deadlineDateTimeStamp = jobDatabase.get('deadlineDateTimeStamp');
        deadlineDate = jobDatabase.get('deadlineDate');

        var postDate = postedDataTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
        var date = deadlineDateTimeStamp!.toDate();
        isDeadlineAvailable = date.isAfter(DateTime.now());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getJobData();
  }

  Widget dividerWidget() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  applyForJob() {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query:
          'Subjects Applying for $jobTitle&body=Hello,please attach Resume CV file',
    );
    final url = params.toString();

    launchUrlString(url);
    addNewApplicant();
  }

  void addNewApplicant() async {
    var docRef =
        FirebaseFirestore.instance.collection('jobs').doc(widget.jobID);

    docRef.update({
      'applicants': applicants + 1,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.deepOrange.shade300, Colors.blueAccent],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: const [0.2, 0.9],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.deepOrange.shade300, Colors.blueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.2, 0.9],
            )),
          ),
          leading: IconButton(
            icon: Icon(Icons.close, size: 40, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => JobsScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Card(
                color: Colors.black54,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          jobTitle == null ? '' : jobTitle!,
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userImageUrl == null
                                        ? 'https://t4.ftcdn.net/jpg/02/29/75/83/360_F_229758328_7x8jwCwjtBMmC6rgFzLFhZoEpLobB6L8.jpg'
                                        : userImageUrl!,
                                  ),
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authorName == null ? '' : authorName!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  locationCompany!,
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            applicants.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Applicants',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.how_to_reg_sharp,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      FirebaseAuth.instance.currentUser!.uid !=
                              widget.uploadedBy
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dividerWidget(),
                                Text(
                                  'Recruitment',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        User? user = _auth.currentUser;
                                        final _uid = user!.uid;
                                        if (_uid == widget.uploadedBy) {
                                          try {
                                            FirebaseFirestore.instance
                                                .collection('jobs')
                                                .doc(widget.jobID)
                                                .update({'recruitment': true});
                                          } catch (error) {
                                            GlobalMethod.showErrorDialog(
                                                error:
                                                    'Action cannot be performed',
                                                ctx: context);
                                          }
                                        } else {
                                          GlobalMethod.showErrorDialog(
                                            error:
                                                'You cannot perform this action',
                                            ctx: context,
                                          );
                                        }
                                        getJobData();
                                      },
                                      child: Text(
                                        'ON',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: recruitment == true ? 1 : 0,
                                      child: Icon(
                                        Icons.check_box,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        User? user = _auth.currentUser;
                                        final _uid = user!.uid;
                                        if (_uid == widget.uploadedBy) {
                                          try {
                                            FirebaseFirestore.instance
                                                .collection('jobs')
                                                .doc(widget.jobID)
                                                .update({'recruitment': false});
                                          } catch (error) {
                                            GlobalMethod.showErrorDialog(
                                                error:
                                                    'Action cannot be performed',
                                                ctx: context);
                                          }
                                        } else {
                                          GlobalMethod.showErrorDialog(
                                            error:
                                                'You cannot perform this action',
                                            ctx: context,
                                          );
                                        }
                                        getJobData();
                                      },
                                      child: Text(
                                        'OFF',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: recruitment == false ? 1 : 0,
                                      child: Icon(
                                        Icons.check_box,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                      dividerWidget(),
                      Text(
                        'Job Description',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        jobDescription == null ? '' : jobDescription!,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Card(
                color: Colors.black54,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          isDeadlineAvailable
                              ? 'Activity Recuiting, Send CV/Resume:'
                              : 'Deadline Passed away.',
                          style: TextStyle(
                            color:
                                isDeadlineAvailable ? Colors.green : Colors.red,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Center(
                        child: MaterialButton(
                          onPressed: () {
                            applyForJob();
                          },
                          color: Colors.blue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              'Easy Apply Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Uploaded on:',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            postedDate == null ? '' : postedDate!,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deadline Date:',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            deadlineDate == null ? '' : deadlineDate!,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )
                        ],
                      ),
                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Card(
                color: Colors.black54,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          child: _isCommenting
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        flex: 3,
                                        child: TextField(
                                          controller: _commentController,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          maxLength: 200,
                                          keyboardType: TextInputType.text,
                                          maxLines: 6,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.pink)),
                                          ),
                                        )),
                                    Flexible(
                                        child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: MaterialButton(
                                            onPressed: () async {
                                              if (_commentController
                                                      .text.length <
                                                  7) {
                                                GlobalMethod.showErrorDialog(
                                                  error:
                                                      'Comment cannot be less than 7 characters',
                                                  ctx: context,
                                                );
                                              } else {
                                                final _generatedId =
                                                    Uuid().v4();
                                                await FirebaseFirestore.instance
                                                    .collection('jobs')
                                                    .doc(widget.jobID)
                                                    .update({
                                                  'jobComments':
                                                      FieldValue.arrayUnion([
                                                    {
                                                      'userId': FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      'commentId': _generatedId,
                                                      'name': name,
                                                      'userImageUrl': userImage,
                                                      'commentBody':
                                                          _commentController
                                                              .text,
                                                      'time': Timestamp.now(),
                                                    }
                                                  ]),
                                                });
                                                await Fluttertoast.showToast(
                                                  msg:
                                                      'your comment has been added',
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  backgroundColor: Colors.grey,
                                                  fontSize: 18.0,
                                                );
                                                _commentController.clear();
                                              }
                                              setState(() {
                                                showComment = true;
                                              });
                                            },
                                            color: Colors.blueAccent,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              'Post',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _isCommenting = !_isCommenting;
                                                showComment = false;
                                              });
                                            },
                                            child: Text('cancel'))
                                      ],
                                    ))
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isCommenting = !_isCommenting;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.add_comment,
                                          color: Colors.blueAccent,
                                          size: 40,
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showComment = false;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.arrow_drop_down_circle,
                                          color: Colors.blueAccent,
                                          size: 40,
                                        ))
                                  ],
                                ))
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
