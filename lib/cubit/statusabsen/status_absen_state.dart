part of 'status_absen_cubit.dart';

@immutable
abstract class StatusAbsenState {}

class StatusAbsenInitial extends StatusAbsenState {}

class StatusAbsenSuccess extends StatusAbsenState {}

class StatusAbsenLoading extends StatusAbsenState {}

class StatusAbsenFailure extends StatusAbsenState {
  final String message;
  StatusAbsenFailure({
    required this.message,
  });
}
