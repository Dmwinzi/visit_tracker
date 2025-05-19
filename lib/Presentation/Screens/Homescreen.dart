import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../Utils/StatusIndicator.dart';
import '../Viewmodels/VisitViewmodel.dart';
import '../Widgets/Dashboardcard.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  final visitController = Get.put(VisitController());

  @override
  void initState() {
    super.initState();
    visitController.loadVisits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light background
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366), // Dark blue from logo
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ClipOval(
              child: Image.asset(
                "assets/Images/man.jpg", // Use your asset
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Obx(() {
          if (visitController.isLoading.value) {
            return const Center(child: CircularProgressIndicator(
              color: Colors.amberAccent,
            ));
          }

          if (visitController.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                "Error: ${visitController.errorMessage.value}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final visits = visitController.filteredVisits;
          visits.sort((a, b) => a.visitDate.compareTo(b.visitDate));

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(padding: EdgeInsets.only(left: 10,top: 10),
                   child: Text(
                     'Hello, Agent!',
                     style: TextStyle(
                       fontSize: 24,
                       fontWeight: FontWeight.bold,
                       color: Color(0xFF003366),
                     ),
                   ),
                 ),
                const SizedBox(height: 20),
                // Search Bar
                Container(
                  margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
                  child: TextField(
                    onChanged: (value) => visitController.searchQuery.value = value,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10,right: 10),child: Row(
                  children: [
                    DashboardCard(
                      title: 'Completed Visits',
                      value: visits
                          .where((v) => v.status == 'Completed')
                          .length
                          .toString(),
                      percentage: '',
                      isPositive: true,
                    ),
                    const SizedBox(width: 16),
                    DashboardCard(
                      title: 'Pending Visits',
                      value: visits
                          .where((v) => v.status == 'Pending')
                          .length
                          .toString(),
                      percentage: '',
                      isPositive: false,
                    ),
                  ],
                )),
                const SizedBox(height: 20),
                Padding(padding:EdgeInsets.only(left: 10),
                   child: Text(
                     'Upcoming Visits',
                     style: TextStyle(
                       fontSize: 20,
                       fontWeight: FontWeight.bold,
                       color: Color(0xFF003366), // Dark blue
                     ),
                   ),
                ),
                const SizedBox(height: 12),
                if (visits.isEmpty)
                  const Text(
                    "No upcoming visits.",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  ListView.builder(
                    itemCount: visits.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final visit = visits[index];
                      return Padding(padding: EdgeInsets.only(left: 10,right: 10),
                         child: Container(
                           margin: const EdgeInsets.symmetric(vertical: 8),
                           padding: const EdgeInsets.all(20),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(12),
                             color: Colors.white,
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.black.withOpacity(0.1),
                                 spreadRadius: 1,
                                 blurRadius: 5,
                                 offset: const Offset(0, 2),
                               ),
                             ],
                           ),
                           child: Row(
                             children: [
                               Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(
                                       "Visit to Customer ID: ${visit.customerId}",
                                       style: const TextStyle(
                                         fontSize: 18,
                                         fontWeight: FontWeight.bold,
                                         color: Color(
                                             0xFF003366),
                                       ),
                                     ),
                                     const SizedBox(height: 8),
                                     Text(
                                       '${DateFormat.yMMMMd().format(visit.visitDate.toLocal())}',
                                       style: const TextStyle(
                                         fontSize: 14,
                                         color: Colors.grey,
                                       ),
                                     ),
                                     const SizedBox(height: 8),
                                     Text(
                                       "${visit.location}",
                                       style: const TextStyle(
                                         fontSize: 14,
                                         color: Colors.grey,
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                               StatusIndicator(status: visit.status,),
                             ],
                           ),
                         ),
                      );
                    },
                  ),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/addVisit');
        },
        backgroundColor: const Color(0xFF003366),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

}


