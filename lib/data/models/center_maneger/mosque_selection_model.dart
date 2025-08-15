// lib/data/models/center_manager/mosque_selection_model.dart
import 'package:equatable/equatable.dart';

class MosqueSelectionModel extends Equatable {
  final int id;
  final String name;

  const MosqueSelectionModel({required this.id, required this.name});

  factory MosqueSelectionModel.fromJson(Map<String, dynamic> json) {
    return MosqueSelectionModel(
      id: json['id'],
      name: json['name'] ?? 'اسم غير محدد',
    );
  }

  @override
  List<Object?> get props => [id, name];
}
