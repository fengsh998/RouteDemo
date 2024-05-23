import router from '@ohos.router';
// import '@Demo/AM'
@Entry({routeName:'com.BModule.firstpage'})
@Component
export struct BFirstPage {

  build() {
    Row() {
      Column() {
        Text('B模块的页面1')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button("A模块页面2")
          .width('200vp')
          .height('40vp')
          .onClick(()=>{
            router.pushNamedRoute({
              name:'com.AModule.secondpage'
            },router.RouterMode.Standard,(err,data) => {
              console.log(`>>>>:${err},${data}`)
            })
          })

        Button("Entry模块的页面2")
          .width('200vp')
          .height('40vp')
          .onClick(()=>{
            router.pushNamedRoute({
              name:'com.Entry.secondpage'
            },router.RouterMode.Standard,(err,data) => {
              console.log(`>>>>:${err},${data}`)
            })
          })


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