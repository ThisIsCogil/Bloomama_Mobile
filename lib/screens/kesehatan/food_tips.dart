import 'package:flutter/material.dart';


class FoodScreen extends StatelessWidget {
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
          'Foods Tips', 
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
                    title:'Bulan 1',
                  description: 'Asam folat (400-800 mcg/hari): Penting untuk perkembangan sistem saraf janin.Sumber makanan: Bayam, alpukat, jeruk, brokoli.Protein (75 gram/hari): Membantu pembentukan sel-sel tubuh janin.Sumber makanan: Telur, daging tanpa lemak, kacang-kacangan, tahu/tempe.Vitamin B6: Mengatasi mual pada awal kehamilan.Sumber makanan: Pisang, alpukat, ayam.Zat Besi: Mencegah anemia.Sumber makanan: Bayam, daging merah, hati ayam.Air putih: 8-10 gelas sehari.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Bulan 2',
                  description: 'Asam folat: Masih dibutuhkan dalam jumlah tinggi. Protein: Mendukung pertumbuhan embrio. Vitamin C: Meningkatkan daya tahan tubuh. Sumber makanan: Jeruk, stroberi, paprika. Kalsium: Membantu perkembangan tulang dan gigi janin. Sumber makanan: Susu, keju, yogurt, ikan teri. Serat: Mencegah sembelit. Sumber makanan: Sayuran hijau, buah-buahan, gandum utuh.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Bulan 3',
                  description: 'Asam folat: Penting untuk perkembangan otak janin.Zat besi: Volume darah meningkat sehingga ibu perlu lebih banyak zat besi.Vitamin D: Membantu penyerapan kalsium. Sumber makanan: Ikan salmon, telur, susu fortifikasi.Omega-3 & DHA: Penting untuk perkembangan otak janin. Sumber makanan: Ikan tuna, ikan kembung, kenari.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Bulan 4',
                  description: 'Karbohidrat kompleks: Sebagai sumber energi utama. Sumber makanan: Nasi merah, oatmeal, ubi, jagung. Protein & zat besi: Mendukung pertumbuhan plasenta. Kalsium: Mendukung pembentukan tulang janin. Serat: Mencegah sembelit.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Bulan 5',
                  description: 'Vitamin A: Mendukung perkembangan mata janin. Sumber makanan: Wortel, ubi, pepaya. Magnesium: Membantu pertumbuhan otot janin. Sumber makanan: Kacang almond, bayam, pisang.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Bulan 6',
                  description: 'Protein & lemak sehat: Mendukung perkembangan otak bayi.Zat besi: Mengurangi risiko anemia.Serat & cairan: Mencegah sembelit.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Bulan 7',
                  description: 'DHA & Omega-3: Meningkatkan kecerdasan janin.Vitamin C & zat besi: Mendukung sistem imun ibu dan janin.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Bulan 8',
                  description: 'Karbohidrat & protein: Menambah energi untuk persiapan persalinan.Kalsium: Memperkuat tulang janin.Serat & cairan: Mencegah sembelit.',
                ),
                SizedBox(height: 16),
                _buildTestCard(
                  title: 'Bulan 9',
                  description: 'Energi tinggi & protein: Persiapan untuk persalinan.Vitamin K: Membantu pembekuan darah saat persalinan.Sumber makanan: Bayam, brokoli, hati ayam.',
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