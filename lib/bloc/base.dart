import 'package:n_fintech/Model/base_model.dart';
import 'package:n_fintech/resources/repository.dart';
import 'package:rxdart/rxdart.dart';


abstract class BaseBloc<T extends BaseModel> {
  final repository = Repository();
  final fetcher = PublishSubject<T>();

  dispose() {
    fetcher.close();
  }
}