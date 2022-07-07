import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadController extends GetxController {
  var albums = <AssetPathEntity>[];
  RxString headerTitle = ''.obs;
  RxList<AssetEntity> imageList = <AssetEntity>[].obs;
  Rx<AssetEntity> selectedImage = const AssetEntity(
    id: '0',
    typeInt: 0,
    width: 0,
    height: 0,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    _loadPhotos();
  }

  void _loadPhotos() async {
    var result = await PhotoManager.requestPermissionExtend();

    if (result.isAuth) {
      albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(minWidth: 100),
          ),
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false)
          ],
        ),
      );
      _loadData();
    } else {
      print('error');
    }
  }

  void _loadData() async {
    if (albums.isEmpty) return;
    changeAlbum(albums.first);
  }

  Future<void> _paginPhotos(AssetPathEntity album) async {
    var photos = await album.getAssetListPaged(size: 20, page: 0);
    imageList.addAll(photos);
    if (imageList.isEmpty) return;
    changeSelectedImage(imageList.first);
  }

  changeSelectedImage(AssetEntity image) {
    selectedImage(image);
  }

  changeAlbum(AssetPathEntity album) async {
    headerTitle(album.name);
    await _paginPhotos(album);
  }
}
