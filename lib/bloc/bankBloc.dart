import 'package:n_fintech/Model/bankModel.dart';
import 'package:n_fintech/bloc/base.dart';
import 'package:rxdart/rxdart.dart';

class BankBloc extends BaseBloc<BankModel>{
  Observable<BankModel> get allBank => fetcher.stream;
  fetchBankList() async {
    BankModel bank =  await repository.fetchAllBank();
    fetcher.sink.add(bank);
  }
}


final bankBloc  = BankBloc();
