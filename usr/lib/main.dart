import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const UndercoverBillionaireApp());
}

class UndercoverBillionaireApp extends StatelessWidget {
  const UndercoverBillionaireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Undercover Terminal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF2A2A),
          secondary: Color(0xFF2A2AFF),
          surface: Color(0xFF1A1A1A),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Courier', color: Colors.white70),
          titleLarge: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TerminalScreen(),
      },
    );
  }
}

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final List<String> _logs = [];
  Timer? _timer;
  final Random _random = Random();
  final ScrollController _scrollController = ScrollController();

  final List<String> _suspiciousAccounts = [
    'OFFSHORE_ACC_992',
    'CAYMAN_SHELL_04',
    'GHOST_ENTITY_11',
    'PROXY_FUND_88X',
    'EXECUTIVE_SLUSH'
  ];

  @override
  void initState() {
    super.initState();
    _generateLog();
    _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      _generateLog();
    });
  }

  void _generateLog() {
    final account = _suspiciousAccounts[_random.nextInt(_suspiciousAccounts.length)];
    final amount = (_random.nextDouble() * 1000000).toStringAsFixed(2);
    final isFraudulent = _random.nextDouble() > 0.4;
    
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final action = isFraudulent ? 'ERR_UNAUTHORIZED_TRANSFER' : 'SYS_HEARTBEAT_OK';
    
    setState(() {
      _logs.add('[$timestamp] $action - $account - \$$amount');
      if (_logs.length > 50) {
        _logs.removeAt(0);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'CORP_INTRANET // SYS_ACCESS',
          style: TextStyle(color: Color(0xFFFF2A2A), letterSpacing: 2),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                'ID: T. STARK (TEMP)',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop) _buildSidebar(),
            Expanded(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: const Color(0xFFFF2A2A).withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF2A2A).withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          final log = _logs[index];
                          final isError = log.contains('ERR_');
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              log,
                              style: TextStyle(
                                color: isError ? const Color(0xFFFF2A2A) : Colors.green.shade400,
                                fontWeight: isError ? FontWeight.bold : FontWeight.normal,
                                shadows: isError
                                    ? [
                                        const Shadow(
                                          color: Color(0xFFFF2A2A),
                                          blurRadius: 4,
                                        )
                                      ]
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  _buildControlPanel(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MODULES',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 24),
          _sidebarItem(Icons.security, 'Security Audit', true),
          _sidebarItem(Icons.account_balance, 'Ledger Scan', false),
          _sidebarItem(Icons.fingerprint, 'Identity Mask', false),
          const Spacer(),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          const Text(
            'WARNING: SURVEILLANCE ACTIVE',
            style: TextStyle(color: Color(0xFFFF2A2A), fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: isActive ? const Color(0xFFFF2A2A) : Colors.grey, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MONITORING: EXECUTIVE TRANSACTIONS',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'Bypassing firewall...',
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFF2A2A).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFFF2A2A)),
            ),
            child: const Text(
              'LIVE',
              style: TextStyle(color: Color(0xFFFF2A2A), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color(0xFF111111),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter override command...',
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  prefixIcon: const Icon(Icons.terminal, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF2A2A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: const Text('EXECUTE'),
            ),
          ],
        ),
      ),
    );
  }
}
