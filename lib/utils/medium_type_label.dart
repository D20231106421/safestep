String mediumTypeLabel(String type) {
  switch (type.toLowerCase()) {
    case 'email':
      return 'EMEL';
    case 'sms':
      return 'SMS';
    case 'whatsapp':
      return 'WHATSAPP';
    case 'phone':
      return 'TELEFON';
    default:
      return type.toUpperCase();
  }
}
