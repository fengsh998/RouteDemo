import router from '@ohos.router';
@Entry({routeName:'com.AModule.secondpage'})
@Component
export struct ASecondPage {
  build() {
    Row() {
      Column() {
        Text('A模块的第二个页面')
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