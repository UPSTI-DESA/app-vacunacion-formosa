enum ProviderResultType { Success, Error }

class ProviderResult {
  final ProviderResultType _type;
  final String? _message;

  const ProviderResult(
    ProviderResultType type, {
    String? message,
  })  : _type = type,
        _message = message;

  ProviderResultType get type => _type;
  String? get message => _message;

  bool get isSuccess => _type == ProviderResultType.Success;
  bool get isError => _type == ProviderResultType.Error;
}
