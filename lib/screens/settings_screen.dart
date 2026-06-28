import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../models/settings_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsModel settings = SettingsModel.defaults();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    settings = await SettingsService.loadSettings();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F6FA),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xff316BFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        "SS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Smart Scanner",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "Premium Edition",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      "Pro",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "APPEARANCE",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _card(
              children: [
                _tile(
                  Icons.dark_mode_outlined,
                  Colors.deepPurple,
                  "Theme",
                  "Light",
                ),
                const Divider(),
                Row(
                  children: [
                    _themeButton(
                      0,
                      "Light",
                      Icons.light_mode,
                    ),
                    _themeButton(
                      1,
                      "Dark",
                      Icons.dark_mode,
                    ),
                    _themeButton(
                      2,
                      "System",
                      Icons.computer,
                    ),
                  ],
                ),
                const Divider(),
                _tile(
                  Icons.language,
                  Colors.blue,
                  "Language",
                  "English",
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "SCANNING",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _card(
              children: [
                _tile(
                  Icons.image,
                  Colors.green,
                  "Image Quality",
                  "High",
                ),
                const Divider(),
                Row(
                  children: [
                    _qualityButton(
                      0,
                      "Standard",
                    ),
                    _qualityButton(
                      1,
                      "High",
                    ),
                    _qualityButton(
                      2,
                      "Ultra",
                    ),
                  ],
                ),
                const Divider(),
                SwitchListTile(
                  value: settings.autoCrop,
                  activeColor: Colors.blue,
                  title: const Text(
                    "Auto Crop",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "Automatically detect edges",
                  ),
                  onChanged: (v) {
                    setState(() {
                      settings = settings.copyWith(
                        autoCrop: v,
                      );
                    });
                    SettingsService.saveSettings(settings);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  value: settings.autoFilter,
                  activeColor: Colors.blue,
                  title: const Text(
                    "Auto Filter",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "AI-powered recommendations",
                  ),
                  onChanged: (v) {
                    setState(() {
                      settings = settings.copyWith(
                        autoFilter: v,
                      );
                    });
                    SettingsService.saveSettings(settings);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "EXPORT",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _card(
              children: [
                _tile(
                  Icons.output,
                  Colors.blue,
                  "Export Quality",
                  "High",
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "ABOUT",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _card(
              children: [
                _tile(
                  Icons.privacy_tip_outlined,
                  Colors.grey,
                  "Privacy Policy",
                  "How we handle your data",
                ),
                const Divider(),
                _tile(
                  Icons.info_outline,
                  Colors.grey,
                  "About Smart Scanner",
                  "Version 1.0.0",
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "Smart Scanner v1.0.0 • Built with precision",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _tile(
    IconData icon,
    Color color,
    String title,
    String subtitle,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(.12),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.chevron_right,
      ),
    );
  }

  Widget _themeButton(
    int index,
    String title,
    IconData icon,
  ) {
    final selected = settings.themeIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            settings = settings.copyWith(
              themeIndex: index,
            );
          });
          SettingsService.saveSettings(settings);
        },
        child: Container(
          height: 82,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qualityButton(
    int index,
    String title,
  ) {
    final selected = settings.imageQuality == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            settings = settings.copyWith(
              imageQuality: index,
            );
          });
          SettingsService.saveSettings(settings);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}