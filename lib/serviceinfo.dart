class ServiceInfo {
  const ServiceInfo({required this.name, required this.running});

  final String name;

  final bool running;

  String status() {
    if (running) {
      return "running";
    }
    return "stopped";
  }

  factory ServiceInfo.fromJson(Map<String, dynamic> json) {
    return ServiceInfo(name: json['name'], running: json['running']);
  }
}