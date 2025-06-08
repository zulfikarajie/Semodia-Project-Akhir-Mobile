class Motorcycle {
  final String make;
  final String model;
  final String year;
  final String type;
  final String displacement;
  final String engine;
  final String power;
  final String torque;
  final String compression;
  final String boreStroke;
  final String valvesPerCylinder;
  final String fuelSystem;
  final String fuelControl;
  final String ignition;
  final String lubrication;
  final String cooling;
  final String gearbox;
  final String transmission;
  final String clutch;
  final String frame;
  final String frontSuspension;
  final String frontWheelTravel;
  final String rearSuspension;
  final String rearWheelTravel;
  final String frontTire;
  final String rearTire;
  final String frontBrakes;
  final String rearBrakes;
  final String totalWeight;
  final String seatHeight;
  final String totalHeight;
  final String totalLength;
  final String totalWidth;
  final String groundClearance;
  final String wheelbase;
  final String fuelCapacity;
  final String starter;

  Motorcycle({
    required this.make,
    required this.model,
    required this.year,
    required this.type,
    required this.displacement,
    required this.engine,
    required this.power,
    required this.torque,
    required this.compression,
    required this.boreStroke,
    required this.valvesPerCylinder,
    required this.fuelSystem,
    required this.fuelControl,
    required this.ignition,
    required this.lubrication,
    required this.cooling,
    required this.gearbox,
    required this.transmission,
    required this.clutch,
    required this.frame,
    required this.frontSuspension,
    required this.frontWheelTravel,
    required this.rearSuspension,
    required this.rearWheelTravel,
    required this.frontTire,
    required this.rearTire,
    required this.frontBrakes,
    required this.rearBrakes,
    required this.totalWeight,
    required this.seatHeight,
    required this.totalHeight,
    required this.totalLength,
    required this.totalWidth,
    required this.groundClearance,
    required this.wheelbase,
    required this.fuelCapacity,
    required this.starter,
  });

  factory Motorcycle.fromJson(Map<String, dynamic> json) => Motorcycle(
    make: json['make'] ?? '',
    model: json['model'] ?? '',
    year: json['year'] ?? '',
    type: json['type'] ?? '',
    displacement: json['displacement'] ?? '',
    engine: json['engine'] ?? '',
    power: json['power'] ?? '',
    torque: json['torque'] ?? '',
    compression: json['compression'] ?? '',
    boreStroke: json['bore_stroke'] ?? '',
    valvesPerCylinder: json['valves_per_cylinder']?.toString() ?? '',
    fuelSystem: json['fuel_system'] ?? '',
    fuelControl: json['fuel_control'] ?? '',
    ignition: json['ignition'] ?? '',
    lubrication: json['lubrication'] ?? '',
    cooling: json['cooling'] ?? '',
    gearbox: json['gearbox'] ?? '',
    transmission: json['transmission'] ?? '',
    clutch: json['clutch'] ?? '',
    frame: json['frame'] ?? '',
    frontSuspension: json['front_suspension'] ?? '',
    frontWheelTravel: json['front_wheel_travel'] ?? '',
    rearSuspension: json['rear_suspension'] ?? '',
    rearWheelTravel: json['rear_wheel_travel'] ?? '',
    frontTire: json['front_tire'] ?? '',
    rearTire: json['rear_tire'] ?? '',
    frontBrakes: json['front_brakes'] ?? '',
    rearBrakes: json['rear_brakes'] ?? '',
    totalWeight: json['total_weight'] ?? '',
    seatHeight: json['seat_height'] ?? '',
    totalHeight: json['total_height'] ?? '',
    totalLength: json['total_length'] ?? '',
    totalWidth: json['total_width'] ?? '',
    groundClearance: json['ground_clearance'] ?? '',
    wheelbase: json['wheelbase'] ?? '',
    fuelCapacity: json['fuel_capacity'] ?? '',
    starter: json['starter'] ?? '',
  );
}
