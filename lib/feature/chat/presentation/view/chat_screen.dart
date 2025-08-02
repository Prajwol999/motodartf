import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motofix_app/app/constant/api_endpoints.dart'; // Using your app's endpoints
import 'package:motofix_app/core/common/app_colors.dart'; // Using your app's theme

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add an initial welcome message from the bot
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages.add({
          'sender': 'bot',
          'text': 'Hello! How can I assist you with MotoFix services today?'
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    // A short delay ensures the list has time to update before scrolling
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': message});
      _isLoading = true;
    });
    _scrollToBottom();
    _controller.clear();

    // Use the constant from ApiEndpoints
    final backendUrl = ApiEndpoints.baseUrl + ApiEndpoints.chat;

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      ).timeout(ApiEndpoints.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _messages.add({'sender': 'bot', 'text': data['response']});
        });
      } else {
        _addErrorResponse();
      }
    } catch (e) {
      _addErrorResponse();
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _addErrorResponse() {
    setState(() {
      _messages.add({
        'sender': 'bot',
        'text': 'Sorry, I am having trouble connecting. Please try again.'
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBlack,
      appBar: AppBar(
        title: const Text('AI Support'),
        backgroundColor: AppColors.neutralDark,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 18),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.brandPrimary
                          : AppColors.neutralDarkGrey,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      message['text']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.brandPrimary),
                ),
              ),
            ),
          _buildChatInputField(),
        ],
      ),
    );
  }

  Widget _buildChatInputField() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: AppColors.neutralDark,
        border: Border(
          top: BorderSide(color: AppColors.neutralLightGrey, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Ask me anything...',
                  hintStyle:
                      const TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.neutralBlack,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            // --- FIX ---
            // Replaced ElevatedButton with a Container and IconButton
            // to solve the layout crash.
            Container(
              decoration: const BoxDecoration(
                color: AppColors.brandPrimary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 24),
                onPressed: _sendMessage,
                tooltip: 'Send message',
              ),
            )
            // --- END OF FIX ---
          ],
        ),
      ),
    );
  }
}