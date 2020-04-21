import 'dart:async';

import 'package:n_fintech/Model/saldoUIModel.dart';
import 'package:n_fintech/bloc/base.dart';
import 'package:rxdart/rxdart.dart';


class SaldoDeposit extends BaseBloc<SaldoResponse> {

  Observable<SaldoResponse> get getResult => fetcher.stream;

  Future<SaldoResponse> fetchSaldo(String saldo, String pin) async =>  await repository.fetchSaldo(saldo, pin);

}

final saldoDepositBloc = SaldoDeposit();
