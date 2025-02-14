import 'package:biblioteca/data/models/paises_model.dart';
import 'package:biblioteca/data/services/paises_service.dart';
import 'package:flutter/foundation.dart';

class PaisesProvider extends ChangeNotifier {
  final PaisService _paisesService = PaisService();
  bool _isLoading = false;
  String? _error;
  List<Pais> _paises = [];
  

  final num idDaSessao;
  final String usuarioLogado;

  PaisesProvider(this.idDaSessao, this.usuarioLogado);

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasErrors => _error != null;
  List<Pais> get paises => [..._paises];

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> loadPaises() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final paisesAtingidos = await _paisesService.fetchPaises(idDaSessao, usuarioLogado);
      print("Paises Atingidos recebidos: ${paisesAtingidos.paisesAtingidos}");
      if (!listEquals(_paises, paisesAtingidos.paisesAtingidos)) {
        _paises = paisesAtingidos.paisesAtingidos;
      } else {
        print("Listas são iguais");
      }
    } catch (e) {
      _error = "Erro ao carregar os países: \n$e";
      print("erro no provider $_error");
    } finally {
      print("Paises carregados pelo provider: $_paises");
      _isLoading = false;

      notifyListeners();
    }
  }
}
