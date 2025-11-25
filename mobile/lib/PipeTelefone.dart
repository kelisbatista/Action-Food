class PipeTelefone {

  static String pipeTelefone(String telefone) {

  final digits = telefone.replaceAll(RegExp(r'[^0-9]'), '');

  if (digits.length < 10) return telefone; 

  final ddd = digits.substring(0, 2);
  final parte1 = digits.substring(2, 7);
  final parte2 = digits.substring(7);
  return '($ddd) $parte1-$parte2';
}

}