import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF11B3CF);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Pusat Bantuan',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                
                // Header
                Text(
                  "Butuh Bantuan?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                
                Text(
                  "Jika Anda mengalami masalah atau memiliki pertanyaan, jangan ragu untuk menghubungi tim dukungan kami melalui kontak di bawah ini:",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                
                SizedBox(height: 28),
                
                // Contact Cards
                _buildContactCard(
                  context,
                  icon: Icons.email_outlined,
                  title: "Email",
                  content: "support@example.com",
                  color: primaryColor,
                ),
                
                SizedBox(height: 16),
                
                _buildContactCard(
                  context,
                  icon: Icons.phone_outlined,
                  title: "Telepon",
                  content: "+62 812-3456-7890",
                  color: primaryColor,
                ),
                
                SizedBox(height: 32),
                
                // FAQ Section
                Text(
                  "Pertanyaan Umum",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                
                SizedBox(height: 16),
                
                _buildFaqItem(
                  context,
                  question: "Bagaimana cara mengubah password?",
                  answer: "Anda dapat mengubah password melalui menu Profil > Keamanan Akun > Ubah Kata Sandi.",
                  color: primaryColor,
                ),
                
                _buildFaqItem(
                  context,
                  question: "Bagaimana cara melihat notifikasi?",
                  answer: "Anda dapat melihat notifikasi melalui menu Dashboard > Ikon Notifikasi.",
                  color: primaryColor,
                ),
                
                 _buildFaqItem(
                  context,
                  question: "Bagaimana cara mengetahui daftar event yang ada?",
                  answer: "Anda dapat melihat event yang tersedia untuk ibu hamil melalui menu Dashboard > Ikon Kalender.",
                  color: primaryColor,
                ), 
                
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFaqItem(
    BuildContext context, {
    required String question,
    required String answer,
    required Color color,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        iconColor: color,
        collapsedIconColor: Colors.grey,
        childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}