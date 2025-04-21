class CurrencyFormatRemover {
  static double parseBrl(String formatted) {
    // 1) Remove tudo que não seja dígito ou vírgula/ponto
    var sanitized = formatted.replaceAll(RegExp(r'[^\d,\.]'), '');

    // 2) Separa parte inteira da decimal
    //    Remove pontos de milhar na parte inteira e troca vírgula por ponto na parte decimal
    if (sanitized.contains(',')) {
      // Ex: "1.890,00" -> ["1.890","00"]
      final parts = sanitized.split(',');
      final integerPart = parts[0].replaceAll('.', '');
      final decimalPart = parts.length > 1 ? parts[1] : '0';
      sanitized = '$integerPart.$decimalPart';
    } else {
      // não há vírgula decimal, só remove pontos de milhar
      sanitized = sanitized.replaceAll('.', '');
    }

    return double.parse(sanitized);
  }
}
