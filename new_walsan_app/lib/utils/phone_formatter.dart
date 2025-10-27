String formatPhoneToInternational(String phone) {
  String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
  if (cleaned.startsWith('08')) {
    return '62${cleaned.substring(1)}';
  }
  if (cleaned.startsWith('62')) {
    return cleaned;
  }
  return cleaned;
}
