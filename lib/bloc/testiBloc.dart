import 'package:n_fintech/Model/tertimoniModel.dart';
import 'package:n_fintech/bloc/base.dart';

import 'package:rxdart/rxdart.dart';

class TestiBloc extends BaseBloc<TestimoniModel>{
//  Observable<TestimoniModel> get allTesti => fetcher.stream;
//
//  fetchTesti(var param,var page, var limit) async {
//    TestimoniModel promosi =  await repository.fetchTesti(param,page,limit);
//    fetcher.sink.add(promosi);
//  }
  bool _isDisposed = false;
  final PublishSubject<TestimoniModel> _serviceController = new PublishSubject<TestimoniModel>();
  Observable<TestimoniModel> get getResult => _serviceController.stream;
  fetchTesti(var param,var page, var limit) async {
    if(_isDisposed) {
      print('false');
    }else{
      TestimoniModel news =  await repository.fetchTesti(param,page,limit);
      _serviceController.sink.add(news);
    }
  }
  void dispose() {
    _serviceController.close();
    _isDisposed = true;
  }
}

final testiBloc = TestiBloc();