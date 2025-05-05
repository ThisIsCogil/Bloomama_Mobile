import 'package:flutter/material.dart';


class PenyakitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F7),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Disease Information', 
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {

              
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  'Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Diabetes Gestasional',
                  description: 'Dapat menyebabkan bayi terlalu besar, hipoglikemia, dan risiko komplikasi lainnya.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Hepatitis B',
                  description: 'Berisiko tinggi menularkan virus ke janin yang dapat menyebabkan kerusakan hati permanen.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Sifilis',
                  description: 'Penyakit menular seksual yang bisa mengakibatkan keguguran, lahir mati, atau cacat bawaan pada bayi.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'HIV/AIDS',
                  description: 'Dapat ditransmisikan dari ibu ke janin dan menyebabkan kerusakan sistem kekebalan tubuh serta menghambat pertumbuhan janin.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Cytomegalovirus (CMV)',
                  description: 'Virus yang dapat menyebabkan kelainan neurologis, gangguan pendengaran, kebutaan, dan keterlambatan perkembangan pada janin.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Rubella (Campak Jerman)',
                  description: 'Dapat menyebabkan cacat bawaan serius pada janin seperti kerusakan otak, gangguan pendengaran, kebutaan, dan kelainan jantung jika ibu terinfeksi selama kehamilan trimester pertama.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Toksoplasmosis',
                  description: 'Infeksi parasit yang bisa mengakibatkan kerusakan otak, kebutaan, atau kecacatan permanen pada janin. Biasanya ditularkan melalui kontak dengan kotoran kucing atau daging mentah.',
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard({
    required String title,
    required String description,
    
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF11B3CF),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}