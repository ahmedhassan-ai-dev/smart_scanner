class SettingsModel {
  final int themeIndex;
  final int imageQuality;
  final int exportQuality;

  final bool autoCrop;
  final bool autoFilter;

  const SettingsModel({
    required this.themeIndex,
    required this.imageQuality,
    required this.exportQuality,
    required this.autoCrop,
    required this.autoFilter,
  });

  factory SettingsModel.defaults() {
    return const SettingsModel(
      themeIndex: 0,
      imageQuality: 1, // High
      exportQuality: 1, // High
      autoCrop: true,
      autoFilter: true,
    );
  }

  SettingsModel copyWith({
    int? themeIndex,
    int? imageQuality,
    int? exportQuality,
    bool? autoCrop,
    bool? autoFilter,
  }) {
    return SettingsModel(
      themeIndex: themeIndex ?? this.themeIndex,
      imageQuality: imageQuality ?? this.imageQuality,
      exportQuality: exportQuality ?? this.exportQuality,
      autoCrop: autoCrop ?? this.autoCrop,
      autoFilter: autoFilter ?? this.autoFilter,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'themeIndex': themeIndex,
      'imageQuality': imageQuality,
      'exportQuality': exportQuality,
      'autoCrop': autoCrop,
      'autoFilter': autoFilter,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      themeIndex: map['themeIndex'] ?? 0,
      imageQuality: map['imageQuality'] ?? 1,
      exportQuality: map['exportQuality'] ?? 1,
      autoCrop: map['autoCrop'] ?? true,
      autoFilter: map['autoFilter'] ?? true,
    );
  }
}