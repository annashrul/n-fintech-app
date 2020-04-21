import 'package:n_fintech/Model/cekTagihanModel.dart';
import 'package:n_fintech/bloc/base.dart';
import 'package:rxdart/rxdart.dart';



class CekTagihanBloc extends BaseBloc<CekTagihanModel> {
  Observable<CekTagihanModel> get getResult => fetcher.stream;
  Future<CekTagihanModel> fetchCekTagihan(String code,String no,String idpelanggan) async =>  await repository.fetchCekTagihan(code, no, idpelanggan);
}
final cekTagihanBloc = CekTagihanBloc();
