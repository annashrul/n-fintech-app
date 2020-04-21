import 'dart:async';

import 'package:n_fintech/Model/MLM/detailHistoryPembelianSuplemen.dart';
import 'package:n_fintech/Model/MLM/listCartModel.dart';
import 'package:n_fintech/Model/PPOB/PPOBPascaModel.dart';
import 'package:n_fintech/Model/PPOB/PPOBPraModel.dart';
import 'package:n_fintech/Model/address/getAddressModel.dart';
import 'package:n_fintech/Model/address/getListAddressModel.dart';
import 'package:n_fintech/Model/authModel.dart';
import 'package:n_fintech/Model/bankModel.dart';
import 'package:n_fintech/Model/categoryModel.dart';
import 'package:n_fintech/Model/cekTagihanModel.dart';
import 'package:n_fintech/Model/depositManual/detailDepositModel.dart';
import 'package:n_fintech/Model/depositManual/historyDepositModel.dart';
import 'package:n_fintech/Model/depositManual/listAvailableBank.dart';
import 'package:n_fintech/Model/detailNewsPerCategoryModel.dart';
import 'package:n_fintech/Model/downlineModel.dart';
import 'package:n_fintech/Model/generalInsertId.dart';
import 'package:n_fintech/Model/generalModel.dart';
import 'package:n_fintech/Model/historyModel.dart';
import 'package:n_fintech/Model/historyPPOBModel.dart';
import 'package:n_fintech/Model/historyPembelianSuplemen.dart';
import 'package:n_fintech/Model/historyPembelianTanahModel.dart';
import 'package:n_fintech/Model/historyPenarikanModel.dart';
import 'package:n_fintech/Model/inspirationModel.dart';
import 'package:n_fintech/Model/islamic/ayatModel.dart';
import 'package:n_fintech/Model/islamic/categoryDoaModel.dart';
import 'package:n_fintech/Model/islamic/checkedModel.dart';
import 'package:n_fintech/Model/islamic/doaModel.dart';
import 'package:n_fintech/Model/islamic/imsakiyahModel.dart';
import 'package:n_fintech/Model/islamic/kalenderHijriahModel.dart';
import 'package:n_fintech/Model/islamic/nearbyMosqueModel.dart';
import 'package:n_fintech/Model/islamic/subCategoryDoaModel.dart';
import 'package:n_fintech/Model/kecamatanModel.dart';
import 'package:n_fintech/Model/kotaModel.dart';
import 'package:n_fintech/Model/myBankModel.dart';
import 'package:n_fintech/Model/newsDetailModel.dart';
import 'package:n_fintech/Model/newsModel.dart';
import 'package:n_fintech/Model/ongkirModel.dart';
import 'package:n_fintech/Model/plnModel.dart';
import 'package:n_fintech/Model/productMlmDetailModel.dart';
import 'package:n_fintech/Model/productMlmModel.dart';
import 'package:n_fintech/Model/productMlmSuplemenModel.dart';
import 'package:n_fintech/Model/profileModel.dart';
import 'package:n_fintech/Model/promosiModel.dart';
import 'package:n_fintech/Model/provinsiModel.dart';
import 'package:n_fintech/Model/royalti/levelModel.dart';
import 'package:n_fintech/Model/royalti/royaltiMemberModel.dart';
import 'package:n_fintech/Model/saldoUIModel.dart';
import 'package:n_fintech/Model/sosmed/listDetailSosmedModel.dart';
import 'package:n_fintech/Model/sosmed/listInboxSosmedModel.dart';
import 'package:n_fintech/Model/sosmed/listLikeSosmedModel.dart';
import 'package:n_fintech/Model/sosmed/listSosmedModel.dart';
import 'package:n_fintech/Model/suratModel.dart';
import 'package:n_fintech/Model/tertimoniModel.dart';
import 'package:n_fintech/Model/transferDetailModel.dart';
import 'package:n_fintech/Model/virtualAccount/getAvailableVirtualBankModel.dart';
import 'package:n_fintech/resources/LoginProvider.dart';
import 'package:n_fintech/resources/MLM/getDetailChekoutSuplemenProvider.dart';
import 'package:n_fintech/resources/PPOB/PPOBPascaProvider.dart';
import 'package:n_fintech/resources/PPOB/PPOBPraProvider.dart';
import 'package:n_fintech/resources/addressProvider.dart';
import 'package:n_fintech/resources/bankProvider.dart';
import 'package:n_fintech/resources/categoryProvider.dart';
import 'package:n_fintech/resources/cekTagihanProvider.dart';
import 'package:n_fintech/resources/configProvider.dart';
import 'package:n_fintech/resources/depositManual/detailDepositProvider.dart';
import 'package:n_fintech/resources/depositManual/historyDepositProvider.dart';
import 'package:n_fintech/resources/depositManual/listAvailableBankProvider.dart';
import 'package:n_fintech/resources/downlineProvider.dart';
import 'package:n_fintech/resources/historyPembelianProvider.dart';
import 'package:n_fintech/resources/inspirationProvider.dart';
import 'package:n_fintech/resources/islamic/islamicProvider.dart';
import 'package:n_fintech/resources/islamic/nearbyMosqueProvider.dart';
import 'package:n_fintech/resources/islamic/prayerProvider.dart';
import 'package:n_fintech/resources/memberProvider.dart';
import 'package:n_fintech/resources/myBankProvider.dart';
import 'package:n_fintech/resources/newsProvider.dart';
import 'package:n_fintech/resources/ongkirProvider.dart';
import 'package:n_fintech/resources/plnProvider.dart';
import 'package:n_fintech/resources/productMlmProvider.dart';
import 'package:n_fintech/resources/productMlmSuplemenProvider.dart';
import 'package:n_fintech/resources/profileProvider.dart';
import 'package:n_fintech/resources/promosiProvider.dart';
import 'package:n_fintech/resources/royalti/royalti.dart';
import 'package:n_fintech/resources/saldoProvider.dart';
import 'package:n_fintech/resources/sosmed/sosmed.dart';
import 'package:n_fintech/resources/testimoniProvider.dart';
import 'package:n_fintech/resources/transaction/historyProvider.dart';
import 'package:n_fintech/resources/transferProvider.dart';
import 'package:n_fintech/resources/virtualAccount/virtualAccountProvider.dart';
import 'package:n_fintech/resources/withdrawProvider.dart';

export 'promosiProvider.dart';

class Repository{
  final configProvider = ConfigProvider();
  final profileProvider = ProfileProvider();
  final promosiProvider = PromosiProvider();
  final categoryProvider = CategoryProvider();
  final newsProvider = NewsProvider();
  final productMlmProvider = ProductMlmProvider();
  final productMlmSuplemenProvider = ProductMlmSuplemenProvider();
  final ongkirProvider = OngkirProvider();
  final testiProvider = TestimoniProvider();
  final saldoProvider = SaldoProvider();
  final loginProvider = LoginProvider();
//  final pulsaProvider = PulsaProvider();
  final plnProvider = PlnProvider();
  final cekTagihan = CekTagihanProvider();
  final islamicProvider = IslamicProvider();
  final inspirationProvider = InspirationProvider();
  final transferProvider = TransferProvider();
  final downlineProvider = DownlineProvider();
  final bankProvider = BankProvider();
  final withdrawProvider = WithdrawProvider();
  final memberProvider = MemberProvider();
  final prayerProvider = PrayerProvider();
  final myBankProvider = MyBankProvider();
  final addressProvider = AddressProvider();
  final historyPembelianProvider = HistoryPembelianProvider();
  final virtualAccountProvider = VirtualAccountProvider();
  final detailCheckoutSuplemenProvider = DetailCheckoutSuplemenProvider();
  final listAvailableBankProvider = ListAvailableBankProvider();
  final detailDepositProvider = DetailDepositProvider();
  final historyDepositProvider = HistoryDepositProvider();
  final historyProvider = HistoryProvider();
  final royaltiLevelProvider = RoyaltiLevelProvider();
  final nearbyMosqueProvider = NearbyMosqueProvider();
  final ppobPascaProvider = PpobPascaProvider();
  final ppobPraProvider = PpobPraProvider();
  final sosmedProvider = SosmedProvider();

  Future<NearbyMosqueModel> fetchAllNearbyMosque(var lat, var lng) => nearbyMosqueProvider.fetchNearbyMosque(lat, lng);
  Future fetchConfig() => configProvider.fetchConfig();
  Future fetchLoginNohp(var nohp, var deviceid,var typeotp) => loginProvider.fetchLoginNoHp(nohp, deviceid,typeotp);
  Future fetchContact() => memberProvider.fetchContact();
  Future fetchMember(var id) => memberProvider.fetchMember(id);
  Future fetchCreateMyBank(var bankname,var bankcode,var acc_no, var acc_name) => myBankProvider.fetchCreateMyBank(bankname, bankcode, acc_no, acc_name);
  Future fetchdeleteMyBank(var id) => myBankProvider.fetchDeleteMyBank(id);
  Future fetchCreateMember(var pin, var name,var ismobile,var no_hp, var referral/*, var ktp*/) => memberProvider.fetchCreateMember(pin,name, ismobile, no_hp, referral/*, ktp*/);
  Future fetchUpdateMember(var name,var no_hp, var gender, var picture, var cover, var ktp) => memberProvider.fetchUpdateMember(name, no_hp, gender, picture, cover, ktp);
  Future fetchUpdatePinMember(var pin) => memberProvider.fetchUpdatePinMember(pin);
  Future<ProfileModel> fetchAllProfile() => profileProvider.fetchProfile();
  Future<BankModel> fetchAllBank() => bankProvider.fetchBank();
  Future<PromosiModel> fetchAllPromosi() => promosiProvider.fetchPromosi();
  Future<PromosiModel> fetchAllListPromosi(var page, var limit) => promosiProvider.fetchListPromosi(page, limit);
  Future<CategoryModel> fetchAllCategory() => categoryProvider.fetchCategory();
  Future<NewsModel> fetchAllHomeNews(var title) => newsProvider.fetchHomeNews(title);
  Future<DetailNewsPerCategoryModel> fetchAllDetailNewsPerCategory(var page,var limit,var title) => newsProvider.fetchDetailNewsPerCategory(page,limit,title);
  Future<NewsModel> fetchAllNews(var page, var limit) => newsProvider.fetchNews(page,limit);
  Future<ProductMlmModel> fetchAllProductMlm(var page,var limit) => productMlmProvider.fetchProductMlm(page,limit);
  Future<ProductMlmSuplemenModel> fetchAllProductMlmSuplemen(var page, var limit) => productMlmSuplemenProvider.fetchProductMlmSuplemen(page,limit);
  Future<ProductMlmDetailModel> fetchDetailProductMlmSuplemen(var id) => productMlmProvider.fetchProductDetailMlmSuplemen(id);
  Future<ProductMlmDetailModel> fetchDetailProductMlmKavling(var id) => productMlmProvider.fetchProductDetailMlmKavling(id);
  Future<ProvinsiModel> fetchAllProvinsi() => ongkirProvider.fetchProvinsi();
  Future<KotaModel> fetchAllKota(var idProv) => ongkirProvider.fetchKota(idProv);
  Future<KecamatanModel> fetchAllKecamatan(var idKota) => ongkirProvider.fetchKecamatan(idKota);
  Future<OngkirModel> fetchAllOngkir(var dari, var ke, var berat, var kurir) => ongkirProvider.fetchAllOngkir(dari, ke, berat, kurir);
  Future<General> fetchCheckout(String id,String price,String qty, String jasper, String ongkir) => productMlmProvider.fetchCheckout(id,price,qty, jasper, ongkir);
//  Future<GeneralInsertId> fetchCheckoutCart(var total,var jasper,var ongkir, var alamat, var type_alamat) => productMlmProvider.fetchCheckoutCart(total,jasper,ongkir,alamat,type_alamat);
  Future fetchCheckoutSuplemen(var id, var price, var qty, var nama,var pekerjaan, var alamat, var ktp, var kk,var npwp, var telp) => productMlmSuplemenProvider.fetchCheckoutSuplemen(id, price, qty, nama, pekerjaan, alamat, ktp, kk, npwp, telp);
  Future<NewsDetailModel> fetchDetailNews(String id) => newsProvider.fetchDetailNews(id);
  Future<TestimoniModel> fetchTesti(var param,var page, var limit) => testiProvider.fetchTesti(param,page,limit);

  Future<AuthModel> fetchLoginEmail(var email,var password) => loginProvider.fetchLoginEmail(email, password);
  Future<SaldoResponse> fetchSaldo(String saldo, String pin) => saldoProvider.fetchSaldo(saldo, pin);

//  Future<PulsaModel> fetchPulsa(var param, var nohp) => pulsaProvider.fetchPulsa(param, nohp);
//  Future fetchCheckoutPpob(var no, var code, var price, var charge) => pulsaProvider.fetchChekoutPPOB(no, code, price, charge);
  Future<PlnModel> fetchPln() => plnProvider.fetchPln();
  Future<CekTagihanModel> fetchCekTagihan(String code,String no,String idpelanggan) => cekTagihan.fetchCekTagihan(code, no, idpelanggan);

  Future<SuratModel> fetchSurat() => islamicProvider.fetchSurat();
  Future<AyatModel> fetchAyat(var idSurat, var param,var page,var limit) => islamicProvider.fetchAyat(idSurat,param,page,limit);
  Future<InspirationModel> fetchInspiration(var page, var limit) => inspirationProvider.fetchInspiration(page, limit);

  Future<GeneralInsertId> fetchTransfer(var saldo,var referral_penerima,var pesan) => transferProvider.transfer(saldo, referral_penerima, pesan);
  Future fetchWithdraw(var amount,var id_bank) => withdrawProvider.withdraw(amount, id_bank);
  Future<HistoryPenarikanModel> fetchHistoryPenarikan(var page,var limit, var from, var to) => withdrawProvider.fetchHistoryPenarikan(page, limit, from, to);

  Future<DownlineModel> fetchDownline() => downlineProvider.fetchDownline();
  Future<DownlineModel> fetchDetailDownline(var kdReff) => downlineProvider.fetchDetailDownline(kdReff);

  Future<TransferDetailModel> fetchTransferDetail(var nominal,var referral_penerima,var pesan) => transferProvider.transferDetail(nominal, referral_penerima,pesan);
  Future<PrayerModel> fetchPrayer(var long,var lat) => prayerProvider.fetchPrayer(long,lat);
  Future<MyBankModel> fetchMyBank() => myBankProvider.fetchMyBank();
  Future<AddressModel> fetchAddress() => addressProvider.fetchAlamat();
  Future<GetAddressModel> fetchGetAddress(var id) => addressProvider.fetchGetAddress(id);
  Future fetchUpdateAddress(var title,var name,var main_address,var kd_prov,var kd_kota, var kd_kec, var no_hp, var id) => addressProvider.fetchUpdateMyBank(title, name, main_address, kd_prov, kd_kota, kd_kec, no_hp, id);
  Future fetchCreateAddress(var title,var name,var main_address,var kd_prov,var kd_kota, var kd_kec, var no_hp) => addressProvider.fetchCreateAddress(title, name, main_address, kd_prov, kd_kota, kd_kec, no_hp);
  Future<HistoryPembelianTanahModel> fetchHistoryPembelianTanah(var page, var limit, var from, var to) => historyPembelianProvider.fetchHistoryPembelianTanah(page,limit,from,to);
  Future<HistoryPembelianSuplemenModel> fetchHistoryPembelianSuplemen(var page,var limit, var from, var to) => historyPembelianProvider.fetchHistoryPembelianSuplemen(page,limit, from,to);
  Future<HistoryPpobModel> fetchHistoryPPOB(var page, var limit, var from, var to) => historyPembelianProvider.fetchHistoryPPOB(page,limit,from,to);
  Future<GetAvailableVirtualModel> fetchAvailableBank() => virtualAccountProvider.fetchAvailableBank();
  Future fetchCreateAvailableVirtualBank(var amount,var name,var bankcode) => virtualAccountProvider.fetchCreateAvailableVirtualBank(amount, name, bankcode);
  Future fetchTransferBonus(var saldo) => transferProvider.transferBonus(saldo);
  Future fetchDetailHistoryPPOB(var kdTrx) => historyPembelianProvider.fetchDetailHistoryPPOB(kdTrx);

  Future fetchDetailCheckoutSuplemen() => detailCheckoutSuplemenProvider.fetchDetailCheckoutSuplemen();
  Future<ListCartModel> fetchListCart() => productMlmSuplemenProvider.fetchListCart();
//  Future fetchdeleteCart(var id) => productMlmSuplemenProvider.deleteCart(id);
//  Future fetchChekcoutSuplemen(var total,var jasper,var ongkir, var alamat) => productMlmProvider.fetchCheckoutCart(total, jasper, ongkir, alamat);

  //######################################### DEPOSIT MANUAL ##########################################//
  Future<ListAvailableBankModel> fetchAllListAvailableBank() => listAvailableBankProvider.fetchListAvailableBank();
  Future<DetailDepositModel> fetchDetailDeposit(var id_bank,var amount) => detailDepositProvider.fetchDetailDeposit(id_bank, amount);
  Future<General> fetchUploadBuktiTransfer(var id_deposit,var bukti) => detailDepositProvider.fetchUploadBuktiTransfer(id_deposit, bukti);
  Future<HistoryDepositModel> fetchHistoryDeposit(var page,var limit,var from, var to) => historyDepositProvider.fetchHistoryDeposit(page, limit,from,to);

  //######################################### TRANSACTION #############################################//
  Future<HistoryModel> fetchHistory(var param,var page,var limit,var from,var to, var q) => historyProvider.fetchHistory(param,page, limit, from, to,q);

  //######################################### HISTORY PEMBELIAN #######################################//
  Future<DetailHistoryPembelianSuplemenModel> fetchDetailHistoryPembelianSuplemen(var id) => historyPembelianProvider.fetchdetailHistoryPembelianSuplemen(id);
  Future fetchResi(var resi,var kurir) => historyPembelianProvider.fetchResi(resi, kurir);

  //######################################### ROYALTI #################################################//
  Future<LevelModel> fetchLevel() => royaltiLevelProvider.fetchLevel();
  Future<RoyaltiMemberModel> fetchRoyaltiMember(var param) => royaltiLevelProvider.fetchRoyaltiMember(param);

  //######################################### ISLAMIC #################################################//
  Future<CheckFavModel> fetchCheckFav(var param) => islamicProvider.fetchCheckFav(param);
  Future<CategoryDoaModel> fetchCategoryDoaHadist(var type) => islamicProvider.fetchCategoryDoaHadist(type);
  Future<SubCategoryDoaModel> fetchSubCategoryDoaHadist(var type,var id) => islamicProvider.fetchSubCategoryDoaHadist(type,id);
  Future<KalenderHijriahModel> fetchKalendetHijriah(var bln, var thn) => islamicProvider.fetchKalenderHijriah(bln, thn);
  Future<DoaModel> fetchDoaHadist(var type, var id, var q) => islamicProvider.fetchDoaHadist(type, id, q);

  //######################################### PPOB PASCA #################################################//
  Future<PpobPascaModel> fetchPpobPasca(var type) => ppobPascaProvider.fetchPpobPasca(type);
  Future fetchPpobPascaCekTagihan(var code,var no,var idpelanggan) => ppobPascaProvider.fetchPpobPascaCekTagihan(code, no, idpelanggan);
  Future fetchPpobPascaCheckout(var code,var orderid,var price) => ppobPascaProvider.fetchPpobPascaCheckout(code, orderid, price);
  //######################################### PPOB PRA #################################################//
  Future<PpobPraModel> fetchPpobPra(var type,var nohp) => ppobPraProvider.fetchPpobPra(type,nohp);
  Future fetchCheckoutPpobPra(var no, var code, var price, var charge,var idpelanggan) => ppobPraProvider.fetchChekoutPPOBPra(no, code, price, charge,idpelanggan);

  //######################################### SOSIAL MEDIA #################################################//
  Future<ListSosmedModel> fetchListSosmed(var page, var limit,var param) => sosmedProvider.fetchListSosmed(page,limit,param);
  Future<ListInboxSosmedModel> fetchListInboxSosmed(var page, var limit) => sosmedProvider.fetchListInboxSosmed(page,limit);
  Future<ListDetailSosmedModel> fetchListDetailSosmed(var id) => sosmedProvider.fetchListDetailSosmed(id);
  Future<ListLikeSosmedModel> fetchListLikeSosmed(var id) => sosmedProvider.fetchListLikeSosmed(id);


}

