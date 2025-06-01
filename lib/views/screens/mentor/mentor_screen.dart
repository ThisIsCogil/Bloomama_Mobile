import 'package:flutter/material.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:login/controllers/auth_controller.dart';

class MentorScreen extends StatefulWidget {
  final ScrollController scrollController;
  const MentorScreen({Key? key, required this.scrollController}) : super(key: key);

  @override
  _MentorScreenState createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  String? ablyApiKey = 'ooLakg.FjeVTg:aQwgKFtS-8JKmogyEl3Hj1iq5jU0An4aMidPJ5_-i0w';
  
  // Berbeda untuk Web dan Mobile
  String? get backendBaseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    } else {
      
      return 'http://192.168.91.233:8000'; 
    }
  }
  
  String? authToken;
  int? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final authController = AuthController();
      final token = await authController.getToken();
      final user = await authController.getUser();

      setState(() {
        authToken = token;
        userId = user?.userId;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (authToken == null || userId == null) return const Center(child: Text('User belum login'));

    return MaterialApp(
      title: 'Flutter Ably Chat',
      home: ChatPage(
        ablyApiKey: ablyApiKey!,
        backendBaseUrl: backendBaseUrl!,
        authToken: authToken!,
        userId: userId!,
        testMode: true, // SELALU TRUE untuk test mode
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String ablyApiKey;
  final String backendBaseUrl;
  final String authToken;
  final int userId;
  final bool testMode;

  ChatPage({
    required this.ablyApiKey,
    required this.backendBaseUrl,
    required this.authToken,
    required this.userId,
    this.testMode = false,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ably.Realtime realtime;
  late ably.RealtimeChannel channel;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  int chatPartnerId = 1;
  bool isConnected = false;
  String connectionStatus = 'Menghubungkan...';
  Timer? connectionTimeout;
  bool isInitializing = false;

  @override
  void initState() {
    super.initState();
    print('🌐 Running on: ${kIsWeb ? "Web Browser" : "Mobile Device"}');
    print('🔗 Backend URL: ${widget.backendBaseUrl}');
    initializeAbly();
  }

  Future<void> initializeAbly() async {
    if (isInitializing) {
      print('⚠️ Already initializing, skipping...');
      return;
    }

    setState(() {
      isInitializing = true;
      connectionStatus = 'Menginisialisasi...';
      isConnected = false;
    });

    try {
      print('🔄 Initializing Ably for ${kIsWeb ? "Web" : "Mobile"}...');
      print('🔑 Using API Key: ${widget.ablyApiKey.substring(0, 10)}...');

      // Cancel any existing timeout
      connectionTimeout?.cancel();
      
      // Set timeout
      connectionTimeout = Timer(Duration(seconds: 30), () {
        if (!isConnected) {
          setState(() {
            connectionStatus = 'Timeout - Cek koneksi internet';
            isConnected = false;
            isInitializing = false;
          });
          print('❌ Connection timeout after 30 seconds');
        }
      });

      // Create Ably client dengan options yang sesuai untuk web
      final clientOptions = ably.ClientOptions.fromKey(widget.ablyApiKey);
      
      // Khusus untuk web browser
      if (kIsWeb) {
        print('🌐 Configuring for web browser...');
        // Tambahkan konfigurasi untuk web jika diperlukan
        clientOptions.logLevel = ably.LogLevel.verbose; // Untuk debugging
      }

      print('🔧 Creating Ably Realtime client...');
      realtime = ably.Realtime(options: clientOptions);
      
      // Listen to all connection state changes
      realtime.connection.on().listen((ably.ConnectionStateChange stateChange) {
        print('🔄 Connection state changed: ${stateChange.previous} -> ${stateChange.current}');
        
        if (mounted) {
          setState(() {
            switch (stateChange.current) {
              case ably.ConnectionState.connecting:
                connectionStatus = 'Menghubungkan ke Ably...';
                break;
              case ably.ConnectionState.connected:
                connectionStatus = 'Terhubung';
                isConnected = true;
                isInitializing = false;
                connectionTimeout?.cancel();
                _setupChannel();
                break;
              case ably.ConnectionState.disconnected:
                connectionStatus = 'Terputus';
                isConnected = false;
                isInitializing = false;
                break;
              case ably.ConnectionState.suspended:
                connectionStatus = 'Koneksi tertunda';
                isConnected = false;
                break;
              case ably.ConnectionState.failed:
                connectionStatus = 'Gagal terhubung';
                isConnected = false;
                isInitializing = false;
                break;
              case ably.ConnectionState.closing:
                connectionStatus = 'Menutup koneksi...';
                isConnected = false;
                break;
              case ably.ConnectionState.closed:
                connectionStatus = 'Koneksi ditutup';
                isConnected = false;
                isInitializing = false;
                break;
              default:
                connectionStatus = 'Status: ${stateChange.current}';
                break;
            }
          });
        }

        // Handle errors
        if (stateChange.reason != null) {
          print('❌ Connection error: ${stateChange.reason}');
        }
      });

      print('✅ Ably client created, waiting for connection...');

    } catch (e, stackTrace) {
      print('❌ Ably initialization error: $e');
      print('Stack trace: $stackTrace');
      
      if (mounted) {
        setState(() {
          connectionStatus = 'Error: ${e.toString()}';
          isConnected = false;
          isInitializing = false;
        });
      }
      
      connectionTimeout?.cancel();
    }
  }

  void _setupChannel() async {
    try {
      final channelName = 'chat.${widget.userId}.$chatPartnerId';
      print('📢 Setting up channel: $channelName');
      
      channel = realtime.channels.get(channelName);

      // Subscribe to messages
      channel.subscribe().listen((ably.Message message) {
        print('📨 Received message: ${message.data}');
        final data = message.data;
        if (data is Map && mounted) {
          setState(() {
            messages.add({
              'sender_id': data['sender_id'],
              'message': data['message'],
              'created_at': data['created_at'] ?? DateTime.now().toIso8601String(),
            });
          });
        }
      });

      print('🎯 Channel subscribed successfully!');

      // Load history jika bukan test mode (tapi untuk web biasanya skip)
      if (!widget.testMode && !kIsWeb) {
        await fetchChatHistory();
      } else {
        print('🧪 Skipping history fetch (Test mode or Web)');
      }

    } catch (e) {
      print('❌ Setup channel error: $e');
    }
  }

  Future<void> fetchChatHistory() async {
    try {
      print('📥 Fetching chat history...');
      setState(() {
        connectionStatus = 'Memuat riwayat...';
      });

      final url = Uri.parse('${widget.backendBaseUrl}/messages/$chatPartnerId');
      print('🔗 History URL: $url');
      
      final response = await http.get(
        url, 
        headers: {
          'Authorization': 'Bearer ${widget.authToken}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10));

      print('📥 History response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            messages = List<Map<String, dynamic>>.from(jsonData['messages']);
          });
        }
        print('✅ Chat history loaded: ${messages.length} messages');
      } else {
        print('❌ Failed to fetch history: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Fetch history error: $e');
      // Jangan ubah connection status jika sudah terhubung ke Ably
    }
  }

  Future<void> sendMessage(String text) async {
    if (!isConnected) {
      print('❌ Cannot send message - not connected');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tidak terhubung ke server'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final now = DateTime.now().toIso8601String();

    final messageData = {
      'sender_id': widget.userId,
      'receiver_id': chatPartnerId,
      'message': text,
      'created_at': now,
    };

    try {
      print('📤 Sending message: $text');
      
      // Selalu gunakan test mode untuk web
      if (widget.testMode || kIsWeb) {
        print('🧪 Sending via Ably directly...');
        
        // Publish ke Ably
        await channel.publish(data: messageData);
        print('✅ Message published to Ably');
        
        // Tambah ke local messages
        if (mounted) {
          setState(() {
            messages.add(messageData);
          });
          _controller.clear();
        }
        
        print('🎉 Message sent successfully!');
        return;
      }

      // Mode normal (dengan backend) - jarang digunakan di web karena CORS
      print('🌐 Sending via backend...');
      final url = Uri.parse('${widget.backendBaseUrl}/messages/send');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.authToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'receiver_id': chatPartnerId,
          'message': text,
        }),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        await channel.publish(data: messageData);
        if (mounted) {
          setState(() {
            messages.add(messageData);
          });
          _controller.clear();
        }
        print('✅ Message sent via backend');
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
      
    } catch (e) {
      print('❌ Send message error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void retryConnection() {
    print('🔄 Retrying connection...');
    
    // Close existing connection
    try {
      realtime.close();
    } catch (e) {
      print('Warning: Error closing connection: $e');
    }
    
    // Reset state
    setState(() {
      isConnected = false;
      isInitializing = false;
      connectionStatus = 'Mencoba lagi...';
    });
    
    // Wait a bit then retry
    Timer(Duration(seconds: 1), () {
      initializeAbly();
    });
  }

  @override
  void dispose() {
    print('🧹 Disposing chat page...');
    connectionTimeout?.cancel();
    try {
      if (isConnected) {
        channel.detach();
      }
      realtime.close();
    } catch (e) {
      print('❌ Dispose error: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chat dengan Bidan'),
            if (kIsWeb)
              Text(
                'Web Browser Mode',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        backgroundColor: isConnected ? Colors.green : Colors.red,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isConnected ? '🟢 Online' : '🔴 Offline',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  if (!isConnected)
                    Text(
                      connectionStatus,
                      style: TextStyle(color: Colors.white70, fontSize: 9),
                    ),
                ],
              ),
            ),
          ),
          if (!isConnected && !isInitializing)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: retryConnection,
              tooltip: 'Coba lagi',
            ),
        ],
      ),
      body: Column(
        children: [
          // Status Banner
          if (!isConnected)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: Colors.red[100],
              child: Row(
                children: [
                  if (isInitializing)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(Icons.error_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      connectionStatus,
                      style: TextStyle(color: Colors.red[800]),
                    ),
                  ),
                  if (!isInitializing)
                    TextButton(
                      onPressed: retryConnection,
                      child: Text('Coba Lagi'),
                    ),
                ],
              ),
            ),

          // Test Mode Banner
          if (widget.testMode)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              color: Colors.orange[100],
              child: Text(
                '🧪 TEST MODE - Direct to Ably ${kIsWeb ? "(Web)" : "(Mobile)"}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // Chat Messages
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            isConnected 
                                ? 'Belum ada pesan\nMulai percakapan!' 
                                : 'Menunggu koneksi...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      padding: EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final msg = messages[messages.length - 1 - index];
                        final isMe = msg['sender_id'] == widget.userId;
                        
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7
                              ),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.blueAccent : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg['message'],
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _formatTime(msg['created_at'] ?? ''),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isMe ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Message Input
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: isConnected,
                    decoration: InputDecoration(
                      hintText: isConnected ? 'Ketik pesan...' : connectionStatus,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      fillColor: Colors.grey[50],
                      filled: true,
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty && isConnected) {
                        sendMessage(text.trim());
                      }
                    },
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: isConnected ? Colors.blueAccent : Colors.grey,
                  onPressed: isConnected ? () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      sendMessage(text);
                    }
                  } : null,
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(date.year, date.month, date.day);
      
      if (messageDate == today) {
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else {
        return '${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return '';
    }
  }
}