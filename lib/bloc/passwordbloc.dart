import 'dart:async';

import 'package:pass_protect/model/passwordclass.dart';
import 'package:pass_protect/database/db.dart';

class PasswordBloc{
  PasswordBloc(){
    getPasswords();
  }

  final _passwordController = StreamController<List<Password>>.broadcast();
  get passwords => _passwordController.stream;

  dispose(){
    _passwordController.close();
  }

  getPasswords() async{
    _passwordController.sink.add(await DBProvider.db.getAllPassword());
  }

  Future<List<Password>> getAllPassword() async{
    return await DBProvider.db.getAllPassword();
  }

  add(Password password){
    DBProvider.db.newPassword(password);
    getPasswords();
  }

  update(Password password){
    DBProvider.db.updatePassword(password);
    getPasswords();
  }

  delete(int id){
    DBProvider.db.deletePassword(id);
    getPasswords();
  }

  deleteAll(){
    DBProvider.db.deleteAllPassword();
    getPasswords();
  }
}