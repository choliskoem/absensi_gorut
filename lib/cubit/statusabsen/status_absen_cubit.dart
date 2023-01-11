
import 'package:absensi/models/status_absen/status_absen_model.dart';
import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

import '../../models/status_absen/status_absen_body.dart';
import '../../services/status_absen/status_absen_service.dart';

part 'status_absen_state.dart';

class StatusAbsenCubit extends Cubit<StatusAbsenState> {
  StatusAbsenCubit() : super(StatusAbsenInitial());

  final box = GetStorage();

  Future<StatusAbsenModel?> status(StatusAbsenBody body) async {
    StatusAbsenBody body = StatusAbsenBody(nik: box.read('nik'));
    final data = await StatusAbsenService.absen(body);



    if (data.status == 200) {
       return data;

    } else {
      emit(StatusAbsenFailure(message: 'error'));
    }
  }

}
