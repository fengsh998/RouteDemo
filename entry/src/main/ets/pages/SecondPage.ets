import router from '@ohos.router';
@Entry({routeName:'com.Entry.secondpage'})
@Component
export struct SecondPage {
  build() {
    Row() {
      Column() {
        Text("SecondPage")
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