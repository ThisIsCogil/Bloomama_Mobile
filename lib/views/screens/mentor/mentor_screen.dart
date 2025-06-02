import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class MentorScreen extends StatefulWidget {
  final ScrollController scrollController;
  
  const MentorScreen({Key? key, required this.scrollController}) : super(key: key);

  @override
  _MentorScreenState createState() => _MentorScreenState();
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class QuickAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final String prompt;
  final Color color;

  QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.prompt,
    required this.color,
  });
}

class _MentorScreenState extends State<MentorScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late GenerativeModel _model;
  late ChatSession _chatSession;
  bool _isLoading = false;
  bool _showQuickActions = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Ganti dengan API key Gemini Anda
  static const String _apiKey = 'AIzaSyDz7aSjnq0SixC3kA4B_2A_5auCzpEzMgE';

  // Kata kunci yang diizinkan untuk topik kesehatan
  final List<String> _allowedKeywords = [
    // Kesehatan ibu hamil
    'hamil', 'kehamilan', 'ibu hamil', 'ibu', 'trimester', 'janin', 'kandungan',
    'prenatal', 'antenatal', 'morning sickness', 'mual', 'muntah',
    'nutrisi', 'makanan', 'vitamin', 'suplemen', 'asam folat',
    'kalsium', 'zat besi', 'protein', 'sayuran', 'buah',
    'olahraga', 'senam hamil', 'yoga', 'berjalan', 'berenang',
    'kontraksi', 'persalinan', 'melahirkan', 'caesar', 'normal',
    'asi', 'menyusui', 'kolostrum', 'laktasi',
    
    // Kesehatan umum
    'kesehatan', 'sehat', 'penyakit', 'gejala', 'demam', 'flu',
    'batuk', 'pilek', 'sakit kepala', 'migrain', 'stress',
    'tekanan darah', 'kolesterol', 'diabetes', 'gula darah',
    'jantung', 'hipertensi', 'diet', 'berat badan',
    'tidur', 'insomnia', 'kelelahan', 'stamina', 'imun',
    'vaksin', 'imunisasi', 'vitamin', 'mineral',
    'obat', 'pengobatan', 'terapi', 'dokter', 'rumah sakit',
    'periksa', 'konsultasi', 'medical', 'medis',
    'pencegahan', 'pola hidup', 'hidup sehat',
    'alergi', 'kulit', 'rash', 'gatal', 'jerawat',
    'mata', 'penglihatan', 'telinga', 'pendengaran',
    'pencernaan', 'maag', 'diare', 'sembelit',
    'otot', 'tulang', 'sendi', 'nyeri', 'sakit',
    'pernapasan', 'asma', 'bronkitis', 'paru',
  ];

  // Quick actions untuk ibu hamil - dikurangi menjadi 4
  final List<QuickAction> _quickActions = [
    QuickAction(
      title: 'Nutrisi Kehamilan',
      subtitle: 'Tips makanan sehat',
      icon: Icons.restaurant_rounded,
      prompt: 'Berikan tips nutrisi dan makanan yang baik untuk ibu hamil trimester pertama',
      color: Color(0xFF11B3CF),
    ),
    QuickAction(
      title: 'Perkembangan Janin',
      subtitle: 'Tahap perkembangan',
      icon: Icons.child_care_rounded,
      prompt: 'Jelaskan perkembangan janin minggu demi minggu pada trimester pertama',
      color: Color(0xFFFF6B6B),
    ),
    QuickAction(
      title: 'Olahraga Hamil',
      subtitle: 'Aktivitas yang aman',
      icon: Icons.fitness_center_rounded,
      prompt: 'Rekomendasi olahraga dan aktivitas fisik yang aman untuk ibu hamil',
      color: Color(0xFF4ECDC4),
    ),
    QuickAction(
      title: 'Keluhan Kehamilan',
      subtitle: 'Mengatasi morning sickness',
      icon: Icons.healing_rounded,
      prompt: 'Bagaimana cara mengatasi mual dan muntah saat hamil muda?',
      color: Color(0xFF95E1D3),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    
    _initializeGemini();
    _addWelcomeMessage();
  }

  void _initializeGemini() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.text(
        "Anda adalah AI Mentor khusus untuk kesehatan ibu hamil dan kesehatan umum. "
        "PENTING: Anda HANYA boleh menjawab pertanyaan yang berkaitan dengan:\n"
        "1. Kesehatan ibu hamil dan kehamilan (nutrisi, perkembangan janin, keluhan kehamilan, olahraga, persalinan, menyusui)\n"
        "2. Kesehatan umum (penyakit, gejala, pencegahan, pola hidup sehat, nutrisi umum, olahraga)\n"
        "3. Konsultasi medis dan kesehatan\n\n"
        "Jika pengguna bertanya tentang topik lain di luar kesehatan ibu hamil dan kesehatan umum, "
        "jelaskan dengan sopan bahwa Anda hanya dapat membantu dengan pertanyaan seputar kesehatan ibu hamil dan kesehatan umum saja.\n\n"
        "Berikan jawaban yang akurat, empatis, dan membantu. "
        "Selalu sarankan konsultasi dengan dokter untuk masalah serius. "
        "Gunakan bahasa Indonesia yang hangat dan mudah dipahami."
      ),
    );
    _chatSession = _model.startChat();
  }

  // Fungsi untuk memeriksa apakah pertanyaan berkaitan dengan kesehatan
  bool _isHealthRelated(String message) {
    String lowerMessage = message.toLowerCase();
    
    // Cek apakah mengandung kata kunci kesehatan
    bool containsHealthKeyword = _allowedKeywords.any((keyword) => 
      lowerMessage.contains(keyword.toLowerCase())
    );
    
    // Kata kunci tambahan yang menunjukkan pertanyaan kesehatan
    List<String> healthIndicators = [
      '?', 'bagaimana', 'apa', 'mengapa', 'kapan', 'dimana',
      'cara', 'tips', 'saran', 'rekomendasi', 'boleh', 'aman',
      'bahaya', 'risiko', 'normal', 'abnormal', 'sehat', 'sakit'
    ];
    
    bool hasHealthIndicator = healthIndicators.any((indicator) => 
      lowerMessage.contains(indicator)
    );
    
    return containsHealthKeyword || (hasHealthIndicator && lowerMessage.length > 10);
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: "👋 Halo! Saya AI Mentor kesehatan ibu hamil dan kesehatan umum. \n\nSaya siap membantu Anda dengan pertanyaan seputar:\n• Kehamilan dan prenatal care\n• Nutrisi ibu hamil dan menyusui\n• Perkembangan bayi dan anak\n• Kesehatan umum dan pencegahan penyakit\n• Tips hidup sehat\n\n⚠️ **Catatan Penting**: Saya hanya dapat menjawab pertanyaan yang berkaitan dengan kesehatan ibu hamil dan kesehatan umum. Untuk topik lain, silakan gunakan platform yang sesuai.\n\nPilih topik di bawah atau tanyakan langsung kepada saya! 💕",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _sendMessage([String? quickPrompt]) async {
    String messageText = quickPrompt ?? _controller.text.trim();
    if (messageText.isEmpty) return;

    // Cek apakah pertanyaan berkaitan dengan kesehatan (kecuali untuk quick prompt)
    if (quickPrompt == null && !_isHealthRelated(messageText)) {
      // Clear controller ONLY after validation for user input
      _controller.clear();

      setState(() {
        _messages.add(ChatMessage(
          text: messageText,
          isUser: true,
          timestamp: DateTime.now(),
        ));
        _messages.add(ChatMessage(
          text: "🩺 Maaf, saya hanya dapat membantu dengan pertanyaan seputar **kesehatan ibu hamil** dan **kesehatan umum**.\n\nSilakan tanyakan tentang:\n• Nutrisi dan makanan sehat untuk ibu hamil\n• Perkembangan janin dan kehamilan\n• Keluhan selama kehamilan\n• Olahraga untuk ibu hamil\n• Kesehatan umum dan pencegahan penyakit\n• Tips hidup sehat\n• Gejala penyakit dan pengobatan\n\nAda yang bisa saya bantu tentang kesehatan? 😊",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _showQuickActions = false;
      });
      _scrollToBottom();
      return;
    }

    // Clear controller only for user input (not quick prompts)
    if (quickPrompt == null) {
      _controller.clear();
    }

    setState(() {
      _messages.add(ChatMessage(
        text: messageText,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
      _showQuickActions = false;
    });

    _scrollToBottom();

    try {
      final response = await _chatSession.sendMessage(
        Content.text(messageText),
      );
      
      setState(() {
        _messages.add(ChatMessage(
          text: response.text ?? "Maaf, saya tidak dapat memberikan respons saat ini.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    } catch (e) {
      String errorMessage = "Maaf, terjadi kesalahan. Silakan coba lagi.";
      
      setState(() {
        _messages.add(ChatMessage(
          text: errorMessage,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients) {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _chatSession = _model.startChat();
      _showQuickActions = true;
    });
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get keyboard height to adjust padding
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return Scaffold(
      backgroundColor: Color(0xFFF8FFFE),
      appBar: _buildModernAppBar(),
      body: Column(
        children: [
          // Gradient divider
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF11B3CF),
                  Color(0xFF4ECDC4),
                ],
              ),
            ),
          ),
          
          // Chat messages area
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  // Quick Actions Section
                  if (_showQuickActions) 
                    _buildQuickActionsSection(),
                  
                  // Welcome Message dan Chat Messages
                  ..._messages.map((message) => _buildMessageBubble(message)).toList(),
                  
                  // Loading indicator
                  if (_isLoading) 
                    _buildLoadingMessage(),
                  
                  // Add extra space when keyboard is visible to prevent last message being hidden
                  if (keyboardHeight > 0)
                    SizedBox(height: 80),
                ],
              ),
            ),
          ),
          
          // Input area with keyboard-aware padding
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16, 
                  16, 
                  16, 
                  16 + (keyboardHeight > 0 ? 0 : 0), // No extra padding needed as SafeArea handles it
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF8FFFE),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Color(0xFF11B3CF).withOpacity(0.2)),
                        ),
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Apa yang bisa dibantu...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                          onTap: () {
                            // Auto scroll to bottom when keyboard appears
                            Future.delayed(Duration(milliseconds: 300), () {
                              _scrollToBottom();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF11B3CF), Color(0xFF4ECDC4)],
                        ),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF11B3CF).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: _isLoading || _controller.text.trim().isEmpty 
                            ? null 
                            : () => _sendMessage(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFF0FDFF),
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          Hero(
            tag: 'mentor-avatar',
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF11B3CF), Color(0xFF4ECDC4)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF11B3CF).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Mentor Kesehatan',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Khusus Ibu Hamil & Kesehatan Umum',
                  style: TextStyle(
                    color: Color(0xFF11B3CF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF11B3CF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.refresh_rounded,
                color: Color(0xFF11B3CF),
                size: 20,
              ),
            ),
            onPressed: _clearChat,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '✨ Topik Kesehatan Populer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _quickActions.length,
              itemBuilder: (context, index) {
                final action = _quickActions[index];
                return _buildQuickActionCard(action, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(QuickAction action, int index) {
    return GestureDetector(
      onTap: () => _sendMessage(action.prompt),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                action.color.withOpacity(0.1),
                action.color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: action.color.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: action.color.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: action.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    action.icon,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                SizedBox(height: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        action.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        action.subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildAvatar(false),
          if (!message.isUser) SizedBox(width: 12),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: message.isUser
                    ? LinearGradient(
                        colors: [Color(0xFF11B3CF), Color(0xFF4ECDC4)],
                      )
                    : null,
                color: message.isUser ? null : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomRight: message.isUser ? Radius.circular(4) : null,
                  bottomLeft: !message.isUser ? Radius.circular(4) : null,
                ),
                boxShadow: [
                  BoxShadow(
                    color: message.isUser 
                        ? Color(0xFF11B3CF).withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  message.isUser
                      ? Text(
                          message.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        )
                      : MarkdownBody(
                          data: message.text,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              height: 1.4,
                            ),
                            strong: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF11B3CF),
                            ),
                          ),
                        ),
                  SizedBox(height: 4),
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white70
                          : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) SizedBox(width: 12),
          if (message.isUser) _buildAvatar(true),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: isUser 
            ? LinearGradient(colors: [Colors.grey[300]!, Colors.grey[400]!])
            : LinearGradient(colors: [Color(0xFF11B3CF), Color(0xFF4ECDC4)]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: (isUser ? Colors.grey[400]! : Color(0xFF11B3CF)).withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isUser ? Icons.person_rounded : Icons.psychology_rounded,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Widget _buildLoadingMessage() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(false),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF11B3CF)),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Mengetik...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}