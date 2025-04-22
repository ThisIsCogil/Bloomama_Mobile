import 'package:flutter/material.dart';

class MentorScreen extends StatefulWidget {
  final ScrollController scrollController;
  
  const MentorScreen({Key? key, required this.scrollController}) : super(key: key);
  
  @override
  _MentorScreenState createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  final List<Mentor> mentors = [
    Mentor(name: "Dr. Rahmat Hariadi", location: "RS Jember Klinik", rating: 4, image: "assets/mentor1.jpg"),
    Mentor(name: "Dr. Retno Astuti", location: "RS Lavalette", rating: 5, image: "assets/mentor2.jpg"),
    Mentor(name: "Dr. Budi", location: "Klinik Suherman", rating: 5, image: "assets/mentor3.jpg"),
  ];

  final List<String> locations = ["Semua", "Rs. Jember", "Rs. Kaliwates", "RS CitraHusada", "Klinik Soebandi"];
  String selectedLocation = "Semua";

  @override
  Widget build(BuildContext context) {
    List<Mentor> filteredMentors = selectedLocation == "Semua"
        ? mentors
        : mentors.where((mentor) => mentor.location.toLowerCase() == selectedLocation.toLowerCase()).toList();
        
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F7),
      appBar: AppBar(
        title: Text("Mentor", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar + Hamburger Icon
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari nama bidan",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Filter Lokasi
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: locations.map((location) {
                  bool isSelected = location == selectedLocation;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(location),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedLocation = location;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: Colors.blue.shade100, // Warna biru saat dipilih
                      labelStyle: TextStyle(color: isSelected ? Colors.blue : Colors.black),
                      side: BorderSide(color: Colors.blue),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10),

            // Rekomendasi Bidan
            Text("Rekomendasi Bidan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Konsultasi online dengan bidan kami", style: TextStyle(fontSize:14, fontWeight: FontWeight.normal),),
            SizedBox(height: 10),

            // List Mentor/Bidan - Using the passed ScrollController
            Expanded(
              child: ListView.builder(
                controller: widget.scrollController, // Use the controller from MainScreen
                itemCount: filteredMentors.length,
                itemBuilder: (context, index) {
                  return MentorCard(mentor: filteredMentors[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model Mentor/Bidan
class Mentor {
  final String name;
  final String location;
  final int rating;
  final String image;

  Mentor({required this.name, required this.location, required this.rating, required this.image});
}

// Widget Card untuk Menampilkan Bidan
class MentorCard extends StatelessWidget {
  final Mentor mentor;

  const MentorCard({Key? key, required this.mentor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MentorDetailScreen(mentor: mentor)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(mentor.image),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mentor.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(mentor.location, style: TextStyle(color: Colors.grey)),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < mentor.rating ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen(mentor: mentor)),
                  );
                },
                child: Text("Chat"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Detail Bidan
class MentorDetailScreen extends StatelessWidget {
  final Mentor mentor;

  const MentorDetailScreen({Key? key, required this.mentor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mentor.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(mentor.image),
              ),
              SizedBox(height: 20),
              Text(
                mentor.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                mentor.location,
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Rating: ${mentor.rating} ⭐",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen(mentor: mentor)),
                  );
                },
                child: Text("Hubungi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Chat
class ChatScreen extends StatelessWidget {
  final Mentor mentor;

  const ChatScreen({Key? key, required this.mentor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mentor.name),
        actions: [
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Halo, ada yang bisa saya bantu?"),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Helo Dawg, Selamat Siang?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Tulis pesan...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}