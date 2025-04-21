enum Role {
  admin,
  customer,
  customerSeller;

  String get value {
    switch (this) {
      case Role.admin:
        return 'ADMIN';
      case Role.customer:
        return 'CUSTOMER';
      case Role.customerSeller:
        return 'CUSTOMER_SELLER';
    }
  }

  String get label {
    switch (this) {
      case Role.admin:
        return 'Administrador';
      case Role.customer:
        return 'Cliente';
      case Role.customerSeller:
        return 'Cliente Vendedor';
    }
  }
}
