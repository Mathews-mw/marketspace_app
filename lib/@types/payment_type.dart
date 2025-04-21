enum PaymentType {
  pix,
  boleto,
  debito,
  credito,
  dinheiro,
  deposito;

  String get value {
    switch (this) {
      case PaymentType.pix:
        return 'PIX';
      case PaymentType.boleto:
        return 'BOLETO';
      case PaymentType.debito:
        return 'DEBITO';
      case PaymentType.credito:
        return 'CREDITO';
      case PaymentType.dinheiro:
        return 'DINHEIRO';
      case PaymentType.deposito:
        return 'DEPOSITO';
    }
  }

  String get label {
    switch (this) {
      case PaymentType.pix:
        return 'Pix';
      case PaymentType.boleto:
        return 'Boleto';
      case PaymentType.debito:
        return 'Débito';
      case PaymentType.credito:
        return 'Cartão de Crédito';
      case PaymentType.dinheiro:
        return 'Dinheiro';
      case PaymentType.deposito:
        return 'Depósito bancário';
    }
  }
}
