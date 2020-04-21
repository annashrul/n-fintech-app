import 'package:n_fintech/Model/plnModel.dart';
import 'package:n_fintech/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class PlnBloc extends BaseBloc<PlnModel>{
  Observable<PlnModel> get allPln => fetcher.stream;
  fetchPlnList() async {
    PlnModel pln =  await repository.fetchPln();
    fetcher.sink.add(pln);
  }
}

final plnBloc  = PlnBloc();
