import 'package:n_fintech/Model/configModel.dart';
import 'package:n_fintech/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class ConfigBloc extends BaseBloc<ConfigModel>{
  Observable<ConfigModel> get getResult => fetcher.stream;
  fetchConfigList() async {
    ConfigModel config =  await repository.fetchConfig();
    fetcher.sink.add(config);
  }
}



final configBloc  = ConfigBloc();
