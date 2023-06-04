part of 'bloc.dart';

// Cubit that provides random banner image from the list of urls.
// It updates the banner image every 5 seconds.
// It also updates the list of urls when new data is available.
// It is used in CollapsibleHeader widget.
class MovieBannerProvider extends Cubit<Uint8List?> {
  final random = Random();
  final Set<String> urls = {};
  final Map<String, Uint8List> bannerImages = {};
  Timer? _timer;

  MovieBannerProvider() : super(null);

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _getRandomUrl() async {
    // Reset the Timer
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) => _getRandomUrl(),
    );

    try {
      if (urls.isEmpty) return;

      final url = urls.elementAt(random.nextInt(urls.length));
      if (bannerImages.containsKey(url)) {
        emit(bannerImages[url]);
        return;
      }

      final imageBinary = await ApiService().loadImageBinary(url);
      if (imageBinary != null) {
        bannerImages[url] = imageBinary;
        emit(imageBinary);
      }
    } catch (e) {
      return null;
    }
  }

  void updateBannerUrlsList(List<String> newUrls) {
    // If this is the first update for banner urls, then trigger _getRandomUrl after updating the set.
    final shouldReload = urls.isEmpty;
    urls.addAll(newUrls);
    if (shouldReload) _getRandomUrl();
  }
}
