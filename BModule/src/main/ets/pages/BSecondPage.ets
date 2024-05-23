import router from '@ohos.router';

@Entry
@Component
struct BSecondPage {

  build() {
    Row() {
      Column() {
        Text('B模块的页面2')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button("返回")
          .width('200vp')
          .height('40vp')
          .onClick(this.onBack.bind(this))
      }
      .width('100%')
    }
    .height('100%')
  }

  onBack() {
    router.back()
  }
}