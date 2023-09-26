import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging_station_finder_1_0/model/booking_model.dart';
import 'package:ev_charging_station_finder_1_0/my_booking_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BookingScreen extends StatefulWidget {
  dynamic stationData;
  dynamic chargerData;
  dynamic chargerId;
  int wa2t;

  BookingScreen(this.stationData, this.chargerData, this.chargerId, this.wa2t);

  @override
  _BookingScreenState createState() => _BookingScreenState(stationData, chargerData, chargerId, wa2t);
}

class _BookingScreenState extends State<BookingScreen> {
  dynamic stationData;
  dynamic chargerData;
  dynamic chargerId;
  int wa2t;

  _BookingScreenState(this.stationData, this.chargerData, this.chargerId,this.wa2t);

  final now = DateTime.now();
  String? fname;
  String? lname;
  String? number;

  String getEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email ?? '';
    }
    return '';
  }

  getfName() {
    FirebaseFirestore.instance.collection('users')
    .where('email', isEqualTo: getEmail()).get().then((docs)
    {
      setState(() {
        fname = docs.docs[0].data()['fname'];
        return;
      });
    }

    );
    return fname;
  }

  getlName() {
    FirebaseFirestore.instance.collection('users')
        .where('email', isEqualTo: getEmail()).get().then((docs) {
      setState(() {
        lname = docs.docs[0].data()['lname'];
        return;
      });
    }

    );
    return lname;
  }

  getnumber() {
    FirebaseFirestore.instance.collection('users')
        .where('email', isEqualTo: getEmail()).get().then((docs) {
      setState(() {
        number = docs.docs[0].data()['mobile'];
        return;
      });
    }

    );
    return number;
  }


  late BookingService mockBookingService = mockBookingService = BookingService(
      serviceName: 'Charger Booking',
      serviceDuration: wa2t,
      bookingEnd: DateTime(now.year, now.month, now.day, 23, 0),
      bookingStart: DateTime(now.year, now.month, now.day, 1, 0),
      serviceId: chargerId,
      //serviceId: chargerData['stationId'],
      servicePrice: chargerData['price'],
      userEmail: getEmail(),
      userId: FirebaseAuth.instance.currentUser!.uid,
      userName: getfName().toString() + " " + getlName().toString(),
      userPhoneNumber: getnumber().toString(),
  );

  CollectionReference bookings =
  FirebaseFirestore.instance.collection('bookings');

    @override
  void initState() {
    super.initState();
    getfName();
    getlName();
    getnumber();
    print(stationData.toString());
    print(chargerData.toString());
    print(getfName().toString());
  }

  ///This is how can you get the reference to your data from the collection, and serialize the data with the help of the Firestore [withConverter]. This function would be in your repository.
  CollectionReference<BookingService> getBookingStream() {
    return bookings.withConverter<BookingService>(
      fromFirestore: (snapshots, _) =>
          BookingService.fromJson(snapshots.data()!),
      toFirestore: (snapshots, _) => snapshots.toJson(),
    );
  }

  ///How you actually get the stream of data from Firestore with the help of the previous function
  ///note that this query filters are for my data structure, you need to adjust it to your solution.
  Stream<dynamic>? getBookingStreamFirebase(
      {required DateTime end, required DateTime start}) {
      print("Station Id: " + chargerData['stationId'].toString());
    return getBookingStream()
        //.where('serviceId', isEqualTo: chargerData['stationId'])
        .where('serviceId', isEqualTo: chargerId)
        .snapshots();
  }

  List<DateTimeRange> converted = [];

  ///After you fetched the data from firestore, we only need to have a list of datetimes from the bookings:
  List<DateTimeRange> convertStreamResultFirebase(
      {required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    ///Note that this is dynamic, so you need to know what properties are available on your result, in our case the [BookingService] has bookingStart and bookingEnd property

    for (var i = 0; i < streamResult.size; i++) {
      final item = streamResult.docs[i].data();
      converted.add(
          DateTimeRange(start: (item.bookingStart!), end: (item.bookingEnd!)));
    }
    return converted;
  }

  ///This is how you upload data to Firestore version 1
  // Future<dynamic> uploadBookingFirebase(
  //     {required BookingService newBooking}) async {
  //   await bookings.add(newBooking.toJson()).then((value) {
  //     print("Booking Added");
  //     dynamic start = newBooking.bookingStart;
  //     dynamic end = newBooking.bookingEnd;
  //     addBookData(start, end);
  //     setState(() {
  //
  //     });
  //   }).catchError((error) => print("Failed to add booking: $error"));
  // }

  //version 2
  // Future<void> uploadBookingFirebase({required BookingService newBooking}) async {
  //   try {
  //     DocumentReference bookingRef = await bookings.add(newBooking.toJson());
  //     String bookingId = bookingRef.id;
  //     print("Booking Added with ID: $bookingId");
  //
  //     dynamic start = newBooking.bookingStart;
  //     dynamic end = newBooking.bookingEnd;
  //     await addBookData(bookingId, start, end);
  //
  //     setState(() {
  //       // Update the state as needed
  //     });
  //   } catch (error) {
  //     print("Failed to add booking: $error");
  //   }
  // }

  Future<void> uploadBookingFirebase({required BookingService newBooking}) async {
    try {
      DocumentReference bookingRef = await bookings.add(newBooking.toJson());
      String bookingId = bookingRef.id;
      print("Booking Added with ID: $bookingId");

      dynamic start = newBooking.bookingStart;
      dynamic end = newBooking.bookingEnd;
      String chargerId = await bookingRef.get().then((snapshot) {
        return snapshot.get('serviceId');
      });

      await addBookData(bookingId, start, end, chargerId);

      setState(() {
        // Update the state as needed
      });
    } catch (error) {
      print("Failed to add booking: $error");
    }
  }


  // List<DateTimeRange> generatePauseSlots() {
  //   return [
  //     DateTimeRange(
  //         start: DateTime(now.year, now.month, now.day, 12, 0),
  //         end: DateTime(now.year, now.month, now.day, 13, 0))
  //   ];
  // }

  void showPopupMenu(BuildContext context) {
    final RenderBox appBarRenderBox = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        appBarRenderBox.localToGlobal(Offset.zero, ancestor: overlay),
        appBarRenderBox.localToGlobal(appBarRenderBox.size.bottomLeft(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: '30',
          child: Text('30 Minutes'),
        ),
        PopupMenuItem<String>(
          value: '60',
          child: Text('1 Hour'),
        ),
        PopupMenuItem<String>(
          value: '90',
          child: Text('90 Minutes'),
        ),
        PopupMenuItem<String>(
          value: '120',
          child: Text('2 Hours'),
        ),
        // PopupMenuItem<String>(
        //   value: '150',
        //   child: Text('150 Minutes'),
        // ),
        // PopupMenuItem<String>(
        //   value: '180',
        //   child: Text('3 Hours'),
        // ),
        // Add more options as needed
      ],
    ).then((value) {
      if (value != null) {
        // Handle duration selection
        print('Selected Duration: $value');
        setState(() {
          bookingDuration = int.parse(value);
        });
      }
    });
  }

  int bookingDuration = 30;
  String duration = 'Select Duration';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Booking Calendar Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Book Now"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          body: Center(
            child: BookingCalendar(
              bookingService: mockBookingService,
              convertStreamResultToDateTimeRanges: convertStreamResultFirebase,
              getBookingStream: getBookingStreamFirebase,
              uploadBooking: uploadBookingFirebase,
              // pauseSlots: generatePauseSlots(),
              // pauseSlots: res,
              // pauseSlotText: 'LUNCH',
              // hideBreakTime: false,
              bookedSlotColor: Colors.red,
              loadingWidget: const Text('Fetching data...'),
              uploadingWidget: const CircularProgressIndicator(),
              locale: 'en-EN',
              startingDayOfWeek: StartingDayOfWeek.tuesday,
              wholeDayIsBookedWidget: const Text(
                  'Sorry, for this day everything is booked'),
              //disabledDates: [DateTime(2023, 1, 20)],
              //disabledDays: [6, 7],
            ),
          ),
        ));
  }

  // Future addBookData(start, end) async {
  //   await FirebaseFirestore.instance.collection('test').doc('test').set({
  //     'fname': "testing the add",
  //     'serviceDuration': 30,
  //     // 'bookingEnd': DateTime(now.year, now.month, now.day, 18, 0),
  //     // 'bookingStart': DateTime(now.year, now.month, now.day, 8, 0),
  //     'bookingEnd': end.toString(),
  //     'bookingStart': start.toString(),
  //     'chargerId': chargerId,
  //     //serviceId: chargerData['stationId'],
  //     'servicePrice': chargerData['price'],
  //     'userEmail': getEmail(),
  //     'userId': FirebaseAuth.instance.currentUser!.uid,
  //     'userName': getfName().toString() + " " + getlName().toString(),
  //     'userPhoneNumber': getnumber().toString(),
  //     'status': "Reserved"
  //   });
  //   //updateChargerStatus(true);
  // }

  Future addBookData(bookid, start, end, docid) async {
    String? stationId = await getStationId(docid); // Assuming getStationId() returns a Future<String>

    final bookData = {
      'fname': "testing the add",
      'serviceDuration': wa2t,
      'bookingEnd': end.toString(),
      'bookingStart': start.toString(),
      'chargerId': chargerId,
      'servicePrice': chargerData['price'],
      'userEmail': getEmail(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'userName': getfName().toString() + " " + getlName().toString(),
      'userPhoneNumber': getnumber().toString(),
      'status': "Reserved",
      'stationId': stationId,
      'paid': false,
    };

    await FirebaseFirestore.instance.collection('reservations').doc(bookid).set(bookData);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Slot Booked Successfully'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Book Again'),
              ),
              SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyBookingsScreen()),
                  ); // Navigate to the SampleScreen
                },
                child: Text('View Bookings'),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<String?> getStationId(String docid) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('chargers')
          .doc(docid)
          .get();

      if (docSnapshot.exists) {
        // Retrieve the 'stationId' field from the document
        String? stationId = docSnapshot.get('stationId');
        return stationId;
      } else {
        print("Document not found for docid: $docid");
        return null;
      }
    } catch (error) {
      print("Error getting document: $error");
      return null;
    }
  }


  Future<void> updateChargerStatus(bool newStatus) async {
    final collectionRef = FirebaseFirestore.instance.collection('chargers');
    final chargerDocRef = collectionRef.doc(chargerId);

    // Update the 'status' attribute of the charger document
    await chargerDocRef.update({'active': newStatus});
  }

}













// class BookingCalendarDemoApp extends StatefulWidget {
//   const BookingCalendarDemoApp({Key? key}) : super(key: key);
//
//   @override
//   _BookingCalendarDemoAppState createState() => _BookingCalendarDemoAppState();
// }
//
// class _BookingCalendarDemoAppState extends State<BookingCalendarDemoApp> {
//   final now = DateTime.now();
//   late BookingService mockBookingService;
//
//   @override
//   void initState() {
//     super.initState();
//     // DateTime.now().startOfDay
//     // DateTime.now().endOfDay
//     mockBookingService = BookingService(
//         serviceName: 'Mock Service',
//         serviceDuration: 30,
//         bookingEnd: DateTime(now.year, now.month, now.day, 18, 0),
//         bookingStart: DateTime(now.year, now.month, now.day, 8, 0));
//   }
//
//   Stream<dynamic>? getBookingStreamMock(
//       {required DateTime end, required DateTime start}) {
//     return Stream.value([]);
//   }
//
//   Future<dynamic> uploadBookingMock(
//       {required BookingService newBooking}) async {
//     await Future.delayed(const Duration(seconds: 1));
//     converted.add(DateTimeRange(
//         start: newBooking.bookingStart, end: newBooking.bookingEnd));
//     print('${newBooking.toJson()} has been uploaded');
//   }
//
//   List<DateTimeRange> converted = [];
//
//   List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
//     ///here you can parse the streamresult and convert to [List<DateTimeRange>]
//     ///take care this is only mock, so if you add today as disabledDays it will still be visible on the first load
//     ///disabledDays will properly work with real data
//     DateTime first = now;
//     DateTime tomorrow = now.add(Duration(days: 1));
//     DateTime second = now.add(const Duration(minutes: 55));
//     DateTime third = now.subtract(const Duration(minutes: 240));
//     DateTime fourth = now.subtract(const Duration(minutes: 500));
//     converted.add(
//         DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
//     converted.add(DateTimeRange(
//         start: second, end: second.add(const Duration(minutes: 23))));
//     converted.add(DateTimeRange(
//         start: third, end: third.add(const Duration(minutes: 15))));
//     converted.add(DateTimeRange(
//         start: fourth, end: fourth.add(const Duration(minutes: 50))));
//
//     //book whole day example
//     converted.add(DateTimeRange(
//         start: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 5, 0),
//         end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 0)));
//     return converted;
//   }
//
//   List<DateTimeRange> generatePauseSlots() {
//     return [
//       DateTimeRange(
//           start: DateTime(now.year, now.month, now.day, 12, 0),
//           end: DateTime(now.year, now.month, now.day, 13, 0))
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Booking Calendar Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Booking Calendar Demo'),
//           ),
//           body: Center(
//             child: BookingCalendar(
//               bookingService: mockBookingService,
//               convertStreamResultToDateTimeRanges: convertStreamResultMock,
//               getBookingStream: getBookingStreamMock,
//               uploadBooking: uploadBookingMock,
//               pauseSlots: generatePauseSlots(),
//               pauseSlotText: 'LUNCH',
//               hideBreakTime: false,
//               loadingWidget: const Text('Fetching data...'),
//               uploadingWidget: const CircularProgressIndicator(),
//               locale: 'hu_HU',
//               startingDayOfWeek: StartingDayOfWeek.tuesday,
//               wholeDayIsBookedWidget:
//               const Text('Sorry, for this day everything is booked'),
//               //disabledDates: [DateTime(2023, 1, 20)],
//               //disabledDays: [6, 7],
//             ),
//           ),
//         ));
//   }
//
//
//
// }

