import 'package:events_planning/serviceinfo.dart';

class ServerInfo {
  const ServerInfo({required this.name, required this.services});

  final String name;

  final List<ServiceInfo> services;

  factory ServerInfo.fromJson(Map<String, dynamic> json) {
    return ServerInfo(
        name: json['name'],
        services: (json['services'] as List)
            .map((p) => ServiceInfo.fromJson(p))
            .toList());
  }
  bool running() {
    bool ok = services.isNotEmpty;
    for (ServiceInfo service in services) {
      if (!service.running) {
        ok = false;
      }
    }

    return ok;
  }

  bool notAvailable() {
    return services.isEmpty;
  }
}