class Pickup{
  String id;
  String bin_Id;
  String schedule_Id;
  bool status;
  String sequence;

  Pickup({
    required this.id,
    required this.bin_Id,
    required this.schedule_Id,
    required this.status,
    required this.sequence
  });

  static Pickup fromJson(Map<String, dynamic> json) => Pickup(
      id : json['id'],
      bin_Id: json['bin_Id'],
      schedule_Id: json['schedule_Id'],
      status: json['status'],
      sequence: json['sequence'],
  );

  Map<String, dynamic> toJson() => {
    'id' : id,
    'bin_Id': bin_Id,
    'schedule_Id': schedule_Id,
    'status': status,
    'sequence': sequence,
  };
}