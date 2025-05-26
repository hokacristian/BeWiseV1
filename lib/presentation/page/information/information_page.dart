import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  static const String infoPage1 = 'Nutri-Score adalah label gizi yang memudahkan konsumen memilih makanan lebih sehat. Dikembangkan di Prancis, sistem ini menilai nutrisi produk berdasarkan komposisi gizinya.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.asset('assets/img/banner.png'),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  infoPage1,
                  style: const TextStyle(fontSize: 16),
                ),
                
                const SizedBox(height: 24),
                
                // Score cards section
                const Text(
                  'Sistem Penilaian Nutri-Score:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Score A
                _buildScoreInfoCard(
                  score: 'A',
                  backgroundColor: const Color(0xFF74AB83),
                  circleColor: const Color(0xFF5E8B6B),
                  textColor: Colors.white,
                  title: 'Produk yang mendapat skor A adalah pilihan terbaik dari segi nutrisi.',
                  description: 'Biasanya mengandung sedikit kalori, rendah lemak jenuh, sedikit gula, dan sedikit garam.',
                ),

                const SizedBox(height: 12),

                // Score B
                _buildScoreInfoCard(
                  score: 'B',
                  backgroundColor: const Color(0xFFBFD789),
                  circleColor: const Color(0xFF9BC063),
                  textColor: Colors.black87,
                  title: 'Produk dengan skor B masih termasuk sehat, tetapi mungkin mengandung sedikit lebih banyak kalori, gula, atau lemak dibanding produk dengan skor A.',
                ),

                const SizedBox(height: 12),

                // Score C
                _buildScoreInfoCard(
                  score: 'C',
                  backgroundColor: const Color(0xFFFEE272),
                  circleColor: const Color(0xFFF4C430),
                  textColor: Colors.black87,
                  title: 'Produk ini memiliki kandungan yang seimbang antara nutrisi baik dan kurang sehat, seperti kalori atau lemak lebih tinggi.',
                  description: 'Namun tetap kaya serat atau protein yang bermanfaat.',
                ),

                const SizedBox(height: 12),

                // Score D
                _buildScoreInfoCard(
                  score: 'D',
                  backgroundColor: const Color(0xFFF6B971),
                  circleColor: const Color(0xFFE8974F),
                  textColor: Colors.black87,
                  title: 'Produk dengan skor D lebih tinggi kandungan kalorinya dan lebih banyak mengandung gula, lemak jenuh, atau garam.',
                  description: 'Disarankan untuk dikonsumsi dalam jumlah terbatas.',
                ),

                const SizedBox(height: 12),

                // Score E
                _buildScoreInfoCard(
                  score: 'E',
                  backgroundColor: const Color(0xFFF1947A),
                  circleColor: const Color(0xFFE67E52),
                  textColor: Colors.white,
                  title: 'Produk ini memiliki tingkat kalori yang sangat tinggi, banyak lemak jenuh, gula, dan garam.',
                  description: 'Pilihan ini sebaiknya dihindari atau hanya dikonsumsi dalam jumlah sangat kecil.',
                ),

                const SizedBox(height: 24),

                // Additional info section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tips Penggunaan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Gunakan BeWise untuk memindai barcode produk dan mendapatkan informasi nutrisi yang mudah dipahami. Pilih produk dengan skor A atau B untuk pilihan yang lebih sehat.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreInfoCard({
    required String score,
    required Color backgroundColor,
    required Color circleColor,
    required Color textColor,
    required String title,
    String? description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score circle
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                score,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}