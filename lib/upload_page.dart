import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:testtete/upload_controller.dart';

class UploadPage extends GetView<UploadController> {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
          child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Icon(
                Icons.close_sharp,
                color: Colors.black,
              )),
        ),
        title: const Text(
          'New Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _imagePreview()),
          SliverList(delegate: SliverChildListDelegate([_header()])),
          sliverGrid(), // SliverGrid 부문
        ],
      ),
    );
  }

  Widget _imagePreview() {
    var width = Get.width;
    return Container(
      width: width,
      height: width,
      color: Colors.amber,
      child: Obx(
        () => _photoWidget(
          controller.selectedImage.value,
          width.toInt(),
          builder: (data) {
            return Image.memory(
              data,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: Get.context!,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                isScrollControlled: controller.albums.length > 5 ? true : false,
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(Get.context!).size.height - MediaQuery.of(Get.context!).padding.top),
                builder: (_) => SizedBox(
                  height: controller.albums.length > 5 ? Size.infinite.height : controller.albums.length * 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black54,
                          ),
                          width: 40,
                          height: 4,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(
                              controller.albums.length,
                              (index) => Container(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                child: Text(controller.albums[index].name),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Obx(
                    () => Text(
                      controller.headerTitle.value,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xff808080),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.web_stories,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      '여러 항목 선택',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff808080),
                ),
                // borderRadius: BorderRadius.circular(10),)),
                child: IconButton(
                  icon: const Icon(Icons.photo_camera_outlined),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget sliverGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      delegate: SliverChildBuilderDelegate(
        childCount: 10,
        (context, index) {
          return _photoWidget(
            controller.imageList[index],
            200,
            builder: (data) {
              return GestureDetector(
                onTap: () {
                  controller.changeSelectedImage(controller.imageList[index]);
                },
                child: Obx(
                  () => Opacity(
                    opacity: controller.imageList[index] == controller.selectedImage.value ? 0.3 : 1,
                    child: Image.memory(
                      data,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _photoWidget(AssetEntity asset, int size, {required Widget Function(Uint8List) builder}) {
    return FutureBuilder(
      future: asset.thumbnailDataWithSize(ThumbnailSize(size, size)),
      builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.hasData) {
          return builder(snapshot.data!);
        } else {
          return Container();
        }
      },
    );
  }
}
