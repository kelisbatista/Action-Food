import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pix_flutter/pix_flutter.dart';

class PixService {
  PixFlutter? pix;

  Future<void> carregarPix(String idEstab, String valorPedido) async {
    final doc = await FirebaseFirestore.instance
        .collection('estabelecimentos')
        .doc(idEstab)
        .get();

    if (!doc.exists) throw Exception("Estabelecimento não encontrado");
    final data = doc.data() as Map<String, dynamic>;

    pix = PixFlutter(
      payload: Payload(
        pixKey: data['chavePix'],
        merchantName: data['nome'],
        amount:
            (valorPedido),
      ),
    );
  }
}