import 'package:flutter/material.dart';
import '../models/motorcycle.dart'; // Pastikan path sesuai projectmu

class EncyclopediaDetailPage extends StatelessWidget {
  const EncyclopediaDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Motorcycle data = ModalRoute.of(context)!.settings.arguments as Motorcycle;

    final entries = {
      "Make": data.make,
      "Model": data.model,
      "Year": data.year,
      "Type": data.type,
      "Displacement": data.displacement,
      "Engine": data.engine,
      "Power": data.power,
      "Torque": data.torque,
      "Compression": data.compression,
      "Bore Stroke": data.boreStroke,
      "Valves per Cylinder": data.valvesPerCylinder,
      "Fuel System": data.fuelSystem,
      "Fuel Control": data.fuelControl,
      "Ignition": data.ignition,
      "Lubrication": data.lubrication,
      "Cooling": data.cooling,
      "Gearbox": data.gearbox,
      "Transmission": data.transmission,
      "Clutch": data.clutch,
      "Frame": data.frame,
      "Front Suspension": data.frontSuspension,
      "Front Wheel Travel": data.frontWheelTravel,
      "Rear Suspension": data.rearSuspension,
      "Rear Wheel Travel": data.rearWheelTravel,
      "Front Tire": data.frontTire,
      "Rear Tire": data.rearTire,
      "Front Brakes": data.frontBrakes,
      "Rear Brakes": data.rearBrakes,
      "Total Weight": data.totalWeight,
      "Seat Height": data.seatHeight,
      "Total Height": data.totalHeight,
      "Total Length": data.totalLength,
      "Total Width": data.totalWidth,
      "Ground Clearance": data.groundClearance,
      "Wheelbase": data.wheelbase,
      "Fuel Capacity": data.fuelCapacity,
      "Starter": data.starter,
    };

    return Scaffold(
      appBar: AppBar(title: Text('${data.make} ${data.model}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: entries.entries
              .where((e) => e.value != null && e.value.toString().isNotEmpty)
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130,
                          child: Text(
                            e.key,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(e.value.toString())),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
